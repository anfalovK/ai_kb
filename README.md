# AHelper MVP Stack (без Ollama/PlantUML)

## Требования
Docker + docker compose, git, curl, bash.

## Быстрый старт
```bash
./scripts/setup.sh
./scripts/status.sh
```

## Сервисы
- PostgREST: http://localhost:3001
- n8n:       http://localhost:5678 (basic auth: admin / сгенерированный пароль)
- Quivr FE:  http://localhost:3000
- Quivr BE:  http://localhost:8000

## Пример
Создать задачу через PostgREST:
```bash
curl -X POST http://localhost:3001/tasks \
  -H 'Content-Type: application/json' \
  -d '{"project_id":"<uuid>", "title":"Test"}'
```
