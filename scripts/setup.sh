#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$SCRIPT_DIR/.."

./scripts/generate-env.sh

docker compose pull || true
docker compose up -d

./scripts/healthcheck.sh
./scripts/migrate-ops.sh

echo "Services running:"
echo "PostgREST: http://localhost:${POSTGREST_PORT}"
echo "n8n:      http://localhost:${N8N_PORT}"
echo "PlantUML: http://localhost:${PLANTUML_PORT}"
echo "Ollama:   http://localhost:${OLLAMA_PORT}"
echo "Quivr frontend: http://localhost:${QUIVR_FRONTEND_PORT}"
echo "Quivr backend:  http://localhost:${QUIVR_BACKEND_PORT}"
