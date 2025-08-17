#!/usr/bin/env bash
set -euo pipefail

source .env

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
wait_for_http "http://localhost:${OLLAMA_PORT}/"
wait_for_http "http://localhost:${QUIVR_BACKEND_PORT}/"
wait_for_http "http://localhost:${QUIVR_FRONTEND_PORT}/"
