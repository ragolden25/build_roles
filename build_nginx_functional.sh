#!/bin/bash
set -euo pipefail

VERSION="$1"
QUARTER="$2"

BUILD_ROOT="/opt/ansible/build/grafana_stack/nginx/${QUARTER}"

cd "${BUILD_ROOT}"

echo "Building nginx FUNCTIONAL image ${VERSION} for ${QUARTER}..."

docker build --no-cache \
  --build-arg NGINX_VERSION="${VERSION}" \
  -t "ccop/nginx:${VERSION}" \
  -f Dockerfile.nginx.functional \
  .

echo "${VERSION}" > "${BUILD_ROOT}/VERSION.functional"

echo "nginx functional ${VERSION} build complete."
