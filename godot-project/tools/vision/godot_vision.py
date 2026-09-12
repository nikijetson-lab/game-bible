#!/usr/bin/env python3
"""
Локальний vision-спостерігач кадрів Godot через MiniCPM-V 4.6 (Ollama).

Мета: Hermes (велика модель) НЕ отримує зображення й не витрачає vision-токени.
Замість цього локальна MiniCPM дивиться на PNG-кадр і повертає КОМПАКТНИЙ
структурований JSON-звіт (текст), який і йде до Hermes.

Режими:
  once   — проаналізувати один PNG, надрукувати JSON-звіт у stdout.
  watch  — стежити за папкою; коли зʼявляється/змінюється PNG (за mtime+хеш),
           аналізувати лише його та дописувати звіт у --report (JSONL).
           Не аналізує однакові кадри повторно (economy).

Usage:
  python3 godot_vision.py once  --image res://screenshots/check_street.png \
        [--question "..."] [--expect "guard,barrels"]
  python3 godot_vision.py watch --dir  res://screenshots \
        --report tools/vision/last_report.jsonl [--interval 3]

Шляхи можна давати як res://... (перекладуться на корінь проєкту) або абсолютні.
"""
from __future__ import annotations
import argparse, base64, hashlib, json, os, sys, time, urllib.request

OLLAMA_URL = os.environ.get("OLLAMA_HOST", "http://127.0.0.1:11434").rstrip("/")
MODEL = os.environ.get("GODOT_VISION_MODEL", "minicpm-v4.6:latest")
# tools/vision/ -> корінь проєкту на два рівні вище
PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

SYSTEM_PROMPT = (
    "You are a QA visual inspector for a 3D game rendered in the Godot engine. "
    "You are shown ONE rendered frame. Respond with STRICT compact JSON only, no prose, "
    "no markdown. Schema: {"
    '"summary": <=15 words describing the scene, '
    '"objects": [up to 8 short nouns actually visible], '
    '"issues": [visual problems: missing/floating/black/pink-magenta(untextured)/'
    'z-fighting/clipping/empty-scene/all-dark; [] if none], '
    '"expected_present": {name: true|false} for each requested expected item, '
    '"looks_broken": true|false, '
    '"confidence": 0.0-1.0}. '
    "Pink/magenta surfaces mean a missing material. A near-black or empty frame is a broken render."
)


def resolve(path: str) -> str:
    if path.startswith("res://"):
        return os.path.join(PROJECT_ROOT, path[len("res://"):])
    return os.path.abspath(path)


def analyze(image_path: str, question: str | None, expect: list[str]) -> dict:
    ap = resolve(image_path)
    if not os.path.isfile(ap):
        return {"error": f"file_not_found: {ap}"}
    with open(ap, "rb") as f:
        b64 = base64.b64encode(f.read()).decode()

    user = "Inspect this Godot frame and return the JSON report."
    if expect:
        user += " Expected items to verify: " + ", ".join(expect) + "."
    if question:
        user += " Extra question: " + question

    payload = {
        "model": MODEL,
        "prompt": user,
        "system": SYSTEM_PROMPT,
        "images": [b64],
        "stream": False,
        "format": "json",
        "options": {"temperature": 0.0, "num_predict": 400},
    }
    req = urllib.request.Request(
        OLLAMA_URL + "/api/generate",
        data=json.dumps(payload).encode(),
        headers={"Content-Type": "application/json"},
    )
    t0 = time.time()
    try:
        with urllib.request.urlopen(req, timeout=180) as resp:
            raw = json.loads(resp.read().decode())
    except Exception as e:  # noqa: BLE001
        return {"error": f"ollama_call_failed: {e}"}
    dt = round(time.time() - t0, 1)

    txt = (raw.get("response") or "").strip()
    try:
        report = json.loads(txt)
    except json.JSONDecodeError:
        report = {"summary": txt[:200], "issues": ["model_returned_non_json"], "looks_broken": None}
    report["_image"] = image_path
    report["_seconds"] = dt
    report["_model"] = MODEL
    return report


def sha(path: str) -> str:
    h = hashlib.sha1()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(65536), b""):
            h.update(chunk)
    return h.hexdigest()


def cmd_once(a) -> int:
    rep = analyze(a.image, a.question, a.expect.split(",") if a.expect else [])
    print(json.dumps(rep, ensure_ascii=False))
    return 0 if not rep.get("error") else 2


def cmd_watch(a) -> int:
    d = resolve(a.dir)
    if not os.path.isdir(d):
        print(json.dumps({"error": f"dir_not_found: {d}"})); return 2
    report_path = resolve(a.report)
    os.makedirs(os.path.dirname(report_path), exist_ok=True)
    seen: dict[str, str] = {}
    expect = a.expect.split(",") if a.expect else []
    print(json.dumps({"watching": d, "report": a.report, "model": MODEL}), flush=True)
    try:
        while True:
            for fn in sorted(os.listdir(d)):
                if not fn.lower().endswith(".png"):
                    continue
                fp = os.path.join(d, fn)
                try:
                    digest = sha(fp)
                except OSError:
                    continue  # ще пишеться
                if seen.get(fp) == digest:
                    continue
                seen[fp] = digest
                rel = a.dir.rstrip("/") + "/" + fn
                rep = analyze(rel, a.question, expect)
                line = json.dumps(rep, ensure_ascii=False)
                with open(report_path, "a", encoding="utf-8") as rf:
                    rf.write(line + "\n")
                print(line, flush=True)
            time.sleep(a.interval)
    except KeyboardInterrupt:
        return 0


def main() -> int:
    p = argparse.ArgumentParser(description="Godot frame inspector via local MiniCPM-V")
    sub = p.add_subparsers(dest="mode", required=True)

    o = sub.add_parser("once")
    o.add_argument("--image", required=True)
    o.add_argument("--question", default=None)
    o.add_argument("--expect", default="")
    o.set_defaults(func=cmd_once)

    w = sub.add_parser("watch")
    w.add_argument("--dir", required=True)
    w.add_argument("--report", default="tools/vision/last_report.jsonl")
    w.add_argument("--interval", type=float, default=3.0)
    w.add_argument("--question", default=None)
    w.add_argument("--expect", default="")
    w.set_defaults(func=cmd_watch)

    a = p.parse_args()
    return a.func(a)


if __name__ == "__main__":
    sys.exit(main())
