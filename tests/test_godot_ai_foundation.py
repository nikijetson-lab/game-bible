#!/usr/bin/env python3
"""Smoke tests for the first real Godot NPC AI foundation.

These tests intentionally stay lightweight: they validate that the project has
actual Godot files for NPC planning/behavior and a Greyford tavern scene that
instantiates the first narrative NPCs.
"""
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


def test_greyford_tavern_scene_contains_first_three_npcs():
    text = read(GODOT / "scenes" / "locations" / "greyford" / "TavernInterior.tscn")
    assert "res://scripts/ai/NPCBehavior.gd" in text
    assert 'npc_id = "ervan"' in text
    assert 'npc_id = "mia"' in text
    assert 'npc_id = "kelm"' in text
    assert 'npc_display_name = "Ерван"' in text
    assert 'npc_display_name = "Міа"' in text
    assert 'npc_display_name = "Келм"' in text
    assert "DialogueAnchor" in text
    assert "QuestBoard" in text


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
