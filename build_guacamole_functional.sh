#!/bin/bash
set -e

VERSION="$1"
QUARTER="$2"

BUILD_ROOT="/opt/ansible/build/guacamole/${QUARTER}"

cd "${BUILD_ROOT}"

docker build \
  -f Dockerfile.guacamole.functional \
  -t ccop/guacamole:1.6.0 \
  .
