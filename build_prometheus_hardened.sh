#!/bin/bash
set -euo pipefail

VERSION="$1"
QUARTER="$2"

BUILD_ROOT="/opt/ansible/build/grafana_stack/prometheus/${QUARTER}"

cd "${BUILD_ROOT}"

echo "Building prometheus HARDENED image ${VERSION} for ${QUARTER}..."

docker build --no-cache \
  --build-arg PROMETHEUS_VERSION="${VERSION}" \
  -t "nucleus/prometheus:${VERSION}" \
  -f Dockerfile.prometheus.hardened \
  .

echo "${VERSION}" > "${BUILD_ROOT}/VERSION.hardened"

echo "prometheus hardened ${VERSION} build complete."
