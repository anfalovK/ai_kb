#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$SCRIPT_DIR/.."

./scripts/generate-env.sh

docker compose pull || true
docker compose up -d

./scripts/healthcheck.sh --skip-quivr
./scripts/migrate-ops.sh
./scripts/install-quivr.sh
./scripts/healthcheck.sh

echo "Services running:"
echo "Quivr frontend: http://localhost:4000"
echo "PostgREST:      http://localhost:${POSTGREST_PORT}"
echo "Quivr backend:  http://localhost:4002"
echo "n8n:            http://localhost:${N8N_PORT}"
echo "PlantUML:       http://localhost:${PLANTUML_PORT}"
echo "Ollama:         http://localhost:${OLLAMA_PORT}"
