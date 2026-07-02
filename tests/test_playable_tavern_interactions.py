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
import re
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


def test_greyford_missing_recipient_json_follows_ep1_01_canonical_route():
    quest = load_json(GODOT / "data" / "quests" / "greyford_01_missing_recipient.json")
    assert quest["start_location"] == "greyford_tavern"

    objective_ids = [objective["id"] for objective in quest["objectives"]]
    assert objective_ids == [
        "talk_to_ervan",
        "inspect_rufin_room",
        "ask_craftsmen_quarter",
        "question_port_tavern",
        "consult_alteya_optional",
        "speak_to_gate_sergeant",
    ]
    assert "talk_to_kelm" not in objective_ids
    assert "choice_path" not in objective_ids

    objective_locations = {objective["id"]: objective.get("location") for objective in quest["objectives"]}
    assert objective_locations["talk_to_ervan"] == "greyford_tavern"
    assert objective_locations["inspect_rufin_room"] == "greyford_rufin_room"
    assert objective_locations["ask_craftsmen_quarter"] == "greyford_craftsmen_quarter"
    assert objective_locations["question_port_tavern"] == "greyford_port_tavern"
    assert objective_locations["consult_alteya_optional"] == "greyford_alteya_hidden_room"
    assert objective_locations["speak_to_gate_sergeant"] == "greyford_gate"

    assert quest["unlocks"] == ["hazemoor_01_path_through_swamp"]


def test_greyford_missing_recipient_json_records_ep1_01_clues_without_spoiling_mour():
    quest = load_json(GODOT / "data" / "quests" / "greyford_01_missing_recipient.json")
    clue_ids = [clue["id"] for clue in quest["canonical_clues"]]
    assert clue_ids == [
        "letter_seal",
        "rufin_room_bag_and_clay",
        "craftsman_tihyi_shelist",
        "port_tavern_courtesan",
        "alteya_glow_optional",
        "gate_log",
    ]
    assert "Орден Семи Кинджалів" not in json.dumps(quest, ensure_ascii=False)
    assert "Моур" not in json.dumps(quest, ensure_ascii=False)


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


def test_player_controller_has_fall_reset():
    text = read(GODOT / "scripts" / "gameplay" / "player_controller.gd")
    assert "fall_reset_y" in text, "player controller must define a fall threshold"
    assert "spawn_position" in text, "player controller must remember a safe spawn"
    assert "global_position = spawn_position" in text, "player must teleport back to spawn on fall"


def _count_boundary_collision_shapes(text: str) -> int:
    return text.count('type="CollisionShape3D" parent="Boundaries"')


def test_main_tavern_has_collision_boundaries():
    text = read(GODOT / "scenes" / "locations" / "greyford" / "TavernInterior.tscn")
    assert 'node name="Boundaries" type="StaticBody3D"' in text, "main tavern needs a physical Boundaries body"
    assert _count_boundary_collision_shapes(text) >= 4, "main tavern needs at least 4 wall collision shapes"


def test_port_tavern_has_collision_boundaries():
    text = read(GODOT / "scenes" / "locations" / "greyford" / "PortTavernInterior.tscn")
    assert 'node name="Boundaries" type="StaticBody3D"' in text, "port tavern needs a physical Boundaries body"
    assert _count_boundary_collision_shapes(text) >= 4, "port tavern needs at least 4 wall collision shapes"


def _assert_bar_counter_blocks_player(scene_path: Path) -> None:
    text = read(scene_path)
    assert '[node name="BarCounter" type="StaticBody3D" parent="."]' in text, "bar counter must be a physics body"
    assert '[sub_resource type="BoxShape3D" id="BoxShape3D_bar"]' in text, "bar counter needs a box collision shape resource"
    assert '[node name="CollisionShape3D" type="CollisionShape3D" parent="BarCounter"]' in text, (
        "bar counter must have a CollisionShape3D child so the player cannot walk through it"
    )
    assert 'shape = SubResource("BoxShape3D_bar")' in text, "bar counter collision must use the bar-sized shape"


def test_main_tavern_bar_counter_blocks_player():
    _assert_bar_counter_blocks_player(GODOT / "scenes" / "locations" / "greyford" / "TavernInterior.tscn")


def _node_transform_z(text: str, node_header: str) -> float:
    idx = text.index(node_header)
    block = text[idx:]
    match = re.search(r"transform = Transform3D\(([^\)]*)\)", block)
    assert match, f"no transform found after {node_header!r}"
    numbers = [float(n) for n in match.group(1).split(",")]
    return numbers[11]


def test_main_tavern_ervan_stands_behind_bar_counter():
    text = read(GODOT / "scenes" / "locations" / "greyford" / "TavernInterior.tscn")
    player_z = _node_transform_z(text, '[node name="Player" parent="." instance=ExtResource("2_player")]')
    bar_z = _node_transform_z(text, '[node name="BarCounter" type="StaticBody3D" parent="."]')
    ervan_z = _node_transform_z(text, '[node name="Ervan" type="Area3D" parent="NPCs"]')

    # Guests (and the player) sit on the larger-z side of the bar.
    assert player_z > bar_z, "player should spawn on the guest side of the bar"
    # Ervan must stand on the opposite (service) side, i.e. more negative z than the counter.
    assert ervan_z < bar_z, "Ervan must stand behind the bar counter, not on the guest side"


def test_main_tavern_has_art_grounded_ervan_props():
    text = read(GODOT / "scenes" / "locations" / "greyford" / "TavernInterior.tscn")
    # From concept art page_03: leather apron, towel on shoulder, key ring with one brass key,
    # hanging lantern on a ceiling beam, diamond-pane windows.
    assert "фартух" in text, "Ervan should read as the leather-aproned innkeeper from page_03"
    assert "ключі" in text or "ключ" in text, "Ervan should carry the key ring seen in page_03"
    assert 'node name="HangingLantern"' in text, "art shows a lantern hanging from a ceiling beam"


def test_main_tavern_uses_meshy_glb_assets_as_visible_layer_with_fallback_collision():
    text = read(GODOT / "scenes" / "locations" / "greyford" / "TavernInterior.tscn")
    for expected in [
        "res://assets/meshy/greyford_tavern/ervan_innkeeper.glb",
        "res://assets/meshy/greyford_tavern/tavern_bar_counter.glb",
        "res://assets/meshy/greyford_tavern/tavern_props_kit.glb",
        "res://assets/meshy/greyford_tavern/creaking_sign.glb",
        'node name="MeshyAssets" type="Node3D" parent="."',
        'node name="MeshyErvanModel" parent="NPCs/Ervan" instance=ExtResource',
        'node name="MeshyBarCounter" parent="MeshyAssets" instance=ExtResource',
        'node name="MeshyPropsKit" parent="MeshyAssets" instance=ExtResource',
        'node name="MeshyCreakingSign" parent="MeshyAssets" instance=ExtResource',
        'metadata/credits_consumed = 90',
    ]:
        assert expected in text, f"Expected Meshy tavern asset layer item {expected!r}"
    assert 'node name="CollisionShape3D" type="CollisionShape3D" parent="BarCounter"' in text
    assert 'node name="CollisionShape3D" type="CollisionShape3D" parent="NPCs/Ervan"' in text
    ervan_block = text[text.index('[node name="Body" type="MeshInstance3D" parent="NPCs/Ervan"]'):text.index('[node name="MeshyErvanModel" parent="NPCs/Ervan"')]
    assert "visible = false" in ervan_block, "primitive capsule fallback must be hidden so Meshy Ervan is visible"
    # Canon (concept art 007_p03 + user staging note): the letter is not baked onto
    # Ervan's apron and must not be visible on Ervan at scene start. It starts with
    # the guard, then the dialogue handoff reveals it in Ervan's hands.
    assert "res://assets/meshy/greyford_tavern/ervan_innkeeper_clean_apron.glb" in text, "clean-apron retextured Ervan GLB expected"
    assert 'node name="HeldLetter" type="MeshInstance3D" parent="NPCs/Ervan"' in text, "sealed letter must be a held prop for the handoff beat"
    assert 'node name="WaxSeal" type="MeshInstance3D" parent="NPCs/Ervan/HeldLetter"' in text, "letter carries the red wax seal from the art"
    assert 'node name="GreyfordGuard" type="Area3D" parent="NPCs"' in text, "guard must bring the letter into the scene"
    assert 'node name="CarriedLetter" type="MeshInstance3D" parent="NPCs/GreyfordGuard"' in text, "letter starts with the guard"
    assert 'node name="LetterHandoffStaging" type="Node" parent="."' in text, "staging controller should switch letter visibility during dialogue"
    assert 'metadata/removed_from_start = "Hidden: the sealed letter starts with the guard, not floating on the bar."' in text, "old bar letter/white plank must be hidden"
    assert 'node name="GuardStart" type="Marker3D" parent="Staging"' in text
    assert 'node name="GuardHandoff" type="Marker3D" parent="Staging"' in text
    assert 'node name="ErvanLetterCloseup" type="Marker3D" parent="Staging"' in text
    assert 'node name="WipingTowel" type="MeshInstance3D" parent="NPCs/Ervan"' in text, "Ervan starts by wiping the bar with the towel in hand"
    assert 'wiping_towel_path = NodePath("../NPCs/Ervan/WipingTowel")' in text
    assert 'shoulder_towel_path = NodePath("../NPCs/Ervan/ShoulderTowel")' in text
    assert 'Mat_towel_cloth' in text, "towel must not use the pale paper material that read as a white plank"

    shoulder_towel_block = text[text.index('[node name="ShoulderTowel" type="MeshInstance3D" parent="NPCs/Ervan"]'):]
    shoulder_towel_block = shoulder_towel_block[:shoulder_towel_block.index("[node ", 10)]
    assert "visible = false" in shoulder_towel_block, "shoulder towel appears only after the guard/dialogue starts"

    wiping_towel_block = text[text.index('[node name="WipingTowel" type="MeshInstance3D" parent="NPCs/Ervan"]'):]
    wiping_towel_block = wiping_towel_block[:wiping_towel_block.index("[node ", 10)]
    assert "visible = false" not in wiping_towel_block, "wiping towel must be visible at scene start"

    staging_script = read(GODOT / "scripts" / "gameplay" / "TavernLetterStaging.gd")
    assert "func throw_towel_over_shoulder" in staging_script
    assert "_set_visible(wiping_towel_path, false)" in staging_script
    assert "_set_visible(shoulder_towel_path, true)" in staging_script
    assert "_start_wiping()" in staging_script

    held_letter_block = text[text.index('[node name="HeldLetter" type="MeshInstance3D" parent="NPCs/Ervan"]'):]
    held_letter_block = held_letter_block[:held_letter_block.index("[node ", 10)]
    assert "visible = false" in held_letter_block, "Ervan must not hold/show the letter at scene start"

    bar_letter_block = text[text.index('[node name="SealedLetter" type="MeshInstance3D" parent="BarCounter"]'):]
    bar_letter_block = bar_letter_block[:bar_letter_block.index("[node ", 10)]
    assert "visible = false" in bar_letter_block, "old floating bar letter/white plank must be hidden"

    apron_block = text[text.index('[node name="LeatherApron" type="MeshInstance3D" parent="NPCs/Ervan"]'):]
    apron_block = apron_block[:apron_block.index("[node ", 10)]
    assert "BoxMesh_letter" not in apron_block, "letter must not be parented to the apron"


def test_port_tavern_bar_counter_blocks_player():
    _assert_bar_counter_blocks_player(GODOT / "scenes" / "locations" / "greyford" / "PortTavernInterior.tscn")


def test_mia_and_kelm_locations_stay_outside_taverns():
    mia = load_json(GODOT / "data" / "npcs" / "mia.json")
    kelm = load_json(GODOT / "data" / "npcs" / "kelm.json")
    assert mia["location"]["default"] == "hazemoor_moura_clearing"
    assert "tavern" not in json.dumps(mia["location"], ensure_ascii=False).lower()
    assert kelm["location"]["default"] == "greyford_administration"
    assert "tavern" not in json.dumps(kelm["location"], ensure_ascii=False).lower()


def test_block_a_interaction_scripts_exist_for_scene_links_and_clues():
    portal = read(GODOT / "scripts" / "gameplay" / "LocationPortal.gd")
    clue = read(GODOT / "scripts" / "gameplay" / "InspectClue.gd")

    assert "class_name LocationPortal" in portal
    assert "destination_scene" in portal
    assert "destination_location" in portal
    assert "func interact" in portal
    assert 'add_to_group("interactable")' in portal

    assert "class_name InspectClue" in clue
    assert "clue_id" in clue
    assert "quest_id" in clue
    assert "func interact" in clue
    assert 'add_to_group("interactable")' in clue


def test_block_a_greyford_location_data_exposes_canonical_zones_and_links():
    greyford = load_json(GODOT / "data" / "locations" / "greyford.json")
    zones = {zone["id"]: zone for zone in greyford["zones"]}

    for zone_id in [
        "greyford_rufin_room",
        "greyford_craftsmen_quarter",
        "greyford_gate",
    ]:
        assert zone_id in zones, f"Block A zone missing from greyford.json: {zone_id}"

    assert "woodcarver" in zones["greyford_craftsmen_quarter"].get("npcs", [])
    assert "furrier" in zones["greyford_craftsmen_quarter"].get("npcs", [])
    assert "gate_sergeant" in zones["greyford_gate"].get("npcs", [])

    tavern_links = [link["to"] for link in zones["greyford_tavern"].get("connections", [])]
    crafts_links = [link["to"] for link in zones["greyford_craftsmen_quarter"].get("connections", [])]
    port_links = [link["to"] for link in zones["greyford_port_tavern"].get("connections", [])]
    gate_links = [link["to"] for link in zones["greyford_gate"].get("connections", [])]

    assert "greyford_rufin_room" in tavern_links
    assert "greyford_craftsmen_quarter" in tavern_links
    assert "greyford_port_tavern" in crafts_links
    assert "greyford_gate" in port_links
    assert "route_to_tihyi_shelist" in gate_links


def test_block_a_scenes_exist_with_player_anchors_boundaries_and_portals():
    scene_requirements = {
        "RufinRoom.tscn": [
            'node name="Player" parent="." instance=ExtResource',
            'node name="DialogueAnchor" type="Marker3D"',
            'node name="Boundaries" type="StaticBody3D"',
            'node name="BackToTavernPortal" type="Area3D" parent="Portals"',
            'node name="ToCraftsmenQuarterPortal" type="Area3D" parent="Portals"',
            'destination_location = "greyford_craftsmen_quarter"',
        ],
        "CraftsmenQuarter.tscn": [
            'node name="Player" parent="." instance=ExtResource',
            'node name="DialogueAnchor" type="Marker3D"',
            'node name="Boundaries" type="StaticBody3D"',
            'node name="Furrier" type="Area3D" parent="NPCs"',
            'npc_id = "furrier"',
            'node name="Woodcarver" type="Area3D" parent="NPCs"',
            'npc_id = "woodcarver"',
            'node name="ToPortTavernPortal" type="Area3D" parent="Portals"',
            'destination_location = "greyford_port_tavern"',
        ],
        "GreyfordGate.tscn": [
            'node name="Player" parent="." instance=ExtResource',
            'node name="DialogueAnchor" type="Marker3D"',
            'node name="Boundaries" type="StaticBody3D"',
            'node name="GateSergeant" type="Area3D" parent="NPCs"',
            'npc_id = "gate_sergeant"',
            'node name="ToSwampPortal" type="Area3D" parent="Portals"',
            'destination_location = "route_to_tihyi_shelist"',
        ],
    }

    for scene_name, required_strings in scene_requirements.items():
        text = read(GODOT / "scenes" / "locations" / "greyford" / scene_name)
        for expected in required_strings:
            assert expected in text, f"{scene_name} missing {expected!r}"
        assert _count_boundary_collision_shapes(text) >= 4, f"{scene_name} needs physical boundary walls"


def test_block_a_rufin_room_contains_canonical_investigation_clues_only():
    text = read(GODOT / "scenes" / "locations" / "greyford" / "RufinRoom.tscn")
    required = [
        "RufinRoomEmptyBed",
        "RufinCloak",
        "LeatherBagWithBrand",
        "BlackBogClay",
        "ProtectiveSigns",
        "rufin_room_bag_and_clay",
        "greyford_01_missing_recipient",
    ]
    for item in required:
        assert item in text

    forbidden = ["Моур", "Орден Семи Кинджалів", "Мія", "Келм"]
    for phrase in forbidden:
        assert phrase not in text, f"Rufin room must not spoil/merge unrelated canon: {phrase!r}"


def test_block_a_dialogues_are_dialogue_manager_compatible_and_canonical():
    dialogue_paths = [
        GODOT / "data" / "dialogues" / "woodcarver" / "about_rufin.json",
        GODOT / "data" / "dialogues" / "furrier" / "default.json",
        GODOT / "data" / "dialogues" / "gate_sergeant" / "about_rufin.json",
        GODOT / "data" / "dialogues" / "alteya" / "about_rufin.json",
    ]
    for path in dialogue_paths:
        assert_dialogue_manager_compatible(path)

    woodcarver = json.dumps(load_json(dialogue_paths[0]), ensure_ascii=False)
    sergeant = json.dumps(load_json(dialogue_paths[2]), ensure_ascii=False)
    alteya = json.dumps(load_json(dialogue_paths[3]), ensure_ascii=False)
    assert "Тихий Шелест" in woodcarver
    assert "щось важке" in woodcarver
    assert "Руфін" in sergeant
    assert "Тихого Шелесту" in sergeant or "Тихий Шелест" in sergeant
    assert "route_to_tihyi_shelist" in sergeant
    assert "Чаклунка Алтея" in alteya or "Лілея" in alteya
    assert "горіло в темряві" in alteya
    assert "Не ліхтар" in alteya
    assert "вона нічого не знає про Руфіна особисто" in alteya


def test_block_a_alteya_is_single_hidden_optional_witch_route_from_text_quests():
    greyford = load_json(GODOT / "data" / "locations" / "greyford.json")
    zones = {zone["id"]: zone for zone in greyford["zones"]}
    assert "greyford_alteya_hidden_room" in zones

    alteya_zone = zones["greyford_alteya_hidden_room"]
    assert alteya_zone.get("type") == "hidden_interior"
    assert alteya_zone.get("optional") is True
    assert "alteya" in alteya_zone.get("npcs", [])
    assert "Лілея" in json.dumps(alteya_zone, ensure_ascii=False)
    assert "Чаклунка Алтея" in json.dumps(alteya_zone, ensure_ascii=False)

    port_links = [link["to"] for link in zones["greyford_port_tavern"].get("connections", [])]
    alteya_links = [link["to"] for link in alteya_zone.get("connections", [])]
    assert "greyford_alteya_hidden_room" in port_links
    assert "greyford_gate" in port_links  # route remains optional, not mandatory
    assert "greyford_gate" in alteya_links

    all_text = json.dumps(greyford, ensure_ascii=False).lower()
    assert all_text.count("чаклунка") == 1, "Алтея/Лілея має бути єдиною чаклункою в Greyford data"
    for public_zone_id in ["greyford_tavern", "greyford_port_tavern", "greyford_craftsmen_quarter", "greyford_gate"]:
        assert "alteya" not in zones[public_zone_id].get("npcs", []), "Алтея не має бути public-square/tavern/gate NPC"


def test_block_a_alteya_hidden_room_scene_has_hidden_portals_and_art_grounded_mood():
    text = read(GODOT / "scenes" / "locations" / "greyford" / "AlteyaHiddenRoom.tscn")
    required = [
        'node name="Player" parent="." instance=ExtResource',
        'node name="DialogueAnchor" type="Marker3D"',
        'node name="Boundaries" type="StaticBody3D"',
        'node name="Alteya" type="Area3D" parent="NPCs"',
        'npc_id = "alteya"',
        'npc_display_name = "Чаклунка Алтея / Лілея"',
        'node name="WaterMirror"',
        'node name="StoneArches"',
        'node name="GoldenCylinder"',
        'node name="SpatialVeilSignature"',
        'node name="ToPortTavernPortal" type="Area3D" parent="Portals"',
        'node name="ToGreyfordGatePortal" type="Area3D" parent="Portals"',
        'destination_location = "greyford_gate"',
        'is_hidden = true',
        'optional = true',
    ]
    for expected in required:
        assert expected in text, f"AlteyaHiddenRoom.tscn missing {expected!r}"
    assert _count_boundary_collision_shapes(text) >= 4
    for forbidden in ["Мія", "Келм", "цілителька", "відьма"]:
        assert forbidden not in text


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
