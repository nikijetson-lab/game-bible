# Slice 05 — Crossroads (Ashes / Quota / Glade)

**Status:** pending  
**Canon:** 09–11  
**Owned quests:** `hazemoor_02_ashes_under_chapel`, `sonk_ferry_04_quota_knife`,
`hazemoor_02_glade_and_mour`

## Contract / Checkpoint

The interleaved canon sequence 09→10→11 remains playable across Flooded Chapel, Sonk Ferry,
and Forbidden Glade, resolves all branch evidence, stages Mour as a real encounter, and unlocks
Valkorn.

## Owner / Seam

This slice owns resolution of all five open production targets surfaced by the manifest:
`mirefold_locals`, `mour`, `kelm_provoke`, `smugglers`, `temple_witness`. Each becomes either an
explicit existing/real NPC/entity contract or a non-talk objective type in canonical quest data.
No fuzzy alias may hide the gap.

## Player-Visible Surface

`FloodedChapel.tscn`, `SonkFerry.tscn`, `ForbiddenGlade.tscn` plus the branch transitions among
them.

## Slice Gates

Add focused runtime probes for quests 09–11. Regenerated manifest must report zero unresolved
required talk targets for these quests, and simulation must cover every branch.

## Slice-Specific Visual Target

Three distinct moods: drowned sacred ruin, coercive ferry-town politics, and forbidden glade
supernatural encounter. Judge each scene independently; do not apply one palette/template to all
three. Mour must have a deliberate entity silhouette, not a placeholder humanoid.

## Non-Goals

No silent aliasing of crowd roles; no generic chapel/forest reskin; no Valkorn scene work beyond
the exit seam.

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
