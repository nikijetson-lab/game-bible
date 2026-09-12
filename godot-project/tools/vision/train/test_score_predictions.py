import importlib.util
from pathlib import Path

MODULE_PATH = Path(__file__).with_name("score_predictions.py")
spec = importlib.util.spec_from_file_location("score_predictions", MODULE_PATH)
assert spec and spec.loader
score = importlib.util.module_from_spec(spec)
spec.loader.exec_module(score)


def _gt():
    return {
        "markers": [
            {"nx": 100, "ny": 200, "color": "red", "text": "KEY"},
            {"nx": 800, "ny": 700, "color": "blue", "text": None},
        ]
    }


def test_parse_prediction_extracts_points_colors_labels_and_count():
    text = (
        "Marker coordinates: <point>105 195</point>, <point>790 710</point>. "
        "Colors in order: red, blue. Visible labels: KEY. So the total count is 2."
    )
    parsed = score.parse_prediction(text)
    assert parsed["points"] == [(105, 195), (790, 710)]
    assert parsed["colors"] == ["red", "blue"]
    assert parsed["labels"] == ["KEY"]
    assert parsed["count"] == 2


def test_score_prediction_matches_points_without_relying_on_order():
    text = (
        "Marker coordinates: <point>795 705</point>, <point>102 198</point>. "
        "Colors in order: blue, red. Visible labels: KEY. So the total count is 2."
    )
    metrics = score.score_prediction(_gt(), text, point_tolerance=30)
    assert metrics["count_exact"] == 1.0
    assert metrics["point_f1"] == 1.0
    assert metrics["color_f1"] == 1.0
    assert metrics["ocr_f1"] == 1.0


def test_score_prediction_penalizes_missing_marker_and_wrong_count():
    text = (
        "Marker coordinates: <point>100 200</point>. Colors in order: red. "
        "Visible labels: KEY. So the total count is 1."
    )
    metrics = score.score_prediction(_gt(), text, point_tolerance=30)
    assert metrics["count_exact"] == 0.0
    assert 0.0 < metrics["point_f1"] < 1.0
    assert 0.0 < metrics["color_f1"] < 1.0
    assert metrics["ocr_f1"] == 1.0


def test_aggregate_reports_macro_means():
    rows = [
        {"count_exact": 1.0, "point_f1": 1.0, "color_f1": 0.5, "ocr_f1": 1.0},
        {"count_exact": 0.0, "point_f1": 0.0, "color_f1": 0.5, "ocr_f1": 0.0},
    ]
    result = score.aggregate(rows)
    assert result == {
        "samples": 2,
        "count_accuracy": 0.5,
        "point_f1": 0.5,
        "color_f1": 0.5,
        "ocr_f1": 0.5,
        "composite": 0.5,
    }
