#!/bin/bash
set -euo pipefail

VERSION="$1"
QUARTER="$2"

OUTPUT="/opt/ansible/build/grafana_stack/prometheus/${QUARTER}/nucleus-prometheus-${VERSION}.tar.gz"

docker save nucleus/prometheus:"${VERSION}" | gzip -c > "${OUTPUT}"

echo "Saved hardened prometheus ${VERSION} to ${OUTPUT}"
