#!/bin/bash
set -euo pipefail

VERSION="$1"
QUARTER="$2"

BUILD_ROOT="/opt/ansible/build/grafana_stack/idrac/${QUARTER}"

cd "${BUILD_ROOT}"

echo "Building idrac exporter HARDENED image ${VERSION} for ${QUARTER}..."

docker build --no-cache \
  --build-arg IDRAC_EXPORTER_VERSION="${VERSION}" \
  -t "nucleus/idrac:${VERSION}" \
  -f Dockerfile.idrac.hardened \
  .

echo "${VERSION}" > "${BUILD_ROOT}/VERSION.hardened"

echo "idrac exporter hardened ${VERSION} build complete."
