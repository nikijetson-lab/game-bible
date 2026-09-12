#!/usr/bin/env python3
"""Validate a Hazemoor MiniCPM-V dataset: schema, images, answer/GT consistency,
and scene-disjoint train/val split (no channel leakage)."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path

POINT_RE = re.compile(r"<point>\s*\d{1,4}[ ,]+\d{1,4}\s*</point>")
COUNT_RE = re.compile(r"total count is (\d+)")


def _load(path: Path) -> list[dict]:
    if not path.is_file():
        return []
    return [
        json.loads(l)
        for l in path.read_text(encoding="utf-8").splitlines()
        if l.strip()
    ]


def _check_rows(rows: list[dict], split: str, errors: list[str]) -> set[str]:
    channels: set[str] = set()
    for i, row in enumerate(rows):
        tag = f"{split}[{i}]"
        msgs = row.get("messages", [])
        if (
            len(msgs) != 2
            or msgs[0].get("role") != "user"
            or msgs[1].get("role") != "assistant"
        ):
            errors.append(f"{tag}: messages must be [user, assistant]")
            continue
        if "<image>" not in msgs[0].get("content", ""):
            errors.append(f"{tag}: user prompt missing <image> token")
        images = row.get("images") or []
        if not images:
            errors.append(f"{tag}: no image path")
        else:
            if not Path(images[0]).is_file():
                errors.append(f"{tag}: missing image {images[0]}")
        markers = (row.get("ground_truth") or {}).get("markers")
        if not markers:
            errors.append(f"{tag}: empty ground_truth markers")
            markers = []
        answer = msgs[1].get("content", "")
        n_points = len(POINT_RE.findall(answer))
        if n_points != len(markers):
            errors.append(
                f"{tag}: answer point count {n_points} != markers {len(markers)}"
            )
        count_match = COUNT_RE.search(answer)
        if not count_match or int(count_match.group(1)) != len(markers):
            errors.append(f"{tag}: answer count != markers {len(markers)}")
        for m in markers:
            if not (0 <= m.get("nx", -1) <= 1000 and 0 <= m.get("ny", -1) <= 1000):
                errors.append(f"{tag}: point out of 0-1000 range")
                break
        if row.get("channel"):
            channels.add(row["channel"])
    return channels


def validate(train_path: Path, val_path: Path) -> dict:
    errors: list[str] = []
    train = _load(train_path)
    val = _load(val_path)
    if not train:
        errors.append("train split is empty")
    train_channels = _check_rows(train, "train", errors)
    val_channels = _check_rows(val, "val", errors)
    leaked = train_channels & val_channels
    if leaked:
        errors.append(f"channel leakage between train/val: {sorted(leaked)}")
    return {
        "valid": not errors,
        "train_rows": len(train),
        "val_rows": len(val),
        "train_channels": sorted(train_channels),
        "val_channels": sorted(val_channels),
        "errors": errors,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--data", required=True, help="dataset dir with train.jsonl/val.jsonl"
    )
    args = parser.parse_args()
    data = Path(args.data)
    report = validate(data / "train.jsonl", data / "val.jsonl")
    print(json.dumps(report, ensure_ascii=False, indent=2))
    return 0 if report["valid"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
