# Agent README

This repository hosts the **ahelper-mvp-stack**. Follow these guidelines when modifying the repo.

## Workflow
- Use `rg` for searching within the repo.
- Keep scripts in `scripts/` executable and include `#!/usr/bin/env bash` with `set -euo pipefail`.
- Do not commit generated files such as `.env` or container data volumes.
- After modifying `docker-compose.yml`, run `docker compose config` to validate syntax.
- When editing shell scripts, run `shellcheck` and `bash -n` to ensure there are no errors.
- OpenAPI specifications live in `tools/openapi/`; keep them consistent with service APIs.

## Stack Commands
- `./scripts/generate-env.sh` – create `.env` with generated secrets.
- `./scripts/setup.sh` – pull images, start containers, run health checks and migrations.
- `./scripts/status.sh` – display running container status.
- `./scripts/healthcheck.sh` – poll service endpoints until healthy.
- `./scripts/start.sh` / `./scripts/stop.sh` – control the stack.

## Testing
- There is no formal test suite. Verify changes by running:
  - `./scripts/setup.sh`
  - `./scripts/healthcheck.sh`
  - `./scripts/status.sh`
- If Docker is unavailable, document the limitation in the PR.

## Pull Requests
- Use concise, imperative commit messages.
- Run the relevant commands above and include their outputs in the PR description.
- Ensure the working tree is clean before finalizing the PR.
