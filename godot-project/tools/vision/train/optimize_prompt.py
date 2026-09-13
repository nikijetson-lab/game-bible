#!/usr/bin/env python3
"""Local, no-cloud prompt-variant optimizer for MiniCPM-V 4.6 via Ollama.

Instead of fine-tuning weights (needs an NVIDIA GPU we do not have), this
searches a small set of prompt strategies on a balanced dev subset, scores each
with the SAME deterministic scorer used everywhere else, and saves the winning
prompt. No cloud, no GPU, no paid API.

Pipeline:
  1. stratified_subset()  - balanced (channel, difficulty) dev sample
  2. for each PROMPT_VARIANT: run Ollama infer -> score_predictions
  3. select_best()        - highest composite, deterministic tiebreak
  4. write best_prompt.json + report.json
"""

from __future__ import annotations

import argparse
import json
import random
import time
from pathlib import Path

import run_baseline_ollama as rb
import score_predictions as sp

# Candidate prompt strategies. All emit the parser-compatible contract the
# deterministic scorer expects: "<point>x y</point> ... Colors in order: ...
# Visible labels: ... So the total count is N."
_CONTRACT = (
    "Answer ONLY in this exact form and nothing else: "
    "'Marker coordinates: <point>x y</point>, <point>x y</point>. "
    "Colors in order: c1, c2. Visible labels: L1, L2. "
    "So the total count is N.' "
    "Coordinates are normalized 0-1000. Colors must be one of: "
    "red, orange, yellow, green, cyan, blue, purple, magenta. "
    "If a marker has no readable label, omit it from Visible labels. "
    "Do not add explanations, reasoning, or extra sentences."
)

PROMPT_VARIANTS: list[dict[str, str]] = [
    {
        "name": "baseline",
        "system": (
            "You are a precise visual QA inspector. "
            "Look carefully at dark, foggy, blurry or partly hidden regions. "
            + _CONTRACT
        ),
    },
    {
        "name": "structured_strict",
        "system": (
            "You are a meticulous game-QA vision inspector. Scan the frame in a "
            "grid, top-left to bottom-right. Boost perceived brightness mentally "
            "for dark areas and look through fog/blur. Count EVERY colored marker, "
            "even faint or partly occluded ones. " + _CONTRACT
        ),
    },
    {
        "name": "count_first",
        "system": (
            "You are a visual marker detector. First silently locate all colored "
            "markers including dim, blurred, foggy, or half-hidden ones, then "
            "report them. Prefer recall: if unsure whether a faint blob is a "
            "marker, include it. " + _CONTRACT
        ),
    },
    {
        "name": "channel_aware",
        "system": (
            "You inspect fantasy game frames (tavern interiors, ports, swamps, "
            "gates, streets) for colored quest markers. Interiors are dim; swamps "
            "are foggy; motion causes blur. Compensate for these conditions and "
            "detect all markers. " + _CONTRACT
        ),
    },
]

USER_PROMPT = (
    "Carefully inspect this game frame, including dark, foggy, blurry or partly "
    "hidden regions. List every colored marker as <point>x y</point> "
    "(coords normalized 0-1000), then its color, any short text on it, and the "
    "total count."
)


def stratified_subset(
    rows: list[dict], per_group: int, seed: int
) -> list[dict]:
    """Return up to `per_group` rows from each (channel, difficulty) stratum.

    Deterministic for a fixed seed; order is sorted by group then picked index
    so results are stable across runs and machines.
    """
    groups: dict[tuple[str, str], list[dict]] = {}
    for row in rows:
        key = (str(row.get("channel")), str(row.get("difficulty")))
        groups.setdefault(key, []).append(row)

    picked: list[dict] = []
    for key in sorted(groups):
        bucket = groups[key]
        rng = random.Random(f"{seed}:{key}")
        indices = list(range(len(bucket)))
        rng.shuffle(indices)
        for i in sorted(indices[:per_group]):
            picked.append(bucket[i])
    return picked


def select_best(results: list[dict]) -> dict:
    """Pick the result with the highest composite; ties break by name (asc)."""
    return min(results, key=lambda r: (-float(r["composite"]), str(r["name"])))


def load_checkpoint(path: Path) -> dict[int, dict]:
    """Load per-image checkpoint rows keyed by image index. Missing -> {}."""
    if not path.exists():
        return {}
    completed: dict[int, dict] = {}
    for line in path.read_text(encoding="utf-8").splitlines():
        if not line.strip():
            continue
        row = json.loads(line)
        completed[int(row["index"])] = row
    return completed


def _score_variant(
    variant: dict[str, str],
    rows: list[dict],
    model: str,
    timeout: float,
    point_tolerance: float,
    checkpoint_path: Path | None = None,
) -> dict:
    completed: dict[int, dict] = (
        load_checkpoint(checkpoint_path) if checkpoint_path else {}
    )
    if completed:
        print(f"    resuming: {len(completed)}/{len(rows)} already scored", flush=True)
    fh = checkpoint_path.open("a", encoding="utf-8") if checkpoint_path else None
    try:
        scored: list[dict] = []
        for i, row in enumerate(rows):
            if i in completed:
                scored.append(completed[i]["score"])
                continue
            image = row["images"][0]
            try:
                text = _infer_with_system(
                    image, USER_PROMPT, variant["system"], model, timeout
                )
            except Exception as exc:  # noqa: BLE001
                text = ""
                print(f"    [{i}] ERROR {exc}", flush=True)
            one = sp.score_prediction(row["ground_truth"], text, point_tolerance)
            scored.append(one)
            if fh is not None:
                fh.write(
                    json.dumps({"index": i, "score": one}, ensure_ascii=False) + "\n"
                )
                fh.flush()
    finally:
        if fh is not None:
            fh.close()
    agg = sp.aggregate(scored)
    agg["name"] = variant["name"]
    return agg


def _infer_with_system(
    image_path: str, user_prompt: str, system: str, model: str, timeout: float
) -> str:
    """Ollama inference with a per-variant system prompt (reuses rb transport)."""
    import base64
    import json as _json
    import urllib.request

    b64 = base64.b64encode(Path(image_path).read_bytes()).decode()
    payload = {
        "model": model,
        "system": system,
        "prompt": user_prompt,
        "images": [b64],
        "stream": False,
        "options": {"temperature": 0.0, "num_predict": 400},
    }
    req = urllib.request.Request(
        rb.OLLAMA_URL,
        data=_json.dumps(payload).encode(),
        headers={"Content-Type": "application/json"},
    )
    with urllib.request.urlopen(req, timeout=timeout) as resp:
        return (_json.loads(resp.read().decode()).get("response") or "").strip()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--dataset", required=True, help="val.jsonl with ground_truth")
    parser.add_argument("--out-dir", required=True)
    parser.add_argument("--per-group", type=int, default=2)
    parser.add_argument("--seed", type=int, default=7)
    parser.add_argument("--model", default=rb.DEFAULT_MODEL)
    parser.add_argument("--timeout", type=float, default=300.0)
    parser.add_argument("--point-tolerance", type=float, default=50.0)
    args = parser.parse_args()

    rows = [
        json.loads(line)
        for line in Path(args.dataset).read_text(encoding="utf-8").splitlines()
        if line.strip()
    ]
    subset = stratified_subset(rows, args.per_group, args.seed)
    print(
        f"dev subset: {len(subset)} rows across strata; "
        f"variants: {[v['name'] for v in PROMPT_VARIANTS]}",
        flush=True,
    )

    out_dir = Path(args.out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)

    results: list[dict] = []
    for variant in PROMPT_VARIANTS:
        t0 = time.time()
        print(f"[variant] {variant['name']} ...", flush=True)
        checkpoint = out_dir / f"checkpoint_{variant['name']}.jsonl"
        res = _score_variant(
            variant,
            subset,
            args.model,
            args.timeout,
            args.point_tolerance,
            checkpoint,
        )
        res["seconds"] = round(time.time() - t0, 1)
        results.append(res)
        print(
            f"  {variant['name']}: composite={res['composite']:.3f} "
            f"count={res['count_accuracy']:.3f} point={res['point_f1']:.3f} "
            f"color={res['color_f1']:.3f} ocr={res['ocr_f1']:.3f} "
            f"({res['seconds']}s)",
            flush=True,
        )

    best = select_best(results)
    best_system = next(v["system"] for v in PROMPT_VARIANTS if v["name"] == best["name"])

    (out_dir / "report.json").write_text(
        json.dumps(
            {"subset_size": len(subset), "seed": args.seed, "results": results},
            ensure_ascii=False,
            indent=2,
        )
        + "\n",
        encoding="utf-8",
    )
    (out_dir / "best_prompt.json").write_text(
        json.dumps(
            {
                "name": best["name"],
                "composite": best["composite"],
                "system": best_system,
                "user": USER_PROMPT,
            },
            ensure_ascii=False,
            indent=2,
        )
        + "\n",
        encoding="utf-8",
    )
    print(
        f"BEST: {best['name']} composite={best['composite']:.3f} "
        f"-> {out_dir / 'best_prompt.json'}",
        flush=True,
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
