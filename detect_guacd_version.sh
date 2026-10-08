#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="/opt/ansible/build/guacd/guacd.env"

LATEST_TAG=$(curl -s https://api.github.com/repos/apache/guacamole-server/tags \
    | jq -r '.[0].name')

mkdir -p "$(dirname "$ENV_FILE")"

echo "GUACD_LATEST_VERSION=$LATEST_TAG" > "$ENV_FILE"

echo "$LATEST_TAG"
