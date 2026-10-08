#!/bin/bash
set -euo pipefail

VERSION="$1"
QUARTER="$2"

OUTPUT="/opt/ansible/build/grafana_stack/prometheus/${QUARTER}/ccop-prometheus-${VERSION}.tar.gz"

docker save ccop/prometheus:"${VERSION}" | gzip -c > "${OUTPUT}"

echo "Saved functional prometheus ${VERSION} to ${OUTPUT}"
