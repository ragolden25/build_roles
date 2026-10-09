#!/usr/bin/env bash
# =====================================================================
# emit_release_ledger.sh -- which version of each component did each QUARTER release?
#
# READ-ONLY on the build tree. For every quarter directory of every component it records the
# version of the ccop (functional) and nucleus (hardened) image and the date it was built,
# so the dashboard can answer "for fy27q1 we released Grafana X" at any time.
#
# Where the version comes from, first match wins (per component / quarter / class):
#   1. VERSION.functional / VERSION.hardened   (written by the build_<image>_<flavor>.sh scripts)
#   2. VERSION                                 (written by the guacd build scripts)
#   3. the saved image  ccop-<image>-<ver>.tar.gz / nucleus-<image>-<ver>.tar.gz
#   4. ARG GUAC_VERSION in Dockerfile.guacamole.<flavor> (guacamole's build scripts write no version)
# The build date is the modification time of that file. In the newest quarter a class with no version
# yet is recorded as version "-" (not built yet).
#
# Metric (node_exporter textfile collector, one atomic file):
#   release_build_info{stack,class,component,image,quarter,version}   build time, unix seconds
#
# Install:  /usr/local/bin/emit_release_ledger.sh   (mode 0755, root, on ansible-forge)
# Cron:     15 7 * * * /usr/local/bin/emit_release_ledger.sh
# =====================================================================
set -u
TEXTFILE_DIR="${TEXTFILE_DIR:-/var/lib/node_exporter/textfile}"
BUILD_ROOT="${BUILD_ROOT:-/opt/ansible/build}"

# stack | component (= image) | build dir under BUILD_ROOT
COMPONENTS=(
  "grafana|grafana|grafana_stack/grafana"
  "grafana|prometheus|grafana_stack/prometheus"
  "grafana|idrac|grafana_stack/idrac"
  "grafana|nginx|grafana_stack/nginx"
  "guac|guacamole|guacamole"
  "guac|guacd|guacd"
  "guac|postgres|postgres"
  "guac|nginx|nginx"
)
CLASSES=("ccop|functional" "nucleus|hardened")

esc() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g' | tr -d '\r\n'; }
read_ver() { tr -d '[:space:]' < "$1" 2>/dev/null; }

body=""
for row in "${COMPONENTS[@]}"; do
  IFS='|' read -r stack comp dir <<<"$row"
  newest="$(ls -1d "${BUILD_ROOT}/${dir}"/fy[0-9][0-9]q[1-4] 2>/dev/null | sort | tail -n1)"
  for qdir in "${BUILD_ROOT}/${dir}"/fy[0-9][0-9]q[1-4]; do
    [[ -d "$qdir" ]] || continue
    quarter="$(basename "$qdir")"
    for cf in "${CLASSES[@]}"; do
      IFS='|' read -r cls flavor <<<"$cf"
      ver=""; src=""
      if   [[ -s "$qdir/VERSION.${flavor}" ]]; then src="$qdir/VERSION.${flavor}"; ver="$(read_ver "$src")"
      elif [[ "$comp" == guacd && -s "$qdir/VERSION" ]]; then src="$qdir/VERSION"; ver="$(read_ver "$src")"
      fi
      if [[ -z "$ver" ]]; then
        src="$(ls -1t "$qdir"/${cls}-${comp}-*.tar.gz 2>/dev/null | head -n1)"
        [[ -n "$src" ]] && ver="$(basename "$src" .tar.gz)" && ver="${ver#${cls}-${comp}-}"
      fi
      if [[ -z "$ver" && "$comp" == guacamole && -f "$qdir/Dockerfile.guacamole.${flavor}" ]]; then
        src="$qdir/Dockerfile.guacamole.${flavor}"
        ver="$(grep -hoP '^ARG GUAC_VERSION=\K[0-9][0-9A-Za-z.\-]*' "$src" | head -n1)"
      fi
      if [[ -z "$ver" || -z "$src" ]]; then
        # Newest quarter, not built yet: show it as "not built" (version "-", time 0). Older quarters are skipped.
        [[ "$qdir" == "$newest" ]] && body+="release_build_info{stack=\"${stack}\",class=\"${cls}\",component=\"${comp}\",image=\"${cls}/${comp}\",quarter=\"${quarter}\",version=\"-\"} 0"$'\n'
        continue
      fi
      when="$(stat -c %Y "$src" 2>/dev/null || echo 0)"
      body+="release_build_info{stack=\"${stack}\",class=\"${cls}\",component=\"${comp}\",image=\"${cls}/${comp}\",quarter=\"${quarter}\",version=\"$(esc "$ver")\"} ${when}"$'\n'
    done
  done
done
echo "$body" | sed '/^$/d'

mkdir -p "$TEXTFILE_DIR" 2>/dev/null
tmp="$(mktemp "${TEXTFILE_DIR}/.release_ledger.XXXXXX")" || { echo "cannot write metrics" >&2; exit 1; }
{
  echo "# HELP release_build_info Version of each component built for each quarter; value = build time (unix seconds)."
  echo "# TYPE release_build_info gauge"
  printf '%s' "$body"
} > "$tmp"
chmod 0644 "$tmp"
mv -f "$tmp" "${TEXTFILE_DIR}/release_ledger.prom"
exit 0
