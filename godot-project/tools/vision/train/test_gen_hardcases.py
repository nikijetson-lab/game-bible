import importlib.util
import json
from pathlib import Path

from PIL import Image  # type: ignore[import-not-found]

MODULE_PATH = Path(__file__).with_name("gen_hardcases.py")
spec = importlib.util.spec_from_file_location("gen_hardcases", MODULE_PATH)
assert spec and spec.loader
gen = importlib.util.module_from_spec(spec)
spec.loader.exec_module(gen)


def _fake_scenes(tmp_path: Path):
    shots = tmp_path / "shots"
    shots.mkdir()
    scene_map = {}
    for i in range(6):
        name = f"scene_{i}.png"
        Image.new("RGB", (320, 180), (25 + i * 10, 35, 45)).save(shots / name)
        scene_map[f"scene_{i}"] = [name]
    return shots, scene_map


def test_build_creates_scene_disjoint_swift_dataset(tmp_path, monkeypatch):
    shots, scene_map = _fake_scenes(tmp_path)
    monkeypatch.setattr(gen, "SHOTS", shots)
    monkeypatch.setattr(gen, "SCENE_BACKGROUNDS", scene_map)

    summary = gen.build(tmp_path / "out", n_per_scene=2, seed=7)

    train = [
        json.loads(x) for x in (tmp_path / "out/train.jsonl").read_text().splitlines()
    ]
    val = [json.loads(x) for x in (tmp_path / "out/val.jsonl").read_text().splitlines()]
    assert summary["train"] == 8
    assert summary["val"] == 4
    assert {r["channel"] for r in train}.isdisjoint({r["channel"] for r in val})
    assert all(Path(r["images"][0]).is_file() for r in train + val)
    assert all(r["messages"][0]["content"].startswith("<image>\n") for r in train + val)


def test_ground_truth_points_are_bounded_and_match_answer(tmp_path, monkeypatch):
    shots, scene_map = _fake_scenes(tmp_path)
    monkeypatch.setattr(gen, "SHOTS", shots)
    monkeypatch.setattr(gen, "SCENE_BACKGROUNDS", scene_map)
    gen.build(tmp_path / "out", n_per_scene=1, seed=11)

    rows = []
    for split in ("train", "val"):
        rows.extend(
            json.loads(x)
            for x in (tmp_path / f"out/{split}.jsonl").read_text().splitlines()
        )
    for row in rows:
        markers = row["ground_truth"]["markers"]
        answer = row["messages"][1]["content"]
        assert markers
        assert all(0 <= m["nx"] <= 1000 and 0 <= m["ny"] <= 1000 for m in markers)
        assert answer.count("<point>") == len(markers)
        assert answer.endswith(f"total count is {len(markers)}.")


def test_build_is_deterministic_for_same_seed(tmp_path, monkeypatch):
    shots, scene_map = _fake_scenes(tmp_path)
    monkeypatch.setattr(gen, "SHOTS", shots)
    monkeypatch.setattr(gen, "SCENE_BACKGROUNDS", scene_map)
    gen.build(tmp_path / "a", n_per_scene=2, seed=9)
    gen.build(tmp_path / "b", n_per_scene=2, seed=9)

    def normalized(path):
        rows = [json.loads(x) for x in path.read_text().splitlines()]
        for row in rows:
            row["images"] = [Path(row["images"][0]).name]
        return rows

    assert normalized(tmp_path / "a/train.jsonl") == normalized(
        tmp_path / "b/train.jsonl"
    )
    assert normalized(tmp_path / "a/val.jsonl") == normalized(tmp_path / "b/val.jsonl")
