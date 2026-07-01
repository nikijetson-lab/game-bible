#!/usr/bin/env python3
"""Smoke tests for Greyford taverns and playable tavern interactions.

These tests lock the current lore split:
- Greyford has two taverns.
- The first/main tavern is Ervan's inn, not a generic NPC dump.
- The port tavern is a separate dockside interior where Cassandra appears.
- Mia belongs to Hazemoor swamp/Moura locations and must not appear in taverns.
- Kelm belongs to Greyford administration and must not be placed in taverns.
"""
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
GODOT = ROOT / "godot-project"


def read(path: Path) -> str:
    assert path.exists(), f"Missing expected file: {path.relative_to(ROOT)}"
    return path.read_text(encoding="utf-8")


def load_json(path: Path) -> dict:
    assert path.exists(), f"Missing expected JSON: {path.relative_to(ROOT)}"
    return json.loads(path.read_text(encoding="utf-8-sig"))


def assert_dialogue_manager_compatible(path: Path) -> None:
    data = load_json(path)
    assert isinstance(data.get("nodes"), dict), f"nodes must be object/dict in {path.relative_to(ROOT)}"
    start = data.get("start_node", "node_0")
    assert start in data["nodes"], f"start_node {start!r} missing in {path.relative_to(ROOT)}"


def test_greyford_has_two_distinct_taverns():
    greyford = load_json(GODOT / "data" / "locations" / "greyford.json")
    zones = {zone["id"]: zone for zone in greyford["zones"]}

    assert "greyford_tavern" in zones
    assert "greyford_port_tavern" in zones
    assert zones["greyford_tavern"]["name"] == "Таверна «Скрипучий знак»"
    assert "порт" in zones["greyford_port_tavern"]["name"].lower()
    assert "cassandra" in zones["greyford_port_tavern"].get("npcs", [])
    assert "ervan" in zones["greyford_tavern"].get("npcs", [])


def test_player_controller_has_interaction_flow():
    text = read(GODOT / "scripts" / "gameplay" / "player_controller.gd")
    assert "func try_interact" in text
    assert 'Input.is_action_just_pressed("interact")' in text
    assert "interact(self)" in text
    assert 'add_to_group("player")' in text


def test_player_scene_has_interaction_area():
    text = read(GODOT / "scenes" / "characters" / "player.tscn")
    assert 'node name="InteractionArea" type="Area3D"' in text
    assert 'node name="InteractionShape" type="CollisionShape3D" parent="InteractionArea"' in text
    assert "SphereShape3D_interaction" in text


def test_main_tavern_is_ervans_inn_without_swamp_or_admin_npcs():
    text = read(GODOT / "scenes" / "locations" / "greyford" / "TavernInterior.tscn")
    assert 'path="res://scenes/characters/player.tscn"' in text
    assert 'node name="Player" parent="." instance=ExtResource' in text
    assert 'npc_id = "ervan"' in text
    assert 'npc_id = "mia"' not in text
    assert 'npc_id = "kelm"' not in text
    assert 'npc_id = "cassandra"' not in text


def test_port_tavern_has_cassandra_and_port_bartender():
    text = read(GODOT / "scenes" / "locations" / "greyford" / "PortTavernInterior.tscn")
    assert 'path="res://scenes/characters/player.tscn"' in text
    assert 'node name="Player" parent="." instance=ExtResource' in text
    assert 'npc_id = "cassandra"' in text
    assert 'npc_id = "port_bartender"' in text
    assert 'npc_id = "mia"' not in text
    assert 'npc_id = "kelm"' not in text
    assert "зелена сукня" in text or "смарагд" in text
    assert "портов" in text.lower()


def test_tavern_dialogues_are_dialogue_manager_compatible():
    dialogue_paths = [
        GODOT / "data" / "dialogues" / "ervan" / "about_rufin.json",
        GODOT / "data" / "dialogues" / "cassandra" / "about_rufin.json",
        GODOT / "data" / "dialogues" / "port_bartender" / "default.json",
    ]
    for path in dialogue_paths:
        assert_dialogue_manager_compatible(path)


def test_port_tavern_contains_no_unconfirmed_invented_lore():
    checked_paths = [
        GODOT / "data" / "locations" / "greyford.json",
        GODOT / "data" / "npcs" / "cassandra.json",
        GODOT / "data" / "npcs" / "port_bartender.json",
        GODOT / "data" / "dialogues" / "cassandra" / "about_rufin.json",
        GODOT / "data" / "dialogues" / "port_bartender" / "default.json",
        GODOT / "scenes" / "locations" / "greyford" / "PortTavernInterior.tscn",
    ]
    forbidden = [
        "Солоний",
        "Солоного",
        "Ліхтар",
        "RufinClueNote",
        "записка Руфіна",
        "Темна печатка",
        "печатка",
        "руками чиновника",
        "поглядом різника",
        "не довіряє Келму",
    ]
    for path in checked_paths:
        text = read(path)
        for phrase in forbidden:
            assert phrase not in text, f"Unconfirmed port-tavern lore {phrase!r} remains in {path.relative_to(ROOT)}"


def test_mia_and_kelm_locations_stay_outside_taverns():
    mia = load_json(GODOT / "data" / "npcs" / "mia.json")
    kelm = load_json(GODOT / "data" / "npcs" / "kelm.json")
    assert mia["location"]["default"] == "hazemoor_moura_clearing"
    assert "tavern" not in json.dumps(mia["location"], ensure_ascii=False).lower()
    assert kelm["location"]["default"] == "greyford_administration"
    assert "tavern" not in json.dumps(kelm["location"], ensure_ascii=False).lower()


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
