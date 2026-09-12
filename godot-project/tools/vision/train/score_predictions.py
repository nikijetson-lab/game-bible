#!/usr/bin/env python3
"""Deterministic scorer for Hazemoor MiniCPM-V hard-case predictions."""

from __future__ import annotations

import argparse
import json
import math
import re
from collections import Counter
from collections.abc import Iterable
from pathlib import Path

POINT_RE = re.compile(r"<point>\s*(\d{1,4})[ ,]+(\d{1,4})\s*</point>", re.IGNORECASE)
COUNT_RE = re.compile(r"total\s+count\s+is\s+(\d+)", re.IGNORECASE)
COLORS_RE = re.compile(r"colors?\s+in\s+order\s*:\s*([^.]*)", re.IGNORECASE)
LABELS_RE = re.compile(r"visible\s+labels?\s*:\s*([^.]*)", re.IGNORECASE)
KNOWN_COLORS = {"red", "orange", "yellow", "green", "cyan", "blue", "purple", "magenta"}


def parse_prediction(text: str) -> dict:
    points = [(int(x), int(y)) for x, y in POINT_RE.findall(text)]
    count_match = COUNT_RE.search(text)
    color_match = COLORS_RE.search(text)
    label_match = LABELS_RE.search(text)
    colors = []
    if color_match:
        colors = [x.strip().lower() for x in color_match.group(1).split(",")]
        colors = [x for x in colors if x in KNOWN_COLORS]
    labels = []
    if label_match:
        labels = [x.strip().upper() for x in label_match.group(1).split(",")]
        labels = [x for x in labels if x and x not in {"NONE", "NO LABELS"}]
    return {
        "points": points,
        "colors": colors,
        "labels": labels,
        "count": int(count_match.group(1)) if count_match else None,
    }


def _multiset_f1(expected: Iterable, predicted: Iterable) -> float:
    expected_count = Counter(expected)
    predicted_count = Counter(predicted)
    tp = sum((expected_count & predicted_count).values())
    total_expected = sum(expected_count.values())
    total_predicted = sum(predicted_count.values())
    if total_expected == total_predicted == 0:
        return 1.0
    precision = tp / total_predicted if total_predicted else 0.0
    recall = tp / total_expected if total_expected else 0.0
    return 2 * precision * recall / (precision + recall) if precision + recall else 0.0


def _point_f1(
    expected: list[tuple[int, int]], predicted: list[tuple[int, int]], tolerance: float
) -> float:
    # Greedy nearest-neighbour matching, one prediction per ground-truth point.
    candidates = sorted(
        (math.hypot(ex - px, ey - py), ei, pi)
        for ei, (ex, ey) in enumerate(expected)
        for pi, (px, py) in enumerate(predicted)
    )
    matched_expected: set[int] = set()
    matched_predicted: set[int] = set()
    for distance, ei, pi in candidates:
        if distance > tolerance:
            break
        if ei not in matched_expected and pi not in matched_predicted:
            matched_expected.add(ei)
            matched_predicted.add(pi)
    tp = len(matched_expected)
    if not expected and not predicted:
        return 1.0
    precision = tp / len(predicted) if predicted else 0.0
    recall = tp / len(expected) if expected else 0.0
    return 2 * precision * recall / (precision + recall) if precision + recall else 0.0


def score_prediction(
    ground_truth: dict, prediction: str, point_tolerance: float = 50.0
) -> dict:
    parsed = parse_prediction(prediction)
    markers = ground_truth.get("markers", [])
    expected_points = [(int(m["nx"]), int(m["ny"])) for m in markers]
    expected_colors = [str(m["color"]).lower() for m in markers]
    expected_labels = [str(m["text"]).upper() for m in markers if m.get("text")]
    return {
        "count_exact": float(parsed["count"] == len(markers)),
        "point_f1": _point_f1(expected_points, parsed["points"], point_tolerance),
        "color_f1": _multiset_f1(expected_colors, parsed["colors"]),
        "ocr_f1": _multiset_f1(expected_labels, parsed["labels"]),
    }


def aggregate(rows: list[dict]) -> dict:
    metrics = ("count_exact", "point_f1", "color_f1", "ocr_f1")
    means = {
        metric: sum(float(row[metric]) for row in rows) / len(rows) if rows else 0.0
        for metric in metrics
    }
    return {
        "samples": len(rows),
        "count_accuracy": means["count_exact"],
        "point_f1": means["point_f1"],
        "color_f1": means["color_f1"],
        "ocr_f1": means["ocr_f1"],
        "composite": sum(means.values()) / len(means),
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--dataset", required=True, help="Validation JSONL with ground_truth"
    )
    parser.add_argument(
        "--predictions",
        required=True,
        help="JSONL with a prediction field, in matching order",
    )
    parser.add_argument("--point-tolerance", type=float, default=50.0)
    parser.add_argument("--output", default="")
    args = parser.parse_args()

    dataset = [
        json.loads(line)
        for line in Path(args.dataset).read_text(encoding="utf-8").splitlines()
        if line.strip()
    ]
    predictions = [
        json.loads(line)
        for line in Path(args.predictions).read_text(encoding="utf-8").splitlines()
        if line.strip()
    ]
    if len(dataset) != len(predictions):
        raise SystemExit(
            f"row count mismatch: dataset={len(dataset)}, predictions={len(predictions)}"
        )
    scored = [
        score_prediction(
            row["ground_truth"], pred.get("prediction", ""), args.point_tolerance
        )
        for row, pred in zip(dataset, predictions)
    ]
    result = aggregate(scored)
    text = json.dumps(result, ensure_ascii=False, indent=2)
    if args.output:
        Path(args.output).write_text(text + "\n", encoding="utf-8")
    print(text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
