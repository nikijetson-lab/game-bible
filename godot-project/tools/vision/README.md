# Local Vision Inspection Rule (Godot frames)

**RULE (standing):** When you need to judge what a Godot render/screenshot actually
looks like, DO NOT send the image to the main Hermes model or any paid vision API.
Route it through the local MiniCPM-V 4.6 model via the project's inspector. The main
model receives only the compact JSON report (text), never the pixels — this saves
vision tokens and keeps a repeatable QA loop.

## Tool
`tools/vision/godot_vision.py` (in the Hazemoor project) → calls Ollama
`minicpm-v4.6:latest` at `http://127.0.0.1:11434`.

## When it fires
- After any `tests/render_*.gd` produces a new PNG in `res://screenshots/`.
- Before claiming a scene/NPC/prop "looks right" — verify with a report first.
- Any time the task is "does this frame show X / is the render broken".

## Usage
Single frame:
```bash
python3 tools/vision/godot_vision.py once \
  --image res://screenshots/gf_street.png \
  --expect "street,buildings,NPC"
```
Watch a folder (analyses only NEW/changed PNGs, appends JSONL, skips duplicates):
```bash
python3 tools/vision/godot_vision.py watch \
  --dir res://screenshots --report tools/vision/last_report.jsonl
```

## Report schema (what Hermes consumes)
```json
{"summary": "...", "objects": [...], "issues": [...],
 "expected_present": {"name": true|false}, "looks_broken": true|false,
 "confidence": 0.0-1.0, "_image": "...", "_seconds": N, "_model": "..."}
```

## Constraints / reality
- CPU-only inference: ~30–140 s per frame on this laptop (3.8 GB RAM, no NVIDIA).
  So this is **event-driven** (one call per new frame), never a high-FPS live feed.
- MiniCPM-V 4.6 is a small 1.3B model: treat its output as a **cheap first-pass
  screen**, not ground truth. It reliably catches broken renders (black/empty/
  magenta-untextured/missing-object). For subtle art judgment still escalate to the
  `visual/screenshot-critique` skill or the user.
- Env overrides: `OLLAMA_HOST`, `GODOT_VISION_MODEL`.
- Never remove `qwen2.5:1.5b` / `nomic-embed-text` (Memanto/Moorcheh depend on the
  same Ollama daemon).
