#!/bin/bash
# play_weekly_builds.sh [component ...]
# Weekly early-warning builds. With no arguments every component runs; each one is independent.
#   play_weekly_builds.sh                      all eight
#   play_weekly_builds.sh prometheus postgres  just those
# Cron (after the Wednesday staging):  0 2 * * 4  /opt/ansible/nucleus/playbooks/play_weekly_builds.sh
set -uo pipefail
SECONDS=0
PLAYBOOK_DIR="/opt/ansible/nucleus/playbooks"

exec 9>/tmp/play_weekly_builds.lock
flock -n 9 || { echo "another weekly build run is in progress"; exit 0; }

start_time=$(date +%F-%T)
logfile="/opt/ansible/logs/weekly_builds-${start_time}.log"
echo "=== Weekly builds started at ${start_time} ===" | tee -a "$logfile"

EXTRA=()
if [[ $# -gt 0 ]]; then
  json=$(printf '"%s",' "$@"); EXTRA=(-e "{\"weekly_only\": [${json%,}]}")
fi

ansible-playbook \
  -i /opt/ansible/vars/inventory.ini \
  "${PLAYBOOK_DIR}/weekly_builds.yml" \
  --vault-password-file ~/vault_pass.txt \
  "${EXTRA[@]}" \
  2>&1 | tee -a "$logfile"
rc=${PIPESTATUS[0]}

echo "=== Weekly builds finished at $(date +%F-%T) after ${SECONDS}s (exit ${rc}) ===" | tee -a "$logfile"
exit "$rc"
