#!/usr/bin/env python3
"""RED-first tests for the local (no-cloud) prompt-variant optimizer."""

from __future__ import annotations

import importlib.util
from pathlib import Path

_spec = importlib.util.spec_from_file_location(
    "optimize_prompt", Path(__file__).with_name("optimize_prompt.py")
)
assert _spec and _spec.loader
op = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(op)


def _rows() -> list[dict]:
    rows = []
    for channel in ("interior", "port", "swamp"):
        for difficulty in ("dark", "fog", "blur"):
            for i in range(4):
                rows.append(
                    {
                        "channel": channel,
                        "difficulty": difficulty,
                        "idx": f"{channel}_{difficulty}_{i}",
                    }
                )
    return rows


def test_stratified_subset_is_balanced_and_deterministic() -> None:
    rows = _rows()
    a = op.stratified_subset(rows, per_group=2, seed=7)
    b = op.stratified_subset(rows, per_group=2, seed=7)

    # Deterministic for a fixed seed.
    assert [r["idx"] for r in a] == [r["idx"] for r in b]

    # Balanced: exactly per_group from each (channel, difficulty) stratum.
    groups: dict[tuple[str, str], int] = {}
    for r in a:
        key = (r["channel"], r["difficulty"])
        groups[key] = groups.get(key, 0) + 1
    assert len(groups) == 9
    assert all(v == 2 for v in groups.values())
    assert len(a) == 18


def test_stratified_subset_caps_at_available_rows() -> None:
    rows = _rows()
    subset = op.stratified_subset(rows, per_group=99, seed=1)
    # Cannot exceed the 4 rows available per stratum.
    assert len(subset) == len(rows)


def test_select_best_picks_highest_composite() -> None:
    results = [
        {"name": "baseline", "composite": 0.05},
        {"name": "structured", "composite": 0.42},
        {"name": "cot", "composite": 0.30},
    ]
    assert op.select_best(results)["name"] == "structured"


def test_select_best_tiebreak_is_deterministic_by_name() -> None:
    results = [
        {"name": "zeta", "composite": 0.40},
        {"name": "alpha", "composite": 0.40},
    ]
    # Ties resolve to the lexicographically smallest name, not input order.
    assert op.select_best(results)["name"] == "alpha"


def test_prompt_variants_are_nonempty_and_named() -> None:
    variants = op.PROMPT_VARIANTS
    assert len(variants) >= 2
    names = [v["name"] for v in variants]
    assert len(names) == len(set(names))  # unique
    for v in variants:
        assert v["system"].strip()


def test_load_checkpoint_resumes_unique_completed_rows(tmp_path: Path) -> None:
    checkpoint = tmp_path / "variant.jsonl"
    checkpoint.write_text(
        '{"index": 0, "score": {"count_exact": 0.0}}\n'
        '{"index": 2, "score": {"count_exact": 1.0}}\n',
        encoding="utf-8",
    )
    completed = op.load_checkpoint(checkpoint)
    assert sorted(completed) == [0, 2]
    assert completed[2]["score"]["count_exact"] == 1.0


def test_load_checkpoint_missing_is_empty(tmp_path: Path) -> None:
    assert op.load_checkpoint(tmp_path / "missing.jsonl") == {}
