#!/usr/bin/env python3
"""Run MiniCPM-V 4.6 over a val.jsonl via Ollama and emit predictions.jsonl.

Each output row: {"prediction": <assistant text>, "difficulty": ..., "channel": ...}
in the SAME order as the input dataset, ready for score_predictions.py.
"""

from __future__ import annotations

import argparse
import base64
import json
import time
import urllib.request
from pathlib import Path

OLLAMA_URL = "http://127.0.0.1:11434/api/generate"
DEFAULT_MODEL = "minicpm-v4.6:latest"
SYSTEM = (
    "You are a precise visual QA inspector. Look carefully at dark, foggy, blurry or "
    "partly hidden regions. Answer ONLY in this exact form: "
    "'Marker coordinates: <point>x y</point>, ... Colors in order: c1, c2. "
    "Visible labels: L1, L2. So the total count is N.' "
    "Coordinates are normalized 0-1000."
)


def infer(image_path: str, user_prompt: str, model: str, timeout: float) -> str:
    b64 = base64.b64encode(Path(image_path).read_bytes()).decode()
    payload = {
        "model": model,
        "system": SYSTEM,
        "prompt": user_prompt,
        "images": [b64],
        "stream": False,
        "options": {"temperature": 0.0, "num_predict": 400},
    }
    req = urllib.request.Request(
        OLLAMA_URL,
        data=json.dumps(payload).encode(),
        headers={"Content-Type": "application/json"},
    )
    with urllib.request.urlopen(req, timeout=timeout) as resp:
        return (json.loads(resp.read().decode()).get("response") or "").strip()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--dataset", required=True)
    parser.add_argument("--out", required=True)
    parser.add_argument("--model", default=DEFAULT_MODEL)
    parser.add_argument("--timeout", type=float, default=180.0)
    parser.add_argument("--limit", type=int, default=0, help="0 = all rows")
    args = parser.parse_args()

    rows = [
        json.loads(l)
        for l in Path(args.dataset).read_text(encoding="utf-8").splitlines()
        if l.strip()
    ]
    if args.limit:
        rows = rows[: args.limit]

    out_path = Path(args.out)
    out_path.parent.mkdir(parents=True, exist_ok=True)
    written = 0
    with out_path.open("w", encoding="utf-8") as f:
        for i, row in enumerate(rows):
            image = row["images"][0]
            user_prompt = row["messages"][0]["content"].replace("<image>\n", "")
            t0 = time.time()
            try:
                text = infer(image, user_prompt, args.model, args.timeout)
            except Exception as e:  # noqa: BLE001
                text = ""
                print(f"[{i}] ERROR {e}", flush=True)
            dt = round(time.time() - t0, 1)
            f.write(
                json.dumps(
                    {
                        "prediction": text,
                        "difficulty": row.get("difficulty"),
                        "channel": row.get("channel"),
                        "seconds": dt,
                    },
                    ensure_ascii=False,
                )
                + "\n"
            )
            f.flush()
            written += 1
            print(
                f"[{i + 1}/{len(rows)}] {row.get('difficulty')} {dt}s :: {text[:90]}",
                flush=True,
            )
    print(f"WROTE {written} -> {out_path}", flush=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
