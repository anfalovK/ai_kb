#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

rand_b64(){ openssl rand -base64 48 | tr -d '\n=' | cut -c1-48; }
rand_pass(){ openssl rand -hex 16; }

cd "$ROOT_DIR"

if [[ ! -f .env ]]; then
  cp .env.example .env
fi

OPS_DB_PASSWORD="$(rand_pass)"
POSTGREST_JWT_SECRET="$(rand_b64)"
N8N_BASIC_AUTH_PASSWORD="$(rand_pass)"

tmp="$(mktemp)"
awk -v DBP="$OPS_DB_PASSWORD" -v JWT="$POSTGREST_JWT_SECRET" -v N8NP="$N8N_BASIC_AUTH_PASSWORD" '
BEGIN{FS=OFS="="}
$1=="OPS_DB_PASSWORD"{$2=DBP}
$1=="POSTGREST_DB_URI"{
  gsub(/postgres:\/\/ops_user:[^@]*@postgres:5432\/opsdb/,"postgres://ops_user:" DBP "@postgres:5432/opsdb",$0)
}
$1=="POSTGREST_JWT_SECRET"{$2=JWT}
$1=="N8N_BASIC_AUTH_PASSWORD"{$2=N8NP}
{print}
' .env > "$tmp" && mv "$tmp" .env

echo "[generate-env] .env обновлён."
