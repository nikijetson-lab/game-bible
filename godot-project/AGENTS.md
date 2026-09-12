# AGENTS.md — Hazemoor (Godot 4.7)

## Vision / screenshot inspection — MANDATORY
When you need to judge what a Godot render or screenshot actually shows, analyze it
with the LOCAL vision model, NOT the main Hermes model and NOT any paid vision API.

- Tool: `tools/vision/godot_vision.py` → Ollama `minicpm-v4.6:latest` (local, CPU).
- One shot: `python3 tools/vision/godot_vision.py once --image res://screenshots/X.png --expect "a,b,c"`
- Render + inspect in one step: `tools/vision/render_and_inspect.sh <res://tests/render_X.gd> <res://screenshots/X.png> "expect,list"`
- The main model receives only the compact JSON report, never the pixels. See
  `tools/vision/README.md` for the schema and limits.

## Godot invariants (this machine)
- Binary: `C:\Users\38067\AppData\Local\Microsoft\WinGet\Links\godot.exe` (Godot 4.7).
- **Visual renders (`tests/render_*.gd`) must NOT use `--headless`.** Headless uses the
  dummy renderer → viewport texture is null → `save_png()` fails and the script loops.
  Run windowed: `godot.exe --path <win-path> --script res://tests/render_X.gd`.
- Headless IS fine for logic-only smoke (`tests/smoke_load_scenes.gd`): expect
  `SMOKE RESULT: N OK, 0 FAIL`.
- Ollama daemon is shared with Memanto/Moorcheh — never remove `qwen2.5:1.5b` or
  `nomic-embed-text`.
