# Slice 02 — Swamp Entry

**Status:** pending  
**Canon:** 04  
**Owned quest:** `hazemoor_01_path_through_swamp`

## Contract / Checkpoint

Leaving Greyford enters a playable SwampPath traversal. The pre-existing `zone_old_tree` seam
used by Slice 01 remains intact; the player receives the correct internal-voice beats for quest
04, completes its traversal contract, and reaches Tykhy Shelest.

## Owner / Seam

`SceneRegistry` owns all swamp aliases, including `zone_old_tree`; quest progression is read
from the canonical quest file by `QuestManager`. Environmental triggers report objective IDs
to that owner; they do not maintain a parallel traversal state. This slice is the single
production owner of `SwampPath` geometry/traversal even though Slice 01 and later slices consume it.

## Player-Visible Surface

`res://scenes/locations/hazemoor/SwampPath.tscn`, including entry, first clearing, and the route
out to Tykhy Shelest.

## Slice Gates

Add/own one focused runtime probe for quest 04. It must instantiate SwampPath, verify the
existing relic/old-tree seam remains intact, exercise traversal triggers in order, assert
objective progression, and assert the next route.

## Slice-Specific Visual Target

The swamp entrance must feel like a deliberate transition from Greyford: readable path
silhouette, strong depth layers, and threatening fog that never hides navigation. Judge path
shape, then environmental props, then fog/lighting in separate crops.

## Non-Goals

No Deep Bog finale work; no unrelated Sonk Ferry scenes; no volumetric-fog dependency in the
Mobile renderer; no Box-ArtAssembly substitute for final Meshy props.

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
