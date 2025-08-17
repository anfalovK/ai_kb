#!/usr/bin/env bash
set -euo pipefail

ENV_FILE=".env"
EXAMPLE_FILE=".env.example"

if [ ! -f "$ENV_FILE" ]; then
  cp "$EXAMPLE_FILE" "$ENV_FILE"
fi

# Load existing values
OPS_DB_USER=$(grep '^OPS_DB_USER=' "$ENV_FILE" | cut -d= -f2)
OPS_DB_HOST=$(grep '^OPS_DB_HOST=' "$ENV_FILE" | cut -d= -f2)
OPS_DB_PORT=$(grep '^OPS_DB_PORT=' "$ENV_FILE" | cut -d= -f2)
OPS_DB_NAME=$(grep '^OPS_DB_NAME=' "$ENV_FILE" | cut -d= -f2)

sedi() {
  if sed --version >/dev/null 2>&1; then
    sed -i "$1" "$2"
  else
    sed -i '' "$1" "$2"
  fi
}

escape_sed() {
  printf '%s' "$1" | sed -e 's/[&|]/\\&/g'
}

random_hex() {
  openssl rand -hex 16
}

random_b64() {
  openssl rand -base64 48
}

OPS_DB_PASSWORD=$(random_hex)
POSTGREST_JWT_SECRET=$(random_b64)
N8N_BASIC_AUTH_PASSWORD=$(random_hex)

OPS_DB_PASSWORD_ESC=$(escape_sed "$OPS_DB_PASSWORD")
POSTGREST_JWT_SECRET_ESC=$(escape_sed "$POSTGREST_JWT_SECRET")
N8N_BASIC_AUTH_PASSWORD_ESC=$(escape_sed "$N8N_BASIC_AUTH_PASSWORD")

sedi "s|^OPS_DB_PASSWORD=.*|OPS_DB_PASSWORD=$OPS_DB_PASSWORD_ESC|" "$ENV_FILE"
sedi "s|^POSTGREST_JWT_SECRET=.*|POSTGREST_JWT_SECRET=$POSTGREST_JWT_SECRET_ESC|" "$ENV_FILE"
sedi "s|^N8N_BASIC_AUTH_PASSWORD=.*|N8N_BASIC_AUTH_PASSWORD=$N8N_BASIC_AUTH_PASSWORD_ESC|" "$ENV_FILE"

POSTGREST_DB_URI="postgres://$OPS_DB_USER:$OPS_DB_PASSWORD@$OPS_DB_HOST:$OPS_DB_PORT/$OPS_DB_NAME"
POSTGREST_DB_URI_ESC=$(escape_sed "$POSTGREST_DB_URI")
sedi "s|^POSTGREST_DB_URI=.*|POSTGREST_DB_URI=$POSTGREST_DB_URI_ESC|" "$ENV_FILE"
