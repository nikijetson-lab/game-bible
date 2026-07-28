#!/usr/bin/env python3
"""Generate the Hazemoor production content inventory from repository truth.

This file intentionally records presence and wiring, not subjective visual quality.
Run from the Godot project root after changing quests, scenes, NPCs, dialogues, or GLBs.
"""

from __future__ import annotations

import json
import re
from collections import defaultdict
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "data" / "content_manifest.json"
RES_PREFIX = "res://"


def res_path(path: Path) -> str:
    return RES_PREFIX + path.relative_to(ROOT).as_posix()


def load_json(path: Path) -> dict[str, Any]:
    with path.open(encoding="utf-8") as handle:
        return json.load(handle)


def parse_canon_order() -> list[str]:
    source = (ROOT / "tools" / "validate_quest_canon.py").read_text(encoding="utf-8")
    match = re.search(r"CANON_ORDER\s*=\s*\[(.*?)\]", source, re.DOTALL)
    if not match:
        raise RuntimeError("CANON_ORDER not found in validate_quest_canon.py")
    return re.findall(r'["\']([^"\']+)["\']', match.group(1))


def parse_scene_registry() -> dict[str, str]:
    source = (ROOT / "scripts" / "core" / "scene_registry.gd").read_text(encoding="utf-8")
    block = re.search(r"const LOCATION_TO_SCENE\s*:=\s*\{(.*?)\n\}", source, re.DOTALL)
    if not block:
        raise RuntimeError("LOCATION_TO_SCENE not found in scene_registry.gd")
    return dict(re.findall(r'"([^"]+)"\s*:\s*"(res://scenes/[^"]+\.tscn)"', block.group(1)))


def read_scene(scene_path: str) -> str:
    disk_path = ROOT / scene_path.removeprefix(RES_PREFIX)
    return disk_path.read_text(encoding="utf-8") if disk_path.is_file() else ""


def normalized_tokens(value: str) -> set[str]:
    ignored = {"npc", "model", "rigged", "walk", "old", "real", "v2", "clean", "first"}
    return {
        token
        for token in re.split(r"[^a-z0-9]+", value.lower())
        if len(token) >= 3 and token not in ignored
    }


def main() -> None:
    canon_order = parse_canon_order()
    route_map = parse_scene_registry()

    quest_files = {
        path.stem: path
        for path in (ROOT / "data" / "quests").glob("*.json")
        if path.is_file()
    }
    quests_by_id: dict[str, tuple[Path, dict[str, Any]]] = {}
    for path in quest_files.values():
        data = load_json(path)
        quest_id = data.get("id", path.stem)
        if quest_id in quests_by_id:
            raise RuntimeError(f"duplicate quest id: {quest_id}")
        quests_by_id[quest_id] = (path, data)

    npc_registry_path = ROOT / "data" / "npcs" / "npc_registry.json"
    npc_registry = load_json(npc_registry_path)
    npc_dialogues: dict[str, Any] = npc_registry.get("npc_dialogues", {})
    npc_data_ids = set(npc_registry.get("npc_data_files", []))

    placement_path = ROOT / "data" / "npcs" / "npc_placement.json"
    placements = load_json(placement_path).get("npcs", {})
    placement_by_npc: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for scene, entries in placements.items():
        for entry in entries:
            placement_by_npc[entry["npc_id"]].append(
                {"scene": scene, "position": entry.get("pos"), "dialogue": entry.get("dialogue", "")}
            )

    dialogue_paths = sorted((ROOT / "data" / "dialogues").rglob("*.json"))
    dialogues_by_npc: dict[str, list[str]] = defaultdict(list)
    for path in dialogue_paths:
        npc_id = path.parent.name
        dialogues_by_npc[npc_id].append(res_path(path))

    model_paths = sorted((ROOT / "assets").rglob("*.glb"))
    model_res_paths = [res_path(path) for path in model_paths]

    scene_paths = sorted((ROOT / "scenes").rglob("*.tscn"))
    aliases_by_scene: dict[str, list[str]] = defaultdict(list)
    for location, scene in route_map.items():
        aliases_by_scene[scene].append(location)

    scenes: list[dict[str, Any]] = []
    model_scene_refs: dict[str, list[str]] = defaultdict(list)
    for path in scene_paths:
        scene = res_path(path)
        text = path.read_text(encoding="utf-8")
        glb_refs = sorted(set(re.findall(r'path="(res://assets/[^"]+\.glb)"', text)))
        for model in glb_refs:
            model_scene_refs[model].append(scene)
        art_scripts = sorted(set(re.findall(r'path="(res://scripts/gameplay/[^"]*ArtAssembly\.gd)"', text)))
        npc_ids = sorted(set(re.findall(r'\bnpc_id\s*=\s*"([^"]+)"', text)))
        placement_ids = sorted(entry["npc_id"] for entry in placements.get(scene, []))
        scenes.append(
            {
                "path": scene,
                "route_aliases": sorted(aliases_by_scene.get(scene, [])),
                "npc_ids_in_scene": npc_ids,
                "npc_ids_in_placement_map": placement_ids,
                "glb_references": glb_refs,
                "art_assembly_scripts": art_scripts,
                "location_portal_markers": len(re.findall(r"LocationPortal|location_portal\.gd", text)),
                "inventory_status": "present",
                "production_acceptance": "unverified",
            }
        )

    all_npc_ids = set(npc_data_ids) | set(npc_dialogues) | set(dialogues_by_npc) | set(placement_by_npc)
    npc_data_paths = {
        path.stem: res_path(path)
        for path in (ROOT / "data" / "npcs").glob("*.json")
        if path.name not in {"npc_registry.json", "npc_placement.json"}
    }
    npcs: list[dict[str, Any]] = []
    for npc_id in sorted(all_npc_ids):
        tokens = normalized_tokens(npc_id)
        candidates = [
            model
            for model in model_res_paths
            if tokens and tokens <= normalized_tokens(Path(model).stem)
        ]
        npcs.append(
            {
                "id": npc_id,
                "data_file": npc_data_paths.get(npc_id, ""),
                "dialogue_files": sorted(dialogues_by_npc.get(npc_id, [])),
                "placements": placement_by_npc.get(npc_id, []),
                "model_candidates": candidates,
                "data_status": "present" if npc_id in npc_data_paths else "missing",
                "dialogue_status": "present" if dialogues_by_npc.get(npc_id) else "missing",
                "placement_status": "present" if placement_by_npc.get(npc_id) else "missing",
                "production_acceptance": "unverified",
            }
        )

    quest_entries: list[dict[str, Any]] = []
    for index, quest_id in enumerate(canon_order, start=1):
        if quest_id not in quests_by_id:
            raise RuntimeError(f"canonical quest file missing: {quest_id}")
        path, quest = quests_by_id[quest_id]
        objectives = quest.get("objectives", [])
        locations = []
        start_location = quest.get("start_location", "")
        if start_location:
            locations.append(start_location)
        locations.extend(obj.get("location", "") for obj in objectives if obj.get("location"))
        locations = list(dict.fromkeys(locations))

        scene_routes = {location: route_map.get(location, "") for location in locations}
        missing_routes = sorted(location for location, scene in scene_routes.items() if not scene)
        missing_scene_files = sorted(
            scene
            for scene in set(scene_routes.values())
            if scene and not (ROOT / scene.removeprefix(RES_PREFIX)).is_file()
        )

        targets = sorted(
            {
                str(obj.get("target", "")).removeprefix("npc_")
                for obj in objectives
                if obj.get("type") == "talk" and obj.get("target")
            }
        )
        target_coverage = []
        for target in targets:
            aliases = [target]
            if target == "carver":
                aliases.append("woodcarver")
            matched = next((alias for alias in aliases if alias in all_npc_ids), "")
            if not matched:
                # short-form alias: quest uses "rein" while registry has "deacon_rein"
                for npc_id in sorted(all_npc_ids):
                    if npc_id == target or npc_id.startswith(f"{target}_") or npc_id.endswith(f"_{target}"):
                        matched = npc_id
                        break
            target_coverage.append(
                {
                    "target": target,
                    "resolved_npc_id": matched,
                    "dialogue_status": "present" if matched and dialogues_by_npc.get(matched) else "missing",
                    "placement_status": "present" if matched and placement_by_npc.get(matched) else "missing",
                }
            )

        data_ready = bool(objectives) and bool(quest.get("title"))
        routes_ready = not missing_routes and not missing_scene_files
        quest_entries.append(
            {
                "canon_index": index,
                "id": quest_id,
                "title": quest.get("title", ""),
                "quest_file": res_path(path),
                "start_location": start_location,
                "objective_counts": {
                    "total": len(objectives),
                    "required": sum(bool(obj.get("required", True)) for obj in objectives),
                    "optional": sum(not bool(obj.get("required", True)) for obj in objectives),
                },
                "locations": locations,
                "scene_routes": scene_routes,
                "talk_target_coverage": target_coverage,
                "missing_route_locations": missing_routes,
                "missing_scene_files": missing_scene_files,
                "data_status": "ready" if data_ready else "incomplete",
                "route_status": "ready" if routes_ready else "incomplete",
                "inventory_status": "data_and_routes_ready" if data_ready and routes_ready else "blocked",
                "production_acceptance": "unverified",
            }
        )

    models = [
        {
            "path": model,
            "referenced_by_scenes": sorted(model_scene_refs.get(model, [])),
            "reference_status": "wired" if model_scene_refs.get(model) else "unreferenced",
            "embedded_animation_candidate": any(
                token in Path(model).stem.lower() for token in ("walk", "rigged", "anim")
            ),
            "production_acceptance": "unverified",
        }
        for model in model_res_paths
    ]

    missing_routes_total = sum(len(entry["missing_route_locations"]) for entry in quest_entries)
    manifest = {
        "schema_version": 1,
        "generated_by": "tools/generate_content_manifest.py",
        "policy": {
            "source_of_truth": "data/quests/*.json",
            "generated_file": True,
            "do_not_hand_edit": True,
            "production_acceptance_rule": "Only a real Godot, gameplay, and visual gate may change unverified acceptance.",
        },
        "summary": {
            "canonical_quests": len(quest_entries),
            "quests_data_ready": sum(entry["data_status"] == "ready" for entry in quest_entries),
            "quests_routes_ready": sum(entry["route_status"] == "ready" for entry in quest_entries),
            "missing_route_references": missing_routes_total,
            "route_aliases": len(route_map),
            "scene_files": len(scenes),
            "npc_records": len(npcs),
            "dialogue_files": len(dialogue_paths),
            "glb_models": len(models),
            "glb_models_wired": sum(model["reference_status"] == "wired" for model in models),
            "embedded_animation_candidates": sum(model["embedded_animation_candidate"] for model in models),
        },
        "quests": quest_entries,
        "scenes": scenes,
        "npcs": npcs,
        "dialogues": [
            {"path": res_path(path), "npc_id": path.parent.name, "inventory_status": "present"}
            for path in dialogue_paths
        ],
        "models": models,
    }

    if len(quest_entries) != 24:
        raise RuntimeError(f"expected 24 canonical quests, found {len(quest_entries)}")
    if set(canon_order) != set(quests_by_id):
        extras = sorted(set(quests_by_id) - set(canon_order))
        missing = sorted(set(canon_order) - set(quests_by_id))
        raise RuntimeError(f"canon/file mismatch: extras={extras}, missing={missing}")

    OUTPUT.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(manifest["summary"], ensure_ascii=False, indent=2))
    print(f"WROTE {OUTPUT}")


if __name__ == "__main__":
    main()
