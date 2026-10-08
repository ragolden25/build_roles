#!/bin/bash
set -euo pipefail

VERSION="$1"
QUARTER="$2"

OUTPUT="/opt/ansible/build/nginx/${QUARTER}/ccop-nginx-${VERSION}.tar.gz"

docker save ccop/nginx:"${VERSION}" | gzip -c > "${OUTPUT}"

echo "Saved functional nginx ${VERSION} to ${OUTPUT}"
