# Slice 08 — Finale

**Status:** pending  
**Canon:** 20–24  
**Owned quests:** `ep4_01_return_to_valkorn`, `ep4_02_valkorn_climax`,
`ep4_03_hazemoor_mour_heart`, `ep4_04_final_resolution`, `ep4_05_hero_departure`

## Contract / Checkpoint

The player returns to Valkorn, reaches Mour's heart, resolves the final choice, sees the correct
epilogue/departure state, and returns to the main menu without losing save/reputation outcomes.
All five finale quests and every supported ending are runtime-verifiable.

## Owner / Seam

Final quest state remains in `QuestManager`; ending consequences consume reputation/save owners.
The main menu is only the terminal route, not the owner of ending logic.

## Player-Visible Surface

`PortQuarter.tscn`, `SwampPath.tscn`/Mour-heart staging, finale/cutscene surfaces, and
`main_menu.tscn` terminal route.

## Slice Gates

Add focused runtime probes for quests 20–24 and every ending branch. Verify save/load immediately
before the climax and after resolution, then run full game simulation plus all scene smoke.

## Slice-Specific Visual Target

The climax must visually exceed earlier locations while preserving readability: decisive Mour-
heart silhouette, clear choice staging, and legible epilogue. Judge climax composition, character/
entity credibility, effects/lighting, and epilogue UI separately.

## Non-Goals

No credits-only substitute for ending state; no forced single branch; no main-menu redirect used
to conceal an incomplete climax.

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
