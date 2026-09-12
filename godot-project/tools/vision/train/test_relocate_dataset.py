import json
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
SCRIPT = HERE / "relocate_dataset.py"


def _row(image: str) -> dict:
    return {"images": [image], "messages": []}


def test_rewrites_image_paths_to_current_data_dir(tmp_path):
    images = tmp_path / "images"
    images.mkdir()
    (images / "a.png").write_bytes(b"png")
    for split in ("train", "val"):
        (tmp_path / f"{split}.jsonl").write_text(
            json.dumps(_row("/mnt/e/old/data/images/a.png")) + "\n", encoding="utf-8"
        )
    r = subprocess.run(
        [sys.executable, str(SCRIPT), "--data", str(tmp_path)],
        capture_output=True,
        text=True,
        check=False,
    )
    assert r.returncode == 0, r.stderr
    for split in ("train", "val"):
        row = json.loads((tmp_path / f"{split}.jsonl").read_text(encoding="utf-8"))
        assert row["images"] == [str((images / "a.png").resolve())]


def test_missing_relocated_image_fails_without_overwriting(tmp_path):
    (tmp_path / "images").mkdir()  # dir exists, but the referenced file does not
    original = json.dumps(_row("/old/missing.png")) + "\n"
    (tmp_path / "train.jsonl").write_text(original, encoding="utf-8")
    (tmp_path / "val.jsonl").write_text(original, encoding="utf-8")
    r = subprocess.run(
        [sys.executable, str(SCRIPT), "--data", str(tmp_path)],
        capture_output=True,
        text=True,
        check=False,
    )
    assert r.returncode != 0
    assert "missing relocated image" in (r.stdout + r.stderr)
    assert (tmp_path / "train.jsonl").read_text(encoding="utf-8") == original
