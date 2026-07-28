# Greyford — authoritative reference mapping

**Source:** `D:\артефакти з чату гри` (`/mnt/d/артефакти з чату гри`)

**Audit method:** exact inventory (72 PNG + `files.zip`), perceptual-hash comparison against `visual/concept_art_vision/items/`, deduplication, then pixel-level inspection of all unique non-matching images.

## Findings

- 53/72 timestamp images are duplicate/re-encoded canonical concept-art items.
- The remaining unique images contain maps, floor plans, non-Greyford locations, and four useful Greyford environment sheets.
- A cluster/contact sheet is never a valid Meshy image-to-3D input.
- `files.zip` contains 27 quest/story Markdown files, not visual references.

## Location shortlist

| Location | Primary reference(s) | Role | Palette | Confidence / restriction |
|---|---|---|---|---|
| TavernInterior (Ervan coaching inn) | `1781626195869.png` | Authoritative floor plan: stable, hall, kitchen, hearth, office, guest rooms, Rufin room | parchment layout; rendered target remains warm amber, dark timber, beige plaster | **Strong for layout, not image-to-3D.** Existing `tavern_interior_from_art.glb` remains the production visual baseline. |
| RufinRoom | `1781626195869.png`; canonical `1781159861302.png` / `018_p08_rufin...png`; `1781350025052.png` / `049_p22_portret_rufina.png` | Room placement/layout + character/mood only | cold slate-blue/grey, aged parchment, dark wood, warm desk-lamp accents | **No standalone environment sheet.** Do not send portrait/floor plan directly to image-to-3D. |
| CraftsmenQuarter | `1781848762485.png`; `1781849001456.png` | Eye-level/oblique workshop environment; five-workshop district layout | weathered timber brown, blue-grey stone/roofs, parchment cream, restrained amber forge/window accents | **Primary strong match.** Best environment references in the folder. Use only a single selected image per generation, never a collage. |
| PortTavernInterior | canonical `1781246659826.png` / `033_p16_barmen...png`; `1781246965208.png` / `034_p16_kurtyzanka...png`; Greyford map `1781625667563.png` / `1781625858117.png` | NPC/style references + macro placement only | cold harbor blue-grey/teal exterior; warm smoky amber interior; dark wet timber | **No standalone interior environment sheet.** Do not generate environment from character portraits. |
| GreyfordGate | canonical `1781247333908.png` / `035_p17_serzhant_vorit.png`; Greyford map `1781625667563.png` / `1781625858117.png` | Guard character + gate placement/massing only | grey stone, charcoal iron, muted moss/olive, warm torch accents | **No standalone eye-level gate environment sheet.** Prior classification of `1781247333908` as CraftsmenQuarter was false; perceptual hash proves it is the gate sergeant. |
| GreyfordStreet | Greyford map `1781625667563.png` / `1781625858117.png`; `1781848762485.png`; `1781849001456.png` | Macro street network + strongest available street-level architectural language | wet blue-grey cobble, weathered brown timber, muted olive, sparse amber lamps | **Composite design evidence, not a direct single image-to-3D target.** Reuse modular architecture derived from CraftsmenQuarter. |
| AlteyaHiddenRoom | `1781849979336.png`; `1781159992374.png` | Alteya dwelling exterior + flooded occult chamber mood | near-black/charcoal, desaturated olive, cold grey-blue, acid green wisps, tiny amber candle accents | **Exterior is moderate; chamber is weak due to creature/fog occlusion.** `1781850722066.png` is a flooded chapel, not Alteya's room. Do not mislabel it. |

## Exact corrections to previous classification

- `1781247333908.png` = `035_p17_serzhant_vorit.png` (gate sergeant), not CraftsmenQuarter.
- `1781174617443.png` = `006_p03_maty_mia...png`, not CraftsmenQuarter.
- `1781160804592.png` = `015_p07_loen...png`, not RufinRoom.
- `1781245798435.png` = `032_p15_kushnir...png` (furrier), not RufinRoom.
- `1781626195869.png` is Ervan Tavern floor plan and includes Rufin's room; it is not a perspective environment render.
- `1781848762485.png` and `1781849001456.png` are the only strong direct Greyford environment sheets in the folder.

## Generation policy

1. Reuse existing credible GLB assets first.
2. Never feed contact sheets, maps, floor plans, or character portraits into Meshy image-to-3D.
3. For CraftsmenQuarter, use exactly one of the two primary images and retain the other only as validation/art-direction evidence.
4. For locations without a direct environment sheet, use text-to-3D modular props/kits constrained by the documented palette and layout; do not pretend image-to-3D is reference-grounded.
5. Show the per-location mapping/palette and obtain explicit approval before any new credit spend.
6. Reject primitive BoxMesh/CapsuleMesh as final visible art; collision primitives may remain invisible.
