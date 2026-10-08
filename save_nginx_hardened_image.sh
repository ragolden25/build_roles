#!/bin/bash
set -euo pipefail

VERSION="$1"
QUARTER="$2"

OUTPUT="/opt/ansible/build/nginx/${QUARTER}/nucleus-nginx-${VERSION}.tar.gz"

docker save nucleus/nginx:"${VERSION}" | gzip -c > "${OUTPUT}"

echo "Saved hardened nginx ${VERSION} to ${OUTPUT}"
