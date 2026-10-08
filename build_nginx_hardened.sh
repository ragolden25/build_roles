#!/bin/bash
set -euo pipefail

VERSION="$1"
QUARTER="$2"

BUILD_ROOT="/opt/ansible/build/grafana_stack/nginx/${QUARTER}"

cd "${BUILD_ROOT}"

echo "Building nginx HARDENED image ${VERSION} for ${QUARTER}..."

docker build --no-cache \
  --build-arg NGINX_VERSION="${VERSION}" \
  -t "nucleus/nginx:${VERSION}" \
  -f Dockerfile.nginx.hardened \
  .

echo "${VERSION}" > "${BUILD_ROOT}/VERSION.hardened"

echo "nginx hardened ${VERSION} build complete."
