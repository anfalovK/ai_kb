#!/usr/bin/env bash
set -euo pipefail

source .env

SKIP_QUIVR=${1:-}

wait_for_http() {
  local url=$1
  until curl -sf "$url" >/dev/null 2>&1; do
    sleep 1
    echo "waiting for $url"
  done
}

until docker compose exec -T postgres pg_isready -U "$OPS_DB_USER" >/dev/null 2>&1; do
  sleep 1
  echo "waiting for postgres..."
done

wait_for_http "http://localhost:${POSTGREST_PORT}/"
wait_for_http "http://localhost:${N8N_PORT}/"
wait_for_http "http://localhost:${PLANTUML_PORT}/"
wait_for_http "http://localhost:${OLLAMA_PORT}/api/tags"

if [ "$SKIP_QUIVR" != "--skip-quivr" ]; then
  wait_for_http "http://localhost:4000/"
  wait_for_http "http://localhost:4002/api/health"
fi
