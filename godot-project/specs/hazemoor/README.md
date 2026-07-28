# Hazemoor Production Plan

> Human plan over the generated inventory in `data/content_manifest.json`.
> Never hand-edit the manifest. Regenerate it with `tools/generate_content_manifest.py`.

## Next Agent Prompt

**Status (2026-07-28):** baseline and generated production manifest are complete. The
canonical slice graph is materialized below. **Pick up at Slice 01 — Greyford**, beginning
with its existing Godot quest/portal/staging gates, then close the concrete failures they
reveal. Do not start Slice 02 until Slice 01 meets every functional, model, and visual gate.

**Warnings:**

- `production_acceptance: unverified` means inventory exists, not that the content is shippable.
- Five logical talk targets are unresolved in the generated inventory; they are owned by
  Slices 05, not to be silently mapped to invented NPCs.
- Full-tree Git on `/mnt/e` is slow. Use path-scoped commands with hard timeouts.
- Do not clear `.godot/` unless a stale parse/import error is proven.
- Update this handoff, slice status, and evidence paths before ending every pass.

### Global TODO

- [ ] [Slice 01 — Greyford](slices/01-greyford.md)
- [ ] [Slice 02 — Swamp Entry](slices/02-swamp-entry.md)
- [ ] [Slice 03 — Tykhy Shelest](slices/03-tykhy-shelest.md)
- [ ] [Slice 04 — Sonk Ferry I](slices/04-sonk-ferry-i.md)
- [ ] [Slice 05 — Crossroads](slices/05-crossroads.md)
- [ ] [Slice 06 — Valkorn](slices/06-valkorn.md)
- [ ] [Slice 07 — Deep Bog](slices/07-deep-bog.md)
- [ ] [Slice 08 — Finale](slices/08-finale.md)

## Goal

Ship all 24 canonical quests as one playable Godot 4.7 RPG. Work in contiguous canon
checkpoints, not region buckets that reorder the story. A slice is complete only when the
player-facing result is playable and visually accepted; green JSON alone is insufficient.

## Canonical Slice Graph

| Slice | Canon | Quests | Checkpoint |
|---|---:|---|---|
| 01 Greyford | 01–03 | `greyford_01`, two Greyford side quests | Leave Greyford for the swamp |
| 02 Swamp Entry | 04 | `hazemoor_01_path_through_swamp` | Cross SwampPath, reach Tykhy Shelest |
| 03 Tykhy Shelest | 05 | `tykhy_shelest_01` | Unlock route toward Sonk Ferry |
| 04 Sonk Ferry I | 06–08 | hunger, salt, ferry oath | Resolve first Sonk arc |
| 05 Crossroads | 09–11 | ashes, quota knife, glade/Mour | Reach Valkorn with branches intact |
| 06 Valkorn | 12–16 | five Valkorn quests | Enter Deep Bog arc |
| 07 Deep Bog | 17–19 | voice, mad ferry, sanctuary | Reach Ep4 return |
| 08 Finale | 20–24 | five finale quests | Return to main menu/epilogue |

> **Ownership note (adversarial audit, 2026-07-28):** quest ownership follows the canonical
> checkpoints above. `greyford_side_02_lost_heirloom` remains in Slice 01, although its
> `zone_old_tree` target consumes `SwampPath.tscn` through a shared seam. Slice 02 is the sole
> production owner of SwampPath geometry/traversal; Slice 01 may only consume the relic-search
> seam and cannot fork or duplicate that scene. Slices 04 (43 objectives) and 06 (39 objectives)
> are broad execution blocks, so their contracts require intermediate internal gates without
> changing the canonical checkpoint graph.

## Single Owners / Firewalls

| Concept | Sole owner | Rule |
|---|---|---|
| Quest canon/data | `data/quests/*.json` | Do not duplicate quest state in spec or scenes |
| Location→scene route | `scripts/core/scene_registry.gd` | No local route maps in quest scripts |
| Production inventory | `data/content_manifest.json` generator | Generated facts only; no manual green statuses |
| NPC/dialogue index | `data/npcs/npc_registry.json` | Aliases must resolve explicitly, never by invented fallback |
| NPC placement | `data/npcs/npc_placement.json` | Scene-local placement copies are migration debt |
| Runtime quest state | `QuestManager` autoload | Tests consume its state; do not re-derive a parallel state machine |
| Visual acceptance | slice evidence + screenshot critique | A compile pass cannot set visual acceptance |

Any temporary bridge must name the owning slice and be removed in that same slice once its
consumers migrate. No compatibility layer may survive into Slice 08 by default.

## Global Gates (every slice)

```bash
python3 tools/generate_content_manifest.py
python3 tools/validate_quest_canon.py . --strict
python3 tools/test_quest_graph.py .
python3 tools/simulate_playthrough.py
# Windows host Godot, from WSL:
powershell.exe -NoProfile -Command "& godot --path 'E:\Hazemoor\game-bible\godot-project' --headless --script 'res://tests/smoke_all_scenes.gd'"
```

Required verdict: 24 data-ready, 24 route-ready, zero missing routes; all canonical Python
gates pass; Godot exits 0 with zero `SCRIPT ERROR`, `Parse Error`, `Compile Error`, or
`ERROR:` lines.

## Definition of Done (every slice)

1. **Data/route:** every owned quest is ready in the manifest, and all scene paths exist.
2. **Runtime:** the owned quest chain starts, advances, branches, completes, and unlocks its
   next canon checkpoint in actual Godot runtime.
3. **NPC:** required speakers have dialogue, placement, and credible GLB models. Capsules,
   cubes, mannequins, or hidden primitives do not pass.
4. **Scene:** every owned scene loads, instantiates into the tree, reaches `_ready()`, and has
   working portals/interactions.
5. **Visual:** deterministic current screenshots are captured. Judge one variable per crop:
   (a) composition/silhouette, (b) NPC/model credibility, (c) lighting/fog/readability.
6. **Fresh eyes:** run `visual/screenshot-critique` on the full shot plus tight crops. If a
   prior/reference image exists, also run `visual/compare-screenshots`; accept the candidate
   only if it is less wrong against the stated target, not merely different.
7. **Human checkpoint:** preview the smallest useful shot set non-blockingly. If no response
   arrives in ~5 minutes, decide from evidence, record rationale, close previews, continue.
8. **Evidence/commit:** record commands, exit codes, screenshot paths, critique verdicts, and
   commit path-scoped changes with the regenerated manifest.

## Open Production Targets

Owned by [Slice 05](slices/05-crossroads.md):

| Quest | Target | Required resolution |
|---|---|---|
| `hazemoor_02_ashes_under_chapel` | `mirefold_locals` | real crowd NPC or objective reclassification |
| `hazemoor_02_glade_and_mour` | `mour` | dedicated entity/encounter contract |
| `sonk_ferry_04_quota_knife` | `kelm_provoke` | action on real `kelm`, not a fake NPC |
| `sonk_ferry_04_quota_knife` | `smugglers` | real crowd NPC or objective reclassification |
| `sonk_ferry_04_quota_knife` | `temple_witness` | named witness NPC or objective reclassification |

## Evidence Convention

Store review evidence under `specs/hazemoor/evidence/<slice>/` (full screenshots, crops,
comparison reports, and a short `verdict.md`). Active product screenshot baselines may remain
in their harness directories, but mutable external files are never the only acceptance record.
