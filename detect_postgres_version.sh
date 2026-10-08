#!/usr/bin/env bash
set -euo pipefail

STAGED_ROOT="/opt/ansible/staged/postgres"

# Find version directories (two-part MAJOR.MINOR scheme, e.g. 18.1)
mapfile -t VERSIONS < <(
    ls -1 "${STAGED_ROOT}" \
      | grep -E '^[0-9]+\.[0-9]+$' \
      | sort -V
)

if [[ ${#VERSIONS[@]} -eq 0 ]]; then
    echo "ERROR: No PostgreSQL version directories found in ${STAGED_ROOT}" >&2
    exit 1
fi

VALID_VERSIONS=()

for VERSION in "${VERSIONS[@]}"; do
    BASE_DIR="${STAGED_ROOT}/${VERSION}"
    STAGED_DIR="${BASE_DIR}/staged"
    INVENTORY="${STAGED_DIR}/inventory.env"

    [[ -f "${INVENTORY}" ]] || continue
    [[ -f "${STAGED_DIR}/opt/postgresql/${VERSION}/bin/postgres" ]] || continue
    [[ -f "${STAGED_DIR}/opt/postgresql/${VERSION}/bin/initdb" ]] || continue
    [[ -f "${STAGED_DIR}/opt/postgresql/${VERSION}/share/postgresql.conf.sample" ]] || continue

    VALID_VERSIONS+=("${VERSION}")
done

if [[ ${#VALID_VERSIONS[@]} -eq 0 ]]; then
    echo "ERROR: No fully staged PostgreSQL versions found in ${STAGED_ROOT}" >&2
    exit 2
fi

echo "${VALID_VERSIONS[-1]}"
