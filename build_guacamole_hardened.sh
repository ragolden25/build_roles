#!/bin/bash
set -euo pipefail

VERSION="$1"
QUARTER="$2"

BUILD_ROOT="/opt/ansible/build/guacamole/${QUARTER}"

cd "${BUILD_ROOT}"

echo "Building hardened Guacamole image..."

docker build --no-cache \
  -f Dockerfile.guacamole.hardened \
  -t nucleus/guacamole:1.6.0 \
  .

echo "Hardened Guacamole build complete."
