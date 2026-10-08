#!/bin/bash
set -euo pipefail

VERSION="$1"
QUARTER="$2"

BUILD_ROOT="/opt/ansible/build/grafana_stack/idrac/${QUARTER}"

cd "${BUILD_ROOT}"

echo "Building idrac exporter FUNCTIONAL image ${VERSION} for ${QUARTER}..."

docker build --no-cache \
  --build-arg IDRAC_EXPORTER_VERSION="${VERSION}" \
  -t "ccop/idrac:${VERSION}" \
  -f Dockerfile.idrac.functional \
  .

echo "${VERSION}" > "${BUILD_ROOT}/VERSION.functional"

echo "idrac exporter functional ${VERSION} build complete."
