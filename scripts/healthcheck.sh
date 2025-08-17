#!/usr/bin/env bash
set -euo pipefail
. ./.env

check(){
  local name="$1" url="$2"
  for i in {1..30}; do
    if curl -fsS "$url" >/dev/null 2>&1; then
      echo "[ok] $name доступен: $url"; return 0
    fi
    sleep 2
  done
  echo "[warn] $name не ответил: $url"
}

check "PostgREST" "http://localhost:${POSTGREST_PORT}/"
check "n8n" "http://localhost:${N8N_PORT}/"
