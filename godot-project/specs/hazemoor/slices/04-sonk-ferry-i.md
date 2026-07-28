# Slice 04 — Sonk Ferry I

**Status:** pending  
**Canon:** 06–08  
**Owned quests:** `sonk_ferry_01_hunger_from_below`, `sonk_ferry_02_salt_in_book`,
`sonk_ferry_03_ferry_oath`

## Contract / Checkpoint

The player enters the ferry town, resolves the hunger/salt/ferry-oath arc through its branches,
and exits with quest 09 unlocked. All 32 objectives are runtime-reachable.

## Owner / Seam

`QuestManager` owns branch state; SonkFerry/FloodedChamber/SaltWarehouse expose interactions.
NPC placements consume registry data; no scene-specific alternate NPC database.

## Player-Visible Surface

`SonkFerry.tscn`, `FloodedChamber.tscn`, `SaltWarehouse.tscn`; required NPC cast includes Nera,
Voss, Kelm, Brin Oss, Mara Dens, Gara Paik, Tovan Rid, Karos, and Skel Ganis where canon routes.

## Slice Gates

Add focused runtime probes for quests 06–08 and use `tests/render_sonk.gd` for deterministic
visual evidence. Verify all branch endings in simulation and actual Godot state.

## Slice-Specific Visual Target

Sonk Ferry must read as a ferry town, distinct from Tykhy Shelest: working docks, salt economy,
and administrative/military pressure. Judge town silhouette, prop/economy storytelling, NPC
credibility, then weather/lighting separately.

## Non-Goals

Quest 10's unresolved target cleanup belongs to Slice 05; no Valkorn work; no reuse of Tykhy
stilt-village composition as a template.

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
