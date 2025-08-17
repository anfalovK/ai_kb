#!/usr/bin/env bash
set -euo pipefail
. ./.env

JWT="$(python3 - <<'PY'
import jwt,uuid,datetime
secret=open('.env').read().split('POSTGREST_JWT_SECRET=')[1].splitlines()[0]
aud=open('.env').read().split('POSTGREST_JWT_AUD=')[1].splitlines()[0]
uid=str(uuid.uuid4())
tok=jwt.encode({"aud":aud,"user_id":uid,"iat":int(datetime.datetime.now().timestamp())},
              secret,algorithm="HS256")
print(tok)
PY
)"

curl -fsS -H "Authorization: Bearer $JWT" -H "Content-Type: application/json" \
  -d '{"username":"sky"}' "http://localhost:${POSTGREST_PORT}/users" || true
echo
