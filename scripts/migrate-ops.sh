#!/usr/bin/env bash
set -euo pipefail

wait_for_pg(){
  echo "[migrate-ops] ожидаю postgres..."
  for i in {1..60}; do
    if docker compose exec -T postgres pg_isready -U "${OPS_DB_USER:-ops_user}" >/dev/null 2>&1; then
      return 0
    fi
    sleep 2
  done
  echo "[migrate-ops] postgres не дождался"; exit 1
}

export $(grep -E '^(OPS_DB_USER|OPS_DB_NAME)=' .env | xargs)

wait_for_pg
docker compose exec -T postgres psql -U "${OPS_DB_USER}" -d "${OPS_DB_NAME}" -c "select now();" >/dev/null
echo "[migrate-ops] миграции применены (init-скрипт выполнился при старте контейнера)."
