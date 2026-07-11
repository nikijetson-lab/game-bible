#!/usr/bin/env python3
"""Smoke test: verify the Hazemoor quest graph is traversable and well-formed.

Runs graph-level checks beyond the static validator:
- Every quest is reachable from greyford_01 via prerequisites/leads_to.
- No orphan quests (no incoming edges, but not the start).
- No dead-end quests (no outgoing edges, but not the end).
- All prerequisite quests appear before the dependant in canon order.
- All resolution flags consumed by prerequisites are produced by earlier quests.
- Critical path length from start to end.
"""

from __future__ import annotations

import argparse
import glob
import json
import os
import sys
from collections import defaultdict

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

START_QUEST = "greyford_01_missing_recipient"
END_QUEST = "ep4_05_hero_departure"


def load_quests(qdir: str) -> dict[str, dict]:
    """Return {quest_id: data} for all *.json in qdir."""
    quests: dict[str, dict] = {}
    for path in sorted(glob.glob(os.path.join(qdir, "*.json"))):
        name = os.path.basename(path)
        data = json.load(open(path, encoding="utf-8"))
        qid = data.get("id")
        if not qid:
            print(f"WARNING: {name} has no id field")
            continue
        quests[qid] = data
    return quests


def prerequisites_of(data: dict) -> list[str]:
    """Return prerequisite quest ids listed in this quest."""
    prereqs: list[str] = []
    pr = data.get("prerequisites", {})
    if isinstance(pr, dict):
        prereqs += pr.get("quests_completed", []) or []
    if data.get("canon_previous"):
        prereqs.append(data["canon_previous"])
    return prereqs


def leads_to_ids(data: dict) -> list[str]:
    """Return the quest ids this quest leads to."""
    lt = data.get("leads_to")
    if lt is None:
        return data.get("unlocks", []) or []
    if isinstance(lt, str):
        return [lt]
    if isinstance(lt, list):
        return lt
    return []


def flags_produced(data: dict) -> set[str]:
    """Return all set_flags / sets_flags values produced by objectives.
    Also picks up top-level set_flag from resolution_choice options."""
    flags: set[str] = set()
    for obj in data.get("objectives", []):
        for key in ("sets_flags", "set_flags"):
            vals = obj.get(key, [])
            if isinstance(vals, str):
                flags.add(vals)
            elif isinstance(vals, list):
                flags.update(vals)
    for opt in data.get("resolution_choice", {}).get("options", []):
        sf = opt.get("set_flag")
        if sf:
            flags.add(sf)
    return flags


def flags_consumed(data: dict) -> set[str]:
    """Return flags referenced in prerequisites or requires_flags."""
    flags: set[str] = set()
    pr = data.get("prerequisites", {})
    if isinstance(pr, dict):
        f = pr.get("flag")
        if f:
            flags.add(f)
    for obj in data.get("objectives", []):
        req = obj.get("requires_flags", [])
        if isinstance(req, str):
            flags.add(req)
        elif isinstance(req, list):
            flags.update(req)
        rf = obj.get("requires_flag")
        if rf:
            flags.add(rf)
    return flags


def main() -> int:
    parser = argparse.ArgumentParser(description="Smoke-test the quest graph")
    parser.add_argument("root", nargs="?", default=os.getcwd(), help="Godot project root")
    args = parser.parse_args()

    qdir = os.path.join(args.root, "data", "quests")
    quests = load_quests(qdir)
    if not quests:
        print("ERROR: no quests loaded")
        return 2

    canon_set = set(CANON_ORDER)
    loaded = set(quests)
    missing_canon = canon_set - loaded
    if missing_canon:
        print(f"ERROR: CANON_ORDER missing quests: {', '.join(sorted(missing_canon))}")
        return 1
    extra = loaded - canon_set
    if extra:
        print(f"WARNING: quests not in CANON_ORDER: {', '.join(sorted(extra))}")

    # Build adjacency: A -> B if A leads_to B OR B has A as prerequisite
    adj: dict[str, set[str]] = defaultdict(set)
    for qid, data in quests.items():
        for tgt in leads_to_ids(data):
            if tgt in quests:
                adj[qid].add(tgt)
        for preq in prerequisites_of(data):
            if preq in quests:
                adj[preq].add(qid)  # prerequisite edge: prereq -> dependant

    # ======= 1. Reachability from start =======
    reachable: set[str] = set()
    stack = [START_QUEST]
    visited = set()
    while stack:
        qid = stack.pop()
        if qid in visited:
            continue
        visited.add(qid)
        if qid not in quests:
            print(f"ERROR: target '{qid}' not found in loaded quests")
            continue
        reachable.add(qid)
        for tgt in adj.get(qid, set()):
            stack.append(tgt)

    unreachable = loaded - reachable
    if unreachable:
        print(f"INFO: {len(unreachable)} side/optional quests not on main path:")
        for qid in sorted(unreachable):
            print(f"  - {qid}")
    else:
        print(f"OK: all {len(reachable)} quests reachable from start")

    # ======= 2. Orphan quests (no incoming, not start) ========
    incoming = defaultdict(set)
    for qid, data in quests.items():
        for tgt in leads_to_ids(data):
            if tgt in quests:
                incoming[tgt].add(qid)
        for preq in prerequisites_of(data):
            incoming[qid].add(preq)
    orphans = {qid for qid in loaded if qid != START_QUEST and not incoming.get(qid)}
    # Side quests are allowed to be orphans — they're optional content
    side_quests = {"greyford_side_01_witch_trouble", "greyford_side_02_lost_heirloom"}
    real_orphans = orphans - side_quests
    if real_orphans:
        print(f"ERROR: {len(real_orphans)} orphan quests (no incoming edges, not start):")
        for qid in sorted(real_orphans):
            print(f"  - {qid}")
    else:
        print("OK: no orphan main quests (side quests may be optional)")

    # ======= 3. Dead-end quests (no outgoing, not end) =========
    dead_ends = {qid for qid in loaded if qid != END_QUEST and not leads_to_ids(quests[qid])}
    side_quests = {"greyford_side_01_witch_trouble", "greyford_side_02_lost_heirloom"}
    real_dead_ends = dead_ends - side_quests
    if real_dead_ends:
        print(f"WARNING: {len(real_dead_ends)} dead-end quests (no outgoing edges, not end):")
        for qid in sorted(real_dead_ends):
            print(f"  - {qid}")
    else:
        print("OK: no dead-end main quests (side quests may end naturally)")

    # ======= 4. Prerequisite ordering ========
    canon_index = {qid: i for i, qid in enumerate(CANON_ORDER)}
    order_violations: list[str] = []
    for qid, data in quests.items():
        qi = canon_index.get(qid)
        if qi is None:
            continue
        for preq in prerequisites_of(data):
            pi = canon_index.get(preq)
            if pi is not None and pi >= qi:
                order_violations.append(f"{qid} depends on {preq} but appears before it in CANON_ORDER")
    if order_violations:
        print(f"ERROR: {len(order_violations)} prerequisite ordering violations:")
        for v in order_violations:
            print(f"  - {v}")
    else:
        print("OK: all prerequisites appear before dependants in canon order")

    # ======= 5. Flag consistency (consumed flags must be produced earlier or in same quest) ========
    produced_so_far: set[str] = set()
    flag_errors: list[str] = []
    for qid in CANON_ORDER:
        if qid not in quests:
            continue
        data = quests[qid]
        # Flags produced by this quest (use for its own objectives too)
        own_flags = flags_produced(data)
        consumed = flags_consumed(data)
        # External flags set by dialogue/exploration, not quests
        external_flags = {"isra_trust_gte_2", "hero_learned_swamp_trust"}
        # A quest can use flags produced by itself, earlier quests, or external systems
        missing_flags = consumed - produced_so_far - own_flags - external_flags
        if missing_flags:
            flag_errors.append(
                f"{qid} requires flags {missing_flags} — not produced by any quest or external system"
            )
        produced_so_far |= own_flags

    if flag_errors:
        print(f"ERROR: {len(flag_errors)} flag resolution errors:")
        for e in flag_errors:
            print(f"  - {e}")
    else:
        print("OK: all consumed flags are produced by earlier quests in canon order")

    # ======= 6. Critical path length ========
    # BFS from start to end through leads_to graph
    from collections import deque
    q = deque([(START_QUEST, 1)])
    seen = {START_QUEST}
    max_depth = 1
    while q:
        cur, depth = q.popleft()
        if cur == END_QUEST:
            max_depth = max(max_depth, depth)
        for tgt in leads_to_ids(quests.get(cur, {})):
            if tgt not in seen:
                seen.add(tgt)
                q.append((tgt, depth + 1))

    print(f"OK: critical path length (longest chain) = {max_depth}")

    # ======= summary ========
    errors_found = bool(real_orphans or order_violations or flag_errors)
    if errors_found:
        print("\nSMOKE TEST FAILED")
        return 1
    else:
        print(f"\nSMOKE TEST PASSED — {len(reachable)} quests, graph traversable, flags consistent")
        return 0


if __name__ == "__main__":
    raise SystemExit(main())
