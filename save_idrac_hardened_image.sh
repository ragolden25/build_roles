#!/bin/bash
set -euo pipefail

VERSION="$1"
QUARTER="$2"

OUTPUT="/opt/ansible/build/grafana_stack/idrac/${QUARTER}/nucleus-idrac-${VERSION}.tar.gz"

docker save nucleus/idrac:"${VERSION}" | gzip -c > "${OUTPUT}"

echo "Saved hardened idrac exporter ${VERSION} to ${OUTPUT}"
