#!/bin/bash
set -euo pipefail

VERSION="$1"
QUARTER="$2"

BUILD_ROOT="/opt/ansible/build/grafana_stack/grafana/${QUARTER}"

cd "${BUILD_ROOT}"

echo "Building grafana FUNCTIONAL image ${VERSION} for ${QUARTER}..."

docker build --no-cache \
  --build-arg GRAFANA_VERSION="${VERSION}" \
  -t "ccop/grafana:${VERSION}" \
  -f Dockerfile.grafana.functional \
  .

echo "${VERSION}" > "${BUILD_ROOT}/VERSION.functional"

echo "grafana functional ${VERSION} build complete."
