# ahelper-mvp-stack

On-premise MVP stack composed of Quivr, PostgREST, n8n, PlantUML, Ollama and PostgreSQL.

## Requirements
- Docker with compose plugin
- bash

## Quick start
```
./scripts/setup.sh
./scripts/status.sh
```

## Services
- PostgREST: http://localhost:3001
- n8n: http://localhost:5678
- PlantUML: http://localhost:8080
- Ollama: http://localhost:11434
- Quivr frontend: http://localhost:3000
- Quivr backend: http://localhost:8000

## Example
Create task via PostgREST:
```
curl -X POST http://localhost:3001/tasks \
  -H 'Content-Type: application/json' \
  -d '{"project_id":"<uuid>", "title":"Test"}'
```

n8n credentials: `admin` / generated password.

Quivr UI available at `http://localhost:3000`.

PlantUML example: `http://localhost:8080/svg/~h`
