#!/bin/bash
set -euo pipefail

VERSION="$1"
QUARTER="$2"

BUILD_ROOT="/opt/ansible/build/grafana_stack/grafana/${QUARTER}"

cd "${BUILD_ROOT}"

echo "Building grafana HARDENED image ${VERSION} for ${QUARTER}..."

docker build \
  --build-arg GRAFANA_VERSION="${VERSION}" \
  -t "nucleus/grafana:${VERSION}" \
  -f Dockerfile.grafana.hardened \
  .

echo "${VERSION}" > "${BUILD_ROOT}/VERSION.hardened"

echo "grafana hardened ${VERSION} build complete."
