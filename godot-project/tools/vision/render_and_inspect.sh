#!/usr/bin/env bash
# render_and_inspect.sh — один цикл: Godot render → локальний MiniCPM аналіз.
# Основна модель Hermes отримує ЛИШЕ фінальний JSON-звіт, не зображення.
#
# Usage:
#   tools/vision/render_and_inspect.sh <render_script.gd> <screenshot.png> ["expect,list"] ["extra question"]
# Example:
#   tools/vision/render_and_inspect.sh res://tests/render_street.gd res://screenshots/gf_street.png "street,NPC,barrels"
set -euo pipefail

GODOT="${GODOT_BIN:-/mnt/c/Users/38067/AppData/Local/Microsoft/WinGet/Links/godot.exe}"
PROJECT_WIN='E:\Hazemoor\game-bible\godot-project'
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"

SCRIPT="${1:?render script (res://...) required}"
IMAGE="${2:?screenshot path (res://...) required}"
EXPECT="${3:-}"
QUESTION="${4:-}"

IMG_ABS="$IMAGE"
if [[ "$IMAGE" == res://* ]]; then
  IMG_ABS="$ROOT/${IMAGE#res://}"
fi
OLD_HASH=""
[ -f "$IMG_ABS" ] && OLD_HASH="$(sha1sum "$IMG_ABS" | cut -d' ' -f1)"

echo ">> render: $SCRIPT" >&2
# ВАЖЛИВО: не --headless. Godot 4.7 headless використовує dummy renderer,
# viewport texture = null і render_*.gd не може save_png().
"$GODOT" --path "$PROJECT_WIN" --script "$SCRIPT" 1>&2 || {
  echo '{"error":"godot_render_failed"}'; exit 2; }

# невелика пауза, щоб файл дописався; не аналізувати stale PNG після невдалого render
sleep 1
if [ ! -s "$IMG_ABS" ]; then
  echo "{\"error\":\"screenshot_not_created\",\"image\":\"$IMAGE\"}"
  exit 3
fi
NEW_HASH="$(sha1sum "$IMG_ABS" | cut -d' ' -f1)"
if [ -n "$OLD_HASH" ] && [ "$OLD_HASH" = "$NEW_HASH" ]; then
  echo "{\"error\":\"screenshot_not_changed\",\"image\":\"$IMAGE\"}"
  exit 4
fi

ARGS=(once --image "$IMAGE")
[ -n "$EXPECT" ]   && ARGS+=(--expect "$EXPECT")
[ -n "$QUESTION" ] && ARGS+=(--question "$QUESTION")

echo ">> inspect (local minicpm-v4.6)..." >&2
python3 "$HERE/godot_vision.py" "${ARGS[@]}"
