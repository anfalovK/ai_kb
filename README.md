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
- Quivr frontend: http://localhost:4000
- PostgREST: http://localhost:4001
- Quivr backend: http://localhost:4002
- n8n: http://localhost:5678
- PlantUML: http://localhost:8080
- Ollama: http://localhost:11434

## Examples
Check PostgREST:
```
curl -f http://localhost:4001/
```

Check Quivr backend health:
```
curl -f http://localhost:4002/api/health
```

n8n credentials: `admin` / generated password.

PlantUML example: `http://localhost:8080/svg/~h`
