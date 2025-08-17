#!/usr/bin/env bash
set -euo pipefail

echo "[setup] генерирую .env..."
./scripts/generate-env.sh

echo "[setup] поднимаю сервисы (postgres, postgrest, n8n)..."
docker compose pull || true
docker compose up -d

echo "[setup] проверяю доступность..."
./scripts/healthcheck.sh || true

echo "[setup] миграции базы ops..."
./scripts/migrate-ops.sh

echo "[setup] установка Quivr..."
./scripts/install-quivr.sh

echo "[setup] готово."
echo "- PostgREST: http://localhost:$(grep '^POSTGREST_PORT=' .env | cut -d= -f2)"
echo "- n8n:       http://localhost:$(grep '^N8N_PORT=' .env | cut -d= -f2)"
echo "- Quivr FE:  http://localhost:3000"
echo "- Quivr BE:  http://localhost:8000"
