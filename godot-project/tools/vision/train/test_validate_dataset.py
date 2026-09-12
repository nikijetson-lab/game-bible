import importlib.util
import json
from pathlib import Path

MODULE_PATH = Path(__file__).with_name("validate_dataset.py")
spec = importlib.util.spec_from_file_location("validate_dataset", MODULE_PATH)
assert spec and spec.loader
validator = importlib.util.module_from_spec(spec)
spec.loader.exec_module(validator)


def _row(image: Path, channel: str, source_bg: str, nx: int = 100):
    return {
        "messages": [
            {"role": "user", "content": "<image>\nFind markers."},
            {
                "role": "assistant",
                "content": (
                    f"Marker coordinates: <point>{nx} 200</point>. Colors in order: red. "
                    "Visible labels: KEY. So the total count is 1."
                ),
            },
        ],
        "images": [str(image)],
        "channel": channel,
        "difficulty": "dark",
        "source_bg": source_bg,
        "ground_truth": {
            "markers": [{"nx": nx, "ny": 200, "color": "red", "text": "KEY"}]
        },
    }


def _write(path: Path, rows: list[dict]):
    path.write_text("".join(json.dumps(r) + "\n" for r in rows), encoding="utf-8")


def test_validate_accepts_disjoint_complete_dataset(tmp_path):
    train_image = tmp_path / "train.png"
    val_image = tmp_path / "val.png"
    train_image.write_bytes(b"train")
    val_image.write_bytes(b"val")
    train = tmp_path / "train.jsonl"
    val = tmp_path / "val.jsonl"
    _write(train, [_row(train_image, "tavern", "tavern.png")])
    _write(val, [_row(val_image, "gate", "gate.png")])

    report = validator.validate(train, val)

    assert report["valid"] is True
    assert report["train_rows"] == 1
    assert report["val_rows"] == 1
    assert report["errors"] == []


def test_validate_rejects_scene_leakage(tmp_path):
    image_a = tmp_path / "a.png"
    image_b = tmp_path / "b.png"
    image_a.write_bytes(b"a")
    image_b.write_bytes(b"b")
    train = tmp_path / "train.jsonl"
    val = tmp_path / "val.jsonl"
    _write(train, [_row(image_a, "gate", "gate_a.png")])
    _write(val, [_row(image_b, "gate", "gate_b.png")])

    report = validator.validate(train, val)

    assert report["valid"] is False
    assert any("channel leakage" in error for error in report["errors"])


def test_validate_rejects_missing_image_and_bad_answer(tmp_path):
    row = _row(tmp_path / "missing.png", "street", "street.png")
    row["messages"][1]["content"] = "So the total count is 9."
    train = tmp_path / "train.jsonl"
    val = tmp_path / "val.jsonl"
    _write(train, [row])
    _write(val, [])

    report = validator.validate(train, val)

    assert report["valid"] is False
    assert any("missing image" in error for error in report["errors"])
    assert any("answer point count" in error for error in report["errors"])
