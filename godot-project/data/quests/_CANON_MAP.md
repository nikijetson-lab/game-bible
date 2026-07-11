# Hazemoor Quest Canon Map

Source of truth: all quest JSON files under `data/quests/`, read fully on 2026-07-11.

This file is the production audit base for turning the story into a complete RPG. It separates:
- story canon: what the quest text says must happen;
- data readiness: whether the quest is already engine-readable or still prose/design-only;
- blockers: id/link/schema problems that will break implementation.

## Canon spine

The full RPG spine is coherent and complete as story:

1. Letter for Rufin arrives in Greyford.
2. Rufin is missing; investigation reveals he went toward Tykhy Shelest / Hazemoor carrying something luminous.
3. The swamp trail introduces Muri signs and Ilia whispers.
4. Tykhy Shelest reveals Rufin, Mia, Kaen, and Mia's link to the swamp.
5. Mour manifests at the forbidden glade; the artifact was made from Mour; the symbol on the Greyford letter belongs to the Order of Seven Daggers.
6. Sonk Ferry exposes the human/political cost of frontier survival: grain, medicine, ferries, administrative control.
7. Valkorn reveals the Order, Tessa, Damar, Loen, and finally Sebastian Marr / Fipp as Keeper of the First Seal.
8. Episode 3 returns to Deep Bog after fusion, with the hero decaying and Ilia as a mental anchor.
9. The Second Seal in the Flooded Sanctuary forces three world-ending/world-saving verdicts.
10. Episode 4 resolves the three paths: Iron, Reed, Balance.

The story is a finished four-episode RPG outline, not a demo-only premise.

## Critical blockers found

### 1. Resolved: duplicate/deprecated Ep3 files archived

The active `data/quests/*.json` set now has 24 files and 24 unique quest ids.

Archived under `data/quests/_deprecated/`:

- `deep_bog_03_flooded_sanctuary_updated.json` — short placeholder with duplicate id.
- `deep_bog_03_flooded_abbey.json` — earlier/shorter Ep3 finale.

Canonical Ep3 finale is `deep_bog_03_flooded_sanctuary.json` because it contains the A_iron / B_reed / V_balance verdicts used by Ep4. `deep_bog_02_mad_ferry.json` now leads directly to `deep_bog_03_flooded_sanctuary`.

### 2. Resolved: Sonk Ferry filename mismatch

`data/quests/sunk_ferry_01_hunger_from_below.json` was renamed to `data/quests/sonk_ferry_01_hunger_from_below.json`. Its internal id already was `sonk_ferry_01_hunger_from_below`.

### 3. Resolved: alias links replaced with canonical quest ids

The quest JSON files now use canonical ids directly in `leads_to`, `canon_previous`, and `prerequisites.quests_completed`. The alias table below remains documented for historical reference and as a validator safety net. Both default and `--strict` validator modes pass.

Historical alias table:

| Alias used in JSON | Canonical quest id |
|---|---|
| `nizh_kvoty` | `sonk_ferry_04_quota_knife` |
| `poromna_prysyaga` | `sonk_ferry_03_ferry_oath` |
| `popil_pid_kaplytseyu` | `hazemoor_02_ashes_under_chapel` |
| `ep2_valkorn` | `valkorn_01_man_from_swamp` |
| `valkorn_dvi_versii_pravdy` | `valkorn_02_two_truths` |
| `valkorn_pravylna_tsina` | `valkorn_03_right_price` |
| `valkorn_poslanets_rufina` | `valkorn_04_messenger_of_rufin` |
| `valkorn_khranitel_pershoyi_pechatky` | `valkorn_05_keeper_of_first_seal` |
| `valkorn_05_lantern_path` | `valkorn_05_keeper_of_first_seal` |
| `ep3` | `deep_bog_01_voice_from_fog` |
| `ep4` | `ep4_01_return_to_valkorn` |

### 4. Mixed schemas

Six quests are currently structured/engine-ready with a top-level `objectives[]` list:

- `greyford_01_missing_recipient`
- `greyford_side_01_witch_trouble`
- `greyford_side_02_lost_heirloom`
- `hazemoor_01_path_through_swamp`
- `tykhy_shelest_01`
- `sonk_ferry_01_hunger_from_below`

Everything else is prose/design structure (`threads`, `phases`, `acts`, `branches`, custom fields). Those quests need conversion into machine-readable objectives, triggers, conditions, and resolutions before they can be fully playable.

## Canon quest order and production status

Legend:

- Schema:
  - `structured` = already has objective objects usable by a QuestManager.
  - `prose:*` = story/design text that still needs objective conversion.
- Combat:
  - yes = quest text explicitly requires combat/enemy encounter or combat branch.
- Timer:
  - yes = quest text requires day counter, disturbance counter, tribunal pressure, or equivalent state machine.
- Systems:
  - UI = needs quest journal/dialogue choice UI.
  - REP = reputation/faction consequences.
  - INV = items/rewards/inventory integration.
  - COMBAT = enemy/health/player-combat integration.
  - CUT = cutscene/cinematic staging.
  - VO = strong candidate for voiced scenes.

| # | Quest id | Ep | Title | Schema | Canon role | Combat | Timer | Required systems | Production work |
|---:|---|---:|---|---|---|---|---|---|---|
| 1 | `greyford_01_missing_recipient` | 1 | Адресат відсутній | structured | Main opening investigation; letter/Rufin/Order-symbol seed | no | no | UI, REP, INV, VO | Already best-structured. Needs runtime objective checks, locations/NPC wiring, quest journal entries, clue UI. |
| 2 | `greyford_side_01_witch_trouble` | 1 | Проблема з відьмою | structured | Alteya, prejudice, swamp-magic politics | no | no | UI, REP, INV, VO | Needs witness NPCs/evidence objects/verdict UI and relationship consequences. |
| 3 | `greyford_side_02_lost_heirloom` | 1 | Загублена реліквія | structured | Varrik honor test; medallion moral choice | light/possible | no | UI, REP, INV | Needs swamp-edge search zones, medallion item, return/sell/keep branches. |
| 4 | `hazemoor_01_path_through_swamp` | 1 | Шлях крізь болото | structured | First swamp traversal, Muri signs, Ilia whisper | possible | no | UI, INV, COMBAT, VO | Needs path waypoints, hazards/traps/enemies, Muri symbol collectibles, whisper trigger. |
| 5 | `tykhy_shelest_01` | 1 | Тихий Шелест | structured | Muri settlement; Rufin/Mia/Kaen truth; one-shot location | no | no | UI, REP, INV, CUT, VO | Converted to 13 top-level objectives with thread grouping preserved. Needs runtime wiring: one-shot lockout, Mia scripted decision, route_to_sonk_ferry. |
| 6 | `sonk_ferry_01_hunger_from_below` | 1 | Голод знизу | structured | Grain convoy, corruption, dead Pact, flooded chamber | yes | no | UI, REP, COMBAT, INV, CUT, VO | Converted to 10 top-level objectives + resolution choice A/B/C/D (canonical=C). Needs runtime wiring: investigation pool, reed_wraiths encounter, faction shift hooks. |
| 7 | `sonk_ferry_02_salt_in_book` | 1 | Сіль у книзі | prose:phases | Medicine sabotage and aid-network compromise | no | no | UI, REP, CUT, VO | Convert forensics chain and warehouse confrontation; prerequisite currently requires only outcome C from quest 6. Need alternate paths or confirm lock. |
| 8 | `sonk_ferry_03_ferry_oath` | 1 | Поромна присяга | prose:phases | Ferry murder, Tovan/Nera/Kelm political control | no | yes | UI, REP, CUT, VO | Implement evidence counter 0-5, Kelm day timer, night council, four political resolutions. |
| 9 | `hazemoor_02_ashes_under_chapel` | 1 | Попіл під каплицею | prose:phases | Flooded chapel body, reversed ash sign, ritual disturbance | no | yes | UI, REP, CUT, VO | Implement Rein 3-day timer, disturbance 0-5, archive trust, ritual prep bonuses and four resolutions. |
| 10 | `sonk_ferry_04_quota_knife` | 1 | Ніж квоти | prose | Administrative tribunal and route to Valkorn | no | pressure formula | UI, REP, CUT, VO | Implement evidence/counter-evidence collection, tribunal formula, transit branch to Valkorn. |
| 11 | `hazemoor_02_glade_and_mour` | 1 | Галявина і дух | prose:phases | Mour manifestation, Mia revelation, Order-symbol reveal, mount | no | no | UI, INV, CUT, VO | Major cinematic quest. Needs Mour manifestation, underwater vision, Mia state, mount unlock, artifact item. |
| 12 | `valkorn_01_man_from_swamp` | 2 | Людина з болота | prose:threads | Arrival with Ilia; Fipp market encounter; Stetson/Bres/Tessa threads | no | no | UI, REP, CUT, VO | Convert 3 threads, min_threads=2, opening scene with Fipp. Needs Valkorn locations/NPCs. |
| 13 | `valkorn_02_two_truths` | 2 | Дві версії правди | prose:threads | Odrin vs Tessa; undercity; artifact stolen by Damar | no | no | UI, REP, CUT, VO | Convert two information paths and crossroads; implement undercity findings. |
| 14 | `valkorn_03_right_price` | 2 | Правильна ціна | prose:phases | Trade guild warehouse; Damar sells artifact | no | no | UI, REP, INV, CUT, VO | Convert recon/approach/negotiation; implement Tessa interrupt and four artifact outcomes. |
| 15 | `valkorn_04_messenger_of_rufin` | 2 | Людина, що послала Руфіна | prose | Loen meeting; Order plan; clue points to Fipp/Sebastian | no | no | UI, REP, CUT, VO | Convert dialogue choice/alignment; update Order/Stetson/Ilia relationship consequences. |
| 16 | `valkorn_05_keeper_of_first_seal` | 2 | Хранитель Першої Печатки | prose | Sebastian reveal, First Seal, Ilia shock, Ep2 finale | yes | no | UI, REP, COMBAT, INV, CUT, VO | Major finale. Needs infiltration paths, black archive, boss/elite combat or treaty/fusion alternatives. |
| 17 | `deep_bog_01_voice_from_fog` | 3 | Голос із туману | prose:acts | Hero decaying after fusion; Ilia as mental anchor; fog/sanity | no | sanity drain | UI, COMBAT, CUT, VO | Convert sanity/fog/no-minimap mechanics; implement Bolo-Weaving root obstacle with stamina/pain. |
| 18 | `deep_bog_02_mad_ferry` | 3 | Шалений пором | prose | Lileya, Second Seal reveal, Mad River obstacle | no | no | UI, CUT, VO | Convert Lileya scene and river/ferry obstacle. Needs stone tower / chain ferry content. |
| 19 | `deep_bog_03_flooded_sanctuary` | 3 | Затоплена Обитель | prose | Second Seal finale; Mia vs Lileya; Iron/Reed/Balance verdicts | no | no | UI, REP, INV, CUT, VO | Canon Ep3 finale. Needs three irreversible world-state branches feeding all Ep4 files. |
| 20 | `ep4_01_return_to_valkorn` | 4 | Повернення до Валькорна | prose:branches | Branch-specific return after Ep3 verdict | no | no | UI, REP, INV, CUT, VO | Currently synopsis only. Needs full quest objectives per branch. |
| 21 | `ep4_02_valkorn_climax` | 4 | Кульмінація у Валькорні | prose:branches | Valkorn climax per branch | yes in A/B | no | UI, REP, COMBAT, CUT, VO | Currently synopsis only. Needs combat/diplomacy objectives and branch scenes. |
| 22 | `ep4_03_hazemoor_mour_heart` | 4 | Хейзмур та Серце Моура | prose:branches | Final Mour/Mia/heart ritual | no | no | UI, REP, CUT, VO | Currently synopsis only. Needs full endgame quest design. |
| 23 | `ep4_04_final_resolution` | 4 | Велика Розв'язка | prose:branches | World/faction resolution | no | no | UI, REP, CUT, VO | Currently synopsis only. Needs epilogue state application. |
| 24 | `ep4_05_hero_departure` | 4 | Відхід Героя | prose:branches | Final departure and credits | no | no | CUT, VO | Currently only ending visual text. Needs final cinematic/credits. |

## Quests intentionally not in canonical playable order

| Quest id | File | Status | Reason |
|---|---|---|---|
| `deep_bog_03_flooded_abbey` | `data/quests/_deprecated/deep_bog_03_flooded_abbey.json` | archived | Earlier/shorter Ep3 finale. Does not contain the three verdicts that Ep4 uses. Merge manually only if needed. |
| `deep_bog_03_flooded_sanctuary` duplicate | `data/quests/_deprecated/deep_bog_03_flooded_sanctuary_updated.json` | archived | Placeholder with duplicate id. Kept only for historical reference. |

## Required system backlog derived from quest text

### Quest/data infrastructure

1. Add canonical id validation to CI/local smoke checks.
2. Resolve aliases or replace all alias `leads_to` values with canonical ids.
3. Remove duplicate ids.
4. Convert all prose quests into a common objective schema:
   - objectives;
   - triggers;
   - conditions;
   - resolution branches;
   - world-state flags;
   - rewards;
   - required locations/NPCs/items.
5. Add graph validation: every prerequisite and leads_to must resolve.
6. Add branch validation: every branch flag used later must be produced earlier.

### RPG systems explicitly required by quests

- Quest journal UI.
- Dialogue choice UI.
- Evidence/clue UI.
- Inventory and quest item UI.
- Reputation/faction screen.
- Timers / day counters:
  - `rein_timer`;
  - `kelm_timer`;
  - disturbance counter;
  - tribunal pressure formula.
- Doctrine/build system:
  - judge;
  - lantern;
  - mediator;
  - ranger/scout/tracker naming must be unified.
- Combat:
  - reed wraiths;
  - Order elite mercenaries;
  - player attack/dodge/stamina/block decisions;
  - enemy AI and encounter staging.
- Bolo-Weaving skill branch:
  - swamp emanation manipulation;
  - stamina/pain cost;
  - branch locked/unlocked by finale choices.
- Cutscene system:
  - Fipp/Sebastian reveal;
  - Mour manifestation;
  - Mia revelation;
  - Ep3 verdict;
  - Ep4 endings.
- Voice/audio pipeline:
  - Ilia mental voice;
  - Mia revelation;
  - Sebastian reveal;
  - Mour manifestation;
  - major tribunals/verdicts/endings.

## Immediate implementation order

1. Keep `tools/validate_quest_canon.py . --strict` green.
2. Continue prose conversion in canon order (`sonk_ferry_02_salt_in_book` next).
4. Add quest graph smoke test to regular project checks.
5. Only then continue building gameplay/UI/content, otherwise content will keep drifting.
