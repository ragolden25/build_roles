#!/bin/bash
set -euo pipefail

VERSION="$1"
QUARTER="$2"

OUTPUT="/opt/ansible/build/grafana_stack/grafana/${QUARTER}/ccop-grafana-${VERSION}.tar.gz"

docker save ccop/grafana:"${VERSION}" | gzip -c > "${OUTPUT}"

echo "Saved functional grafana ${VERSION} to ${OUTPUT}"
