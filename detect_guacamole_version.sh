#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="/opt/ansible/build/guacamole/guacamole.env"

LATEST_TAG=$(curl -s https://api.github.com/repos/apache/guacamole-client/tags \
    | jq -r '.[0].name')

mkdir -p "$(dirname "$ENV_FILE")"

echo "GUACAMOLE_LATEST_VERSION=$LATEST_TAG" > "$ENV_FILE"

echo "$LATEST_TAG"

