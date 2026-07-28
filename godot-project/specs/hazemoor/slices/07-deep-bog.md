# Slice 07 — Deep Bog

**Status:** pending  
**Canon:** 17–19  
**Owned quests:** `deep_bog_01_voice_from_fog`, `deep_bog_02_mad_ferry`,
`deep_bog_03_flooded_sanctuary`

## Contract / Checkpoint

The player traverses Deep Bog, resolves the mad ferry and flooded sanctuary, completes all 14
objectives, and unlocks the Ep4 return to Valkorn.

## Owner / Seam

DeepBog/MadFerry/FloodedAbbey own environment and interactions; quest and seal state stays in
existing autoloads. Environmental mystery does not justify hidden scene-local progression flags.

## Player-Visible Surface

`DeepBog.tscn`, `MadFerry.tscn`, `FloodedAbbey.tscn`, with the Tykhy route seam used by canon.

## Slice Gates

Add focused runtime probes for quests 17–19. Capture deterministic DeepBog, ferry, and abbey
shots; assert ferry transition, sanctuary completion, and next quest unlock in Godot.

## Slice-Specific Visual Target

Deep Bog is more dangerous and ancient than Swamp Entry: oppressive depth, readable ferry
silhouette, and submerged-sacred architecture. Judge navigation silhouette, ferry/prop quality,
abbey architecture, then fog/lighting separately.

## Non-Goals

No finale state machine; no flat darkness used to hide missing detail; no primitive ferry/NPC.

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
