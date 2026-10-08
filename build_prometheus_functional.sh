#!/bin/bash
set -euo pipefail

VERSION="$1"
QUARTER="$2"

BUILD_ROOT="/opt/ansible/build/grafana_stack/prometheus/${QUARTER}"

cd "${BUILD_ROOT}"

echo "Building prometheus FUNCTIONAL image ${VERSION} for ${QUARTER}..."

docker build --no-cache \
  --build-arg PROMETHEUS_VERSION="${VERSION}" \
  -t "ccop/prometheus:${VERSION}" \
  -f Dockerfile.prometheus.functional \
  .

echo "${VERSION}" > "${BUILD_ROOT}/VERSION.functional"

echo "prometheus functional ${VERSION} build complete."
