#!/usr/bin/env bash
set -euo pipefail

source .env

BASE_URL="http://localhost:${POSTGREST_PORT}"

curl -s -H "Content-Type: application/json" \
  -d '{"id":1, "name":"Demo project", "user_id":"00000000-0000-0000-0000-000000000000"}' \
  "$BASE_URL/projects" >/dev/null

curl -s -H "Content-Type: application/json" \
  -d '{"id":1, "project_id":1, "title":"Sample task"}' \
  "$BASE_URL/tasks" >/dev/null

echo "Sample data imported"
