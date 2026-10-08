#!/bin/bash
set -euo pipefail

VERSION="$1"
QUARTER="$2"

OUTPUT="/opt/ansible/build/grafana_stack/grafana/${QUARTER}/nucleus-grafana-${VERSION}.tar.gz"

docker save nucleus/grafana:"${VERSION}" | gzip -c > "${OUTPUT}"

echo "Saved hardened grafana ${VERSION} to ${OUTPUT}"
