# Slice 01 — Greyford

**Status:** in progress  
**Canon:** 01–03  
**Owned quests:** `greyford_01_missing_recipient`, `greyford_side_01_witch_trouble`,
`greyford_side_02_lost_heirloom`

## Contract / Checkpoint

The player arrives at the **постоялий двір** (`TavernInterior`, not `PortTavern`), receives and
investigates the missing-recipient lead across Greyford, may complete both side quests, and
reaches a working gate departure. `greyford_side_02` consumes the `zone_old_tree` seam in
SwampPath but does not own or duplicate SwampPath production.

## Owner / Seam

Quest state stays in `QuestManager`; routes stay in `SceneRegistry`; Greyford NPC identity
stays in `npc_registry.json`. Scene-embedded NPCs are valid placements when they are real
interactive `Area3D` nodes with GLB descendants; absence from `npc_placement.json` is an
inventory coverage gap, not permission to duplicate them.

## Player-Visible Surface

Seven routed surfaces: TavernInterior, RufinRoom, CraftsmenQuarter, PortTavernInterior,
GreyfordGate, AlteyaHiddenRoom, and SwampPath. GreyfordStreet remains a connective production
scene and is included in global smoke/screenshots.

## Slice Gates

```bash
# Godot SceneTree scripts, run on Windows host
--script res://tests/test_quest_greyford_01.gd
--script res://tests/test_greyford_01_progression.gd
--script res://tests/test_greyford_side_dialogue_wiring.gd
--script res://tests/test_portals.gd
--script res://tests/smoke_tavern_intro_staging.gd
--script res://tests/smoke_all_scenes.gd
```

Required runtime chain: letter handoff → Ervan → Rufin room → at least two investigation
threads → gate sergeant → route unlocked. Required real speakers: Ervan, Cassandra, gate
sergeant, woodcarver, furrier, Alteya, Varrik.

## Slice-Specific Visual Target

Greyford must read as one coherent city but each interior/quarter remains distinct. Judge:
(a) readable investigation path and architecture silhouette, (b) credible character models at
conversation distance, and (c) moody but navigable lighting. Do not homogenize TavernInterior
and PortTavernInterior. User reference art is authoritative where present.

## Non-Goals

No rewrite of canonical quest JSON that already passes gates; no primitive NPC stand-ins; no
palette change without user direction; no Swamp Entry work beyond the existing `zone_old_tree`
search seam and a functioning exit seam.

## Required Verification

1. Run the slice-specific Godot probes above and capture exit code + error grep.
2. Run all [global gates](../README.md#global-gates-every-slice).
3. Capture deterministic full shots and three focused crop sets: composition/silhouette,
   NPC/model credibility, and lighting/fog/readability. Do not judge multiple visual variables
   from one crop.
4. Run `visual/screenshot-critique` last on current shots. If a target/prior shot exists, run
   `visual/compare-screenshots` too and state which is less wrong against the target.
5. Preview the curated set non-blockingly; after ~5 minutes without feedback, record the
   evidence-based decision and proceed.
6. Record evidence under the slice evidence folder and commit only after every DoD item passes.

## Must Stay Green

- 24/24 canonical quest data and routes.
- Python canon, graph, and simulation gates.
- Global Godot scene smoke with zero errors.
- All earlier slices and their evidence.

## Human Feedback That Changes This Slice

A user correction to canon, location atmosphere, palette, character identity, or reference art
changes the relevant visual/data contract. Update this file and the README handoff before code;
do not preserve the rejected look through a compatibility branch.
