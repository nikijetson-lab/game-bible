#!/usr/bin/env python3
"""Rebind dataset image paths to the CURRENT data dir (portability across boxes).

train.jsonl / val.jsonl store absolute image paths from the machine that built
them (e.g. /mnt/e/...). On a fresh GPU box those don't exist. This rewrites each
row's images[] to point at <data_dir>/images/<basename>, verifies the file is
present, and only overwrites the jsonl if EVERY path resolved. Idempotent.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path


def _relocate_split(path: Path, images_dir: Path) -> tuple[list[str], list[str]]:
    lines, errors = [], []
    for i, raw in enumerate(path.read_text(encoding="utf-8").splitlines()):
        if not raw.strip():
            continue
        row = json.loads(raw)
        imgs = row.get("images") or []
        new_imgs = []
        for img in imgs:
            cand = (images_dir / Path(img).name).resolve()
            if not cand.is_file():
                errors.append(f"{path.name}[{i}]: missing relocated image {cand}")
            new_imgs.append(str(cand))
        row["images"] = new_imgs
        lines.append(json.dumps(row, ensure_ascii=False))
    return lines, errors


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument(
        "--data", required=True, help="dataset dir (train.jsonl/val.jsonl/images/)"
    )
    a = ap.parse_args()
    data = Path(a.data).resolve()
    images_dir = data / "images"
    if not images_dir.is_dir():
        print(f"no images/ dir under {data}", file=sys.stderr)
        return 2

    rewritten, all_errors = {}, []
    for split in ("train.jsonl", "val.jsonl"):
        p = data / split
        if not p.is_file():
            continue
        lines, errors = _relocate_split(p, images_dir)
        rewritten[p] = lines
        all_errors.extend(errors)

    if all_errors:
        for e in all_errors[:20]:
            print(e, file=sys.stderr)
        print(
            f"{len(all_errors)} path(s) could not be relocated; nothing written",
            file=sys.stderr,
        )
        return 1

    for p, lines in rewritten.items():
        p.write_text("\n".join(lines) + "\n", encoding="utf-8")
        print(f"relocated {len(lines)} rows in {p.name}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
