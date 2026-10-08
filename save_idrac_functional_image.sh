#!/bin/bash
set -euo pipefail

VERSION="$1"
QUARTER="$2"

OUTPUT="/opt/ansible/build/grafana_stack/idrac/${QUARTER}/ccop-idrac-${VERSION}.tar.gz"

docker save ccop/idrac:"${VERSION}" | gzip -c > "${OUTPUT}"

echo "Saved functional idrac exporter ${VERSION} to ${OUTPUT}"
