#!/usr/bin/env bash
set -euo pipefail

QDIR="services/quivr_src"
if [[ -d "$QDIR" ]]; then
  echo "[quivr] уже склонирован в $QDIR"
else
  echo "[quivr] клонирую официальный репозиторий..."
  git clone --depth=1 https://github.com/QuivrHQ/quivr.git "$QDIR"
fi

pushd "$QDIR" >/dev/null
echo "[quivr] запускаю docker compose из их репозитория..."
docker compose up -d
popd >/dev/null

echo "[quivr] фронт: http://localhost:3000  бекенд: http://localhost:8000"
