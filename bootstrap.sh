#!/usr/bin/env bash
# bootstrap.sh — клон репозитория и запуск установки
# Пример:
#   curl -fsSL https://YOUR_HOST/bootstrap.sh -o bootstrap.sh && chmod +x bootstrap.sh
#   ./bootstrap.sh https://github.com/your-org/ahelper-mvp-stack.git
set -euo pipefail

RED(){ printf "\033[31m%s\033[0m\n" "$*"; }
GRN(){ printf "\033[32m%s\033[0m\n" "$*"; }
YLW(){ printf "\033[33m%s\033[0m\n" "$*"; }
BLU(){ printf "\033[34m%s\033[0m\n" "$*"; }

need(){ command -v "$1" >/dev/null 2>&1 || { RED "Требуется утилита: $1"; exit 1; }; }

usage(){ echo "Использование: $0 <git-repo-url> [target-dir]"; }

need git; need bash; need curl; need docker
docker compose version >/dev/null 2>&1 || { RED "Нужен docker compose (плагин)."; exit 1; }

REPO_URL="${1:-}"; TARGET_DIR="${2:-}"
[[ -z "$REPO_URL" ]] && { usage; exit 1; }

if [[ -z "$TARGET_DIR" ]]; then
  BASE="$(basename -s .git "$REPO_URL")"; [[ -z "$BASE" ]] && BASE="ahelper-mvp-stack"
  TARGET_DIR="./$BASE"
fi
if [[ -e "$TARGET_DIR" ]]; then
  YLW "Папка '$TARGET_DIR' уже существует."
  TS="$(date +%Y%m%d_%H%M%S)"; TARGET_DIR="${TARGET_DIR}_$TS"
  YLW "Клонирую в '$TARGET_DIR'..."
fi

GRN "Клонирую репозиторий: $REPO_URL → $TARGET_DIR"
git clone --depth=1 "$REPO_URL" "$TARGET_DIR"
cd "$TARGET_DIR"

chmod +x ./scripts/*.sh 2>/dev/null || true
[[ -x ./scripts/setup.sh ]] || { RED "Не найден ./scripts/setup.sh"; exit 1; }

BLU "Запускаю установку..."
./scripts/setup.sh

GRN "Готово. Статус контейнеров:"
./scripts/status.sh || true
