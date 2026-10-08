#!/bin/bash
set -euo pipefail

VERSION="$1"
QUARTER="$2"

BUILD_ROOT="/opt/ansible/build/guacd/${QUARTER}"
DOCKERFILE="${BUILD_ROOT}/Dockerfile.guacd.hardened"

cd "${BUILD_ROOT}"

echo "Building hardened guacd ${VERSION} for ${QUARTER}..."

docker build --no-cache \
  -t "nucleus/guacd:${VERSION}" \
  -f "$DOCKERFILE" \
  .

echo "${VERSION}" > "${BUILD_ROOT}/VERSION"

echo "Hardened guacd ${VERSION} build complete."
