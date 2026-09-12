import json
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
SCRIPT = HERE / "swift_result_to_pred.py"


def _run(infer_path: Path, out_path: Path):
    return subprocess.run(
        [
            sys.executable,
            str(SCRIPT),
            "--infer",
            str(infer_path),
            "--out",
            str(out_path),
        ],
        capture_output=True,
        text=True,
        check=False,
    )


def test_extracts_response_field(tmp_path):
    infer = tmp_path / "infer.jsonl"
    infer.write_text(
        json.dumps({"response": "count is 3"})
        + "\n"
        + json.dumps({"response": "count is 5"})
        + "\n",
        encoding="utf-8",
    )
    out = tmp_path / "pred.jsonl"
    r = _run(infer, out)
    assert r.returncode == 0, r.stderr
    rows = [json.loads(l) for l in out.read_text(encoding="utf-8").splitlines()]
    assert rows == [{"prediction": "count is 3"}, {"prediction": "count is 5"}]


def test_extracts_from_messages(tmp_path):
    infer = tmp_path / "infer.jsonl"
    infer.write_text(
        json.dumps(
            {
                "messages": [
                    {"role": "user", "content": "q"},
                    {"role": "assistant", "content": "answer text"},
                ]
            }
        )
        + "\n",
        encoding="utf-8",
    )
    out = tmp_path / "pred.jsonl"
    r = _run(infer, out)
    assert r.returncode == 0, r.stderr
    assert json.loads(out.read_text(encoding="utf-8").strip()) == {
        "prediction": "answer text"
    }


def test_unknown_shape_errors(tmp_path):
    infer = tmp_path / "infer.jsonl"
    infer.write_text(json.dumps({"nope": 1}) + "\n", encoding="utf-8")
    out = tmp_path / "pred.jsonl"
    r = _run(infer, out)
    assert r.returncode != 0
    assert "no response field" in (r.stderr + r.stdout)
