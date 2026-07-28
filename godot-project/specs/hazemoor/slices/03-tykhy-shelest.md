# Slice 03 — Tykhy Shelest

**Status:** pending  
**Canon:** 05  
**Owned quest:** `tykhy_shelest_01`

## Contract / Checkpoint

The player reaches Тихий Шелест — a village on stilts over water — completes all 13 objectives,
meets its real inhabitants, and unlocks the route toward Sonk Ferry/Forbidden Glade as canon
requires.

## Owner / Seam

Tykhy scene composition owns village staging; NPC identity/dialogue remains in the registry and
placement data. Do not duplicate Varrik/Kaen/Mia/Sirra identity inside art assembly scripts.

## Player-Visible Surface

`TykhyShelist.tscn` and `ForbiddenGlade.tscn`. Existing Meshy stilt hut, walkway, boat, and
character GLBs are candidates, not automatically accepted assets.

## Slice Gates

Use/add a quest-05 runtime probe plus `tests/render_tykhy.gd`, `render_tykhy_close.gd`, and
`render_tykhy_iso.gd` for deterministic evidence. Assert every required speaker and route.

## Slice-Specific Visual Target

The settlement must unmistakably be a lived-in stilt village over water, never a generic room
or dry-ground village. Judge (1) water/stilt silhouette, (2) hut/walkway/boat material and scale,
(3) character credibility, and (4) fog/lighting readability separately.

## Non-Goals

No primitive villagers; no redesign into a generic swamp camp; no merging Sonk Ferry's ferry-
town identity into this village.

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
