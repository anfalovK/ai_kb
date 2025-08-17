#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_DIR="$SCRIPT_DIR/../services/quivr_src"

if [ ! -d "$REPO_DIR" ]; then
  git clone --depth 1 https://github.com/QuivrHQ/quivr.git "$REPO_DIR"
fi

cd "$REPO_DIR"

sedi() {
  if sed --version >/dev/null 2>&1; then
    sed -i "$1" "$2"
  else
    sed -i '' "$1" "$2"
  fi
}

sedi 's/3000:3000/4000:3000/' docker-compose.yml
sedi 's/8000:8000/4002:8000/' docker-compose.yml

docker compose pull || true
docker compose up -d
