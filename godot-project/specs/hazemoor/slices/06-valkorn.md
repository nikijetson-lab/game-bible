# Slice 06 — Valkorn

**Status:** pending  
**Canon:** 12–16  
**Owned quests:** `valkorn_01_man_from_swamp`, `valkorn_02_two_truths`,
`valkorn_03_right_price`, `valkorn_04_messenger_of_rufin`,
`valkorn_05_keeper_of_first_seal`

## Contract / Checkpoint

The player completes the five-quest city arc (39 objectives), navigates its political branches,
reaches Black Archive/Undercity, and unlocks Deep Bog.

## Owner / Seam

Valkorn route aliases remain in `SceneRegistry`; quest choices remain in `QuestManager` and
reputation systems. PortQuarter is a shared scene, not permission to collapse every logical
quarter into visually identical staging.

## Player-Visible Surface

`PortQuarter.tscn`, `BlackArchive.tscn`, `Undercity.tscn`; real cast includes Tessa, Stetson,
Bres, Loen, Odrin, Ilia Marr, Damar, Fipp and relevant quest speakers.

## Slice Gates

Add focused runtime probes for quests 12–16 and use `tests/render_archive.gd` plus a deterministic
PortQuarter/Undercity capture. Assert every logical quarter route arrives at intentional staging.

## Slice-Specific Visual Target

Valkorn is a layered frontier city: port economy, elite/diplomatic pressure, archive secrecy,
and undercity danger. Judge quarter readability, architecture silhouette, NPC credibility, and
lighting in separate crops. Shared scene geometry must still give logical quarters distinct cues.

## Non-Goals

No Deep Bog content except an exit seam; no primitive city crowds; no parallel quarter-route map.

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
