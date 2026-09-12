#!/usr/bin/env python3
"""Adapt `swift infer --result_path` jsonl into score_predictions.py format.

ms-swift writes one json object per line with the model output under a
'response' (or 'messages'[-1]) key, in dataset order. Our scorer wants
{"prediction": "<text>"} per line, aligned to val.jsonl. This bridges them.
"""

from __future__ import annotations

import argparse
import json


def _extract(obj: dict) -> str:
    if isinstance(obj.get("response"), str):
        return obj["response"]
    msgs = obj.get("messages")
    if isinstance(msgs, list) and msgs:
        last = msgs[-1]
        if isinstance(last, dict) and last.get("role") == "assistant":
            return str(last.get("content", ""))
    for k in ("infer_response", "generated_text", "output"):
        if isinstance(obj.get(k), str):
            return obj[k]
    raise KeyError(f"no response field in swift row: {sorted(obj)}")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--infer", required=True, help="swift infer --result_path jsonl")
    ap.add_argument(
        "--out", required=True, help="predictions.jsonl for score_predictions.py"
    )
    a = ap.parse_args()
    n = 0
    with (
        open(a.infer, encoding="utf-8") as fin,
        open(a.out, "w", encoding="utf-8") as fout,
    ):
        for line in fin:
            line = line.strip()
            if not line:
                continue
            fout.write(
                json.dumps(
                    {"prediction": _extract(json.loads(line))}, ensure_ascii=False
                )
                + "\n"
            )
            n += 1
    print(f"wrote {n} predictions -> {a.out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
