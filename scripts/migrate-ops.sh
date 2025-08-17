#!/usr/bin/env bash
set -euo pipefail

source .env

until docker compose exec -T postgres pg_isready -U "$OPS_DB_USER" >/dev/null 2>&1; do
  sleep 1
  echo "waiting for postgres..."
done

docker compose exec -T postgres psql -U "$OPS_DB_USER" -d "$OPS_DB_NAME" -f /docker-entrypoint-initdb.d/01_ops_schema.sql
