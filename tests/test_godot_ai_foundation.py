#!/usr/bin/env python3
"""Smoke tests for the Godot NPC AI foundation and Greyford taverns."""
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GODOT = ROOT / "godot-project"


def read(path: Path) -> str:
    assert path.exists(), f"Missing expected file: {path.relative_to(ROOT)}"
    return path.read_text(encoding="utf-8")


def test_ai_planner_script_exists_with_core_api():
    text = read(GODOT / "scripts" / "ai" / "AIPlanner.gd")
    assert "class_name AIPlanner" in text
    assert "enum Intent" in text
    assert "func choose_intent" in text
    assert "func build_dialogue_context" in text
    assert "func describe_intent" in text


def test_npc_behavior_script_exists_with_interaction_api():
    text = read(GODOT / "scripts" / "ai" / "NPCBehavior.gd")
    assert "class_name NPCBehavior" in text
    assert "@export var npc_id" in text
    assert "@export var default_dialogue_id" in text
    assert "func interact" in text
    assert "func get_interaction_prompt" in text
    assert "AIPlanner.choose_intent" in text


def test_greyford_main_tavern_contains_ervan_only_as_story_npc():
    text = read(GODOT / "scenes" / "locations" / "greyford" / "TavernInterior.tscn")
    assert "res://scripts/ai/NPCBehavior.gd" in text
    assert 'npc_id = "ervan"' in text
    assert 'npc_display_name = "Ерван"' in text
    assert 'npc_id = "mia"' not in text
    assert 'npc_id = "kelm"' not in text
    assert 'npc_id = "cassandra"' not in text
    assert "DialogueAnchor" in text
    assert "QuestBoard" in text


def test_greyford_port_tavern_contains_cassandra_and_port_bartender():
    text = read(GODOT / "scenes" / "locations" / "greyford" / "PortTavernInterior.tscn")
    assert "res://scripts/ai/NPCBehavior.gd" in text
    assert 'npc_id = "cassandra"' in text
    assert 'npc_display_name = "Касандра"' in text
    assert 'npc_id = "port_bartender"' in text
    assert 'npc_id = "mia"' not in text
    assert 'npc_id = "kelm"' not in text
    assert "DialogueAnchor" in text


if __name__ == "__main__":
    failed = 0
    for name, fn in sorted(globals().items()):
        if name.startswith("test_") and callable(fn):
            try:
                fn()
                print(f"PASS {name}")
            except Exception as exc:
                failed += 1
                print(f"FAIL {name}: {exc}")
    raise SystemExit(1 if failed else 0)
