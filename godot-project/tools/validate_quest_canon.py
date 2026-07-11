#!/usr/bin/env python3
"""Validate Hazemoor quest canon graph.

Checks:
- duplicate internal quest ids
- file name vs internal id mismatches
- prerequisites / canon_previous that do not resolve to a known quest id
- leads_to targets that do not resolve to a known quest id
- schema readiness: structured objectives vs prose-only design docs
"""
from __future__ import annotations

import argparse
import glob
import json
import os
from collections import defaultdict

# Short/old design names used in quest JSON -> canonical quest ids.
ALIASES = {
    "nizh_kvoty": "sonk_ferry_04_quota_knife",
    "poromna_prysyaga": "sonk_ferry_03_ferry_oath",
    "popil_pid_kaplytseyu": "hazemoor_02_ashes_under_chapel",
    "ep2_valkorn": "valkorn_01_man_from_swamp",
    "valkorn_dvi_versii_pravdy": "valkorn_02_two_truths",
    "valkorn_pravylna_tsina": "valkorn_03_right_price",
    "valkorn_poslanets_rufina": "valkorn_04_messenger_of_rufin",
    "valkorn_khranitel_pershoyi_pechatky": "valkorn_05_keeper_of_first_seal",
    "valkorn_05_lantern_path": "valkorn_05_keeper_of_first_seal",
    "ep3": "deep_bog_01_voice_from_fog",
    "ep4": "ep4_01_return_to_valkorn",
}

CANON_ORDER = [
    "greyford_01_missing_recipient",
    "greyford_side_01_witch_trouble",
    "greyford_side_02_lost_heirloom",
    "hazemoor_01_path_through_swamp",
    "tykhy_shelest_01",
    "sonk_ferry_01_hunger_from_below",
    "sonk_ferry_02_salt_in_book",
    "sonk_ferry_03_ferry_oath",
    "hazemoor_02_ashes_under_chapel",
    "sonk_ferry_04_quota_knife",
    "hazemoor_02_glade_and_mour",
    "valkorn_01_man_from_swamp",
    "valkorn_02_two_truths",
    "valkorn_03_right_price",
    "valkorn_04_messenger_of_rufin",
    "valkorn_05_keeper_of_first_seal",
    "deep_bog_01_voice_from_fog",
    "deep_bog_02_mad_ferry",
    "deep_bog_03_flooded_sanctuary",
    "ep4_01_return_to_valkorn",
    "ep4_02_valkorn_climax",
    "ep4_03_hazemoor_mour_heart",
    "ep4_04_final_resolution",
    "ep4_05_hero_departure",
]

DEPRECATED_IDS = {
    "deep_bog_03_flooded_abbey": "Superseded by deep_bog_03_flooded_sanctuary, which contains the 3 verdicts used by Ep4.",
}


def resolve_id(value: str) -> str:
    return ALIASES.get(value, value)


def schema_of(data: dict) -> str:
    if isinstance(data.get("objectives"), list):
        return "structured"
    for key in ("threads", "phases", "acts", "branches"):
        if key in data:
            return f"prose:{key}"
    return "prose"


def prereq_ids(data: dict) -> list[str]:
    out: list[str] = []
    prereq = data.get("prerequisites", {})
    if isinstance(prereq, dict):
        out += prereq.get("quests_completed", []) or []
    if data.get("canon_previous"):
        out.append(data["canon_previous"])
    return out


def leads_to(data: dict) -> list[str]:
    value = data.get("leads_to")
    if value is None:
        return []
    if isinstance(value, str):
        return [value]
    if isinstance(value, list):
        return value
    return []


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("root", nargs="?", default=os.getcwd(), help="Godot project root")
    parser.add_argument("--strict", action="store_true", help="Treat alias-resolved links and deprecated quests as failures too")
    args = parser.parse_args()

    qdir = os.path.join(args.root, "data", "quests")
    files = sorted(glob.glob(os.path.join(qdir, "*.json")))
    if not files:
        print(f"ERROR: no quest JSON files found in {qdir}")
        return 2

    raw: dict[str, dict] = {}
    parse_errors = []
    for path in files:
        name = os.path.basename(path)
        try:
            raw[name] = json.load(open(path, encoding="utf-8"))
        except Exception as exc:  # noqa: BLE001
            parse_errors.append((name, str(exc)))
            raw[name] = {"id": f"<parse-error:{name}>"}

    id_to_files: dict[str, list[str]] = defaultdict(list)
    for name, data in raw.items():
        id_to_files[data.get("id", "<missing-id>")].append(name)
    ids = set(id_to_files)

    errors: list[str] = []
    warnings: list[str] = []

    for name, exc in parse_errors:
        errors.append(f"parse error: {name}: {exc}")

    for qid, names in sorted(id_to_files.items()):
        if len(names) > 1:
            errors.append(f"duplicate quest id '{qid}' in files: {', '.join(names)}")

    for name, data in sorted(raw.items()):
        stem = name[:-5]
        qid = data.get("id")
        if qid != stem:
            warnings.append(f"file/id mismatch: {name} has id '{qid}'")
        if qid in DEPRECATED_IDS:
            msg = f"deprecated quest id still present: {qid} ({DEPRECATED_IDS[qid]})"
            (errors if args.strict else warnings).append(msg)

        for source in prereq_ids(data):
            target = resolve_id(source)
            if target not in ids:
                errors.append(f"{name}: prerequisite '{source}' resolves to missing quest id '{target}'")
            elif source != target:
                msg = f"{name}: prerequisite uses alias '{source}' -> '{target}'"
                (errors if args.strict else warnings).append(msg)

        for source in leads_to(data):
            target = resolve_id(source)
            if target not in ids:
                errors.append(f"{name}: leads_to '{source}' resolves to missing quest id '{target}'")
            elif source != target:
                msg = f"{name}: leads_to uses alias '{source}' -> '{target}'"
                (errors if args.strict else warnings).append(msg)

    missing_from_canon = [qid for qid in CANON_ORDER if qid not in ids]
    if missing_from_canon:
        errors.append("CANON_ORDER contains missing ids: " + ", ".join(missing_from_canon))

    extra_ids = sorted(qid for qid in ids if qid not in CANON_ORDER and qid not in DEPRECATED_IDS)
    if extra_ids:
        warnings.append("Quest ids not in CANON_ORDER: " + ", ".join(extra_ids))

    prose = []
    structured = []
    for name, data in sorted(raw.items()):
        entry = f"{data.get('id')} ({name})"
        if schema_of(data) == "structured":
            structured.append(entry)
        else:
            prose.append(f"{schema_of(data)}: {entry}")

    print(f"Quest files: {len(files)}")
    print(f"Unique quest ids: {len(ids)}")
    print(f"Structured/engine-ready quests: {len(structured)}")
    print(f"Prose/design-only quests needing objective conversion: {len(prose)}")
    print()

    if warnings:
        print("WARNINGS:")
        for item in warnings:
            print(f"- {item}")
        print()

    if errors:
        print("ERRORS:")
        for item in errors:
            print(f"- {item}")
        return 1

    print("OK: quest canon graph validates")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
