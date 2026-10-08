#!/usr/bin/env bash
set -euo pipefail

STAGED_ROOT="/opt/ansible/staged/prometheus"

# ------------------------------------------------------------
# Find all semver directories
# ------------------------------------------------------------
mapfile -t VERSIONS < <(
    ls -1 "${STAGED_ROOT}" \
      | grep -E '^[0-9]+\.[0-9]+\.[0-9]+' \
      | sort -V
)

if [[ ${#VERSIONS[@]} -eq 0 ]]; then
    echo "ERROR: No Prometheus version directories found in ${STAGED_ROOT}" >&2
    exit 1
fi

VALID_VERSIONS=()

# ------------------------------------------------------------
# Validate each version directory
# ------------------------------------------------------------
for VERSION in "${VERSIONS[@]}"; do
    BASE_DIR="${STAGED_ROOT}/${VERSION}"
    STAGED_DIR="${BASE_DIR}/staged"
    INVENTORY="${STAGED_DIR}/inventory.env"

    # Must have inventory.env
    if [[ ! -f "${INVENTORY}" ]]; then
        continue
    fi

    # Must have required staged artifacts
    if [[ ! -f "${STAGED_DIR}/prometheus" ]]; then
        continue
    fi

    if [[ ! -f "${STAGED_DIR}/promtool" ]]; then
        continue
    fi

    if [[ ! -f "${STAGED_DIR}/prometheus.yml" ]]; then
        continue
    fi

    VALID_VERSIONS+=("${VERSION}")
done

if [[ ${#VALID_VERSIONS[@]} -eq 0 ]]; then
    echo "ERROR: No fully staged Prometheus versions found in ${STAGED_ROOT}" >&2
    exit 2
fi

# ------------------------------------------------------------
# Output the latest valid version
# ------------------------------------------------------------
LATEST="${VALID_VERSIONS[-1]}"
echo "${LATEST}"
