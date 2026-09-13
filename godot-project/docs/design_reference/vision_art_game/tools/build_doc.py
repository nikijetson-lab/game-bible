#!/usr/bin/env python3
"""Generate the Hazemoor entity -> Meshy reference design document."""
from __future__ import annotations

import json
from pathlib import Path

REPO = Path("/mnt/e/Hazemoor/game-bible/godot-project")
BASE = REPO / "docs" / "design_reference" / "vision_art_game"
MANIFEST = BASE / "manifest.json"
DOC = BASE / "README.md"

# Per-concept authored data keyed by manifest id.
# type: creature | npc | location | scene
# hp: optional string
# prompt: English Meshy prompt (characters => full body, T-pose; envs => environment)
ENT = {
    1:  ("creature", "30 HP", "reed crawler creature, low-slung quadruped ambush predator, elongated scaled lizard body, mottled swamp-green and brown camouflage hide, spiny reed-like dorsal frills, wide flat clawed feet, hungry eyes, dark fantasy bestiary, full body, T-pose, game-ready, PBR"),
    2:  ("creature", "25 HP", "swarm of mist bloodsucker insects forming a single cohesive cloud entity, dark fantasy, translucent grey mosquito-like creatures with faint red glow, wispy fog body, game-ready, PBR, floating"),
    3:  ("creature", "45 HP", "rotting drowned undead humanoid, bloated waterlogged corpse, tattered soaked rags, grey-green decayed flesh, dripping bog water and weeds, hollow eyes, dark fantasy, full body, T-pose, game-ready, PBR"),
    4:  ("creature", "50-55 HP", "murok bog-dweller amphibian humanoid, hunched aquatic ambusher, slick dark-green mottled skin, webbed clawed hands, gilled neck, sharp teeth, wet swamp sheen, dark fantasy, full body, T-pose, game-ready, PBR"),
    5:  ("creature", "90 HP", "adult murok altar guardian, large powerful amphibian humanoid warrior, muscular dark-green scaled body, bony ridged crest, primitive bone armor, webbed clawed hands, imposing stance, dark fantasy boss, full body, T-pose, game-ready, PBR"),
    6:  ("npc", None, "middle-aged mysterious woman, guarded knowing expression, layered muted robes and shawl, weathered face, dark fantasy villager, full body, T-pose, game-ready, PBR"),
    7:  ("npc", None, "male tavern keeper, sturdy middle-aged innkeeper, apron over simple tunic, rolled sleeves, friendly weathered face, dark fantasy, full body, T-pose, game-ready, PBR"),
    8:  ("npc", None, "young female hunter of the Muri, lean agile woman, leather hunting garb, hood, bow and quiver, alert youthful face, dark fantasy, full body, T-pose, game-ready, PBR"),
    9:  ("npc", None, "senior male hunter of the Muri, rugged veteran, layered leather and fur, scarred face, hunting spear, stern experienced look, dark fantasy, full body, T-pose, game-ready, PBR"),
    10: ("npc", None, "royal investigator, sharp authoritative man in dark formal coat, badge of office, cold analytical face, gloved hands, dark fantasy, full body, T-pose, game-ready, PBR"),
    11: ("npc", None, "ghetto guide, wiry streetwise man, worn patched clothes, hood, cautious darting eyes, dark fantasy slum dweller, full body, T-pose, game-ready, PBR"),
    12: ("npc", None, "palace archivist, elderly scholarly man, long robe, spectacles, ink-stained fingers, stack of scrolls, refined face, dark fantasy, full body, T-pose, game-ready, PBR"),
    13: ("npc", None, "merchant quarter woman, well-dressed confident trader, fine layered merchant garb, jewelry, shrewd smile, dark fantasy, full body, T-pose, game-ready, PBR"),
    14: ("npc", None, "shady dealer man, nervous well-dressed rogue, dark coat, cornered guilty expression, dockside crates behind, dark fantasy, full body, T-pose, game-ready, PBR"),
    15: ("npc", None, "messenger of the Order, formal courier in dark ceremonial garb, order insignia, scroll case, composed face, dark fantasy, full body, T-pose, game-ready, PBR"),
    18: ("npc", None, "man who returned empty, hollow-eyed haunted figure, plain muted clothing, vacant lost expression, pale gaunt face, dark fantasy, full body, T-pose, game-ready, PBR"),
    19: ("npc", None, "administrative investigator, precise bureaucratic man, dark tailored uniform, ledger, humorless face, dark fantasy, full body, T-pose, game-ready, PBR"),
    20: ("npc", None, "Order of Seven Daggers leader in jester disguise, sinister figure blending noble robes with tattered motley, pale painted face, hidden daggers, unsettling smile, dark fantasy, full body, T-pose, game-ready, PBR"),
    21: ("npc", None, "female Watcher-Kurat, disciplined armored sentinel woman, dark plate and mail, order tabard, stern vigilant face, dark fantasy, full body, T-pose, game-ready, PBR"),
    22: ("npc", None, "last of the Keepers, mystical woman, flowing ceremonial keeper robes, arcane key pendant, serene sorrowful face, dark fantasy, full body, T-pose, game-ready, PBR"),
    23: ("npc", None, "shaman of the Silent Whisper village, tribal mystic, layered hides feathers and bone charms, painted face, staff, wise intense eyes, dark fantasy, full body, T-pose, game-ready, PBR"),
    24: ("npc", None, "smuggler captain woman, bold seafaring rogue, weathered coat, tricorn hat, cutlass, confident smirk, dark fantasy, full body, T-pose, game-ready, PBR"),
    25: ("npc", None, "brother keeper of Holy Vey, devout monk, plain hooded habit, holy symbol, calm faithful face, dark fantasy, full body, T-pose, game-ready, PBR"),
    26: ("npc", None, "clan speaker, dignified elder man, ceremonial clan garb, staff of office, proud measured face, dark fantasy, full body, T-pose, game-ready, PBR"),
    27: ("npc", None, "self-taught healer woman, practical caring figure, apron with pouches of herbs, rolled sleeves, tired kind face, dark fantasy, full body, T-pose, game-ready, PBR"),
    28: ("npc", None, "logistics broker, calculating businessman, neat merchant coat, tally ledger, appraising expression, dark fantasy, full body, T-pose, game-ready, PBR"),
    29: ("npc", None, "corrupt quartermaster official, portly self-satisfied man, ornate uniform stretched over belly, coin purse, greedy smug face, dark fantasy, full body, T-pose, game-ready, PBR"),
    30: ("npc", None, "young female witness, frightened teenage girl, simple commoner dress, clutching shawl, wide anxious eyes, dark fantasy, full body, T-pose, game-ready, PBR"),
    31: ("npc", None, "woodcarver from the artisan quarter, focused craftsman, leather apron, wood shavings, carving tools, calloused hands, dark fantasy, full body, T-pose, game-ready, PBR"),
    32: ("npc", None, "furrier who knows everyone, gossipy shopkeeper, fur-lined coat, warm sly face, dark fantasy, full body, T-pose, game-ready, PBR"),
    33: ("npc", None, "port tavern bartender, burly rough man, stained apron, rolled sleeves, tankard, gruff face, dark fantasy, full body, T-pose, game-ready, PBR"),
    34: ("npc", None, "courtesan, elegant alluring woman, fine revealing period gown, jewelry, poised melancholy face, dark fantasy, full body, T-pose, game-ready, PBR"),
    35: ("npc", None, "gate sergeant, disciplined city guard, dark plate armor over uniform, helmet under arm, halberd, stern duty-bound face, dark fantasy, full body, T-pose, game-ready, PBR"),
    36: ("npc", None, "old woman from Mirefold, wizened village elder, worn shawl and layered peasant clothes, cane, deeply lined weathered face, dark fantasy, full body, T-pose, game-ready, PBR"),
    37: ("npc", None, "mother superior, austere elderly abbess, full dark religious habit and veil, holy pendant, severe pious face, dark fantasy, full body, T-pose, game-ready, PBR"),
    38: ("npc", None, "drainage worker, grimy laborer, soaked patched work clothes, rubber-like waders, tools, exhausted dirty face, dark fantasy, full body, T-pose, game-ready, PBR"),
    39: ("npc", None, "deacon, mid-rank clergy man, dark cassock with trim, holy book, composed devout face, dark fantasy, full body, T-pose, game-ready, PBR"),
    49: ("npc", None, "portrait of the returned man, painted bust of a haunted pale figure in muted clothing, framed dark fantasy portrait, hollow eyes"),
    17: ("creature", None, "Mour the swamp consciousness, colossal eldritch boss entity rising from the bog, dark mass of roots mud and vegetation, glowing green core and veins, towering amorphous form, dark fantasy raid boss, full body, T-pose, game-ready, PBR"),
    40: ("creature", None, "The Presence that answers, spectral hooded entity, translucent shifting robe of shadow, faint glowing features, ominous stillness, dark fantasy apparition, full body, T-pose, game-ready, PBR"),
    44: ("creature", None, "Tvani beast, blind predator of the Raging River, large sightless amphibious hunter, sleek muscular grey hide, eyeless snarling head with sensory whiskers, jagged horns, webbed claws, dark fantasy, full body, T-pose, game-ready, PBR"),
    45: ("creature", None, "Reed Wanderer, tall gaunt plant-creature, humanoid silhouette woven from reeds and swamp foliage, faint glowing motes, slow eerie posture, dark fantasy, full body, T-pose, game-ready, PBR"),
    # Locations / scenes (environment refs, NOT character generation)
    41: ("location", None, "flooded chapel of the Keepers, exterior, half-submerged gothic stone chapel in a swamp, cracked arches, water reflections, mist, dark fantasy environment"),
    42: ("location", None, "flooded chapel of the Keepers, interior, waterlogged gothic hall, submerged pews, tall pillars, dim shafts of light, dark fantasy environment"),
    43: ("location", None, "flooded sacrificial altar, ancient stone altar table rising from dark water, brick columns, hanging lamps, arched tunnel, dark fantasy environment"),
    46: ("location", None, "Altar of Stagnation, corrupted swamp shrine, decayed stone altar overgrown with rot and reeds, sickly green glow, dark fantasy environment"),
    47: ("scene", None, "Ashen Paths of Hazemoor, bleak ash-covered trails winding through a ruined blighted land, grey desolation, dark fantasy environment concept"),
    48: ("location", None, "Altar of Stagnation, episode 4 state, grand ruined architectural hall around the corrupted altar, arches and galleries, ominous atmosphere, dark fantasy environment"),
    50: ("location", None, "Black Archive of Valkorn, episode 4, vast dark library hall, towering shelves, arches, lantern light, books and furniture, dark fantasy environment"),
    51: ("scene", None, "Hero's Departure - Three Paths, final cinematic scene, a lone hooded figure at a fork of three diverging roads, city walls, meadow, and a bridge, dark fantasy epilogue concept"),
    16: ("creature", None, "Mour the swamp consciousness, teaser view, colossal eldritch bog entity of roots mud and vegetation with glowing green core, dark fantasy, full body, T-pose, game-ready, PBR"),  # uncaptioned p7 frame; near-identical (RMS 7.2) to captioned Mour on p8
}

TYPE_LABEL = {
    "creature": "🐾 Істота / монстр",
    "npc": "🧍 Персонаж (NPC)",
    "location": "🏛️ Локація / об'єкт",
    "scene": "🎬 Сцена / концепт",
    "unknown": "❓ Без підпису — уточнити",
}
ORDER = ["creature", "npc", "location", "scene", "unknown"]


def meshy_route(t: str) -> str:
    if t in ("creature", "npc"):
        return "`meshy_text_to_3d` (t-pose) → `_refine` (PBR) → `meshy_rig`  •  або `image_to_3d` з референсом нижче"
    if t in ("location", "scene"):
        return "Середовище/лейаут: `image_to_3d` (standard) як пропс-кіт, **не** для рігінгу. Персонажів звідси не діставати."
    return "Спершу ідентифікувати вміст кадру, тоді обрати маршрут."


def main() -> None:
    data = json.load(open(MANIFEST, encoding="utf-8"))
    by_id = {r["id"]: r for r in data}
    groups: dict[str, list[int]] = {k: [] for k in ORDER}
    for i, (t, *_ ) in ENT.items():
        groups[t].append(i)

    lines: list[str] = []
    A = lines.append
    A("# Hazemoor — Візуальний довідник сутностей → Meshy")
    A("")
    A("> Джерело: `D:\\vision art game.pdf` (23 стор., 51 концепт-арт).")
    A("> **Імена, HP і ролі** взяті з текстового шару PDF (канон). **Опис зовнішності**")
    A("> — з ілюстрацій; локальна MiniCPM-V 4.6 дала лише грубий тип, тож візуальні")
    A("> деталі вивірені вручну. Кожен запис має **референс-кадр** і **готовий Meshy-промпт**.")
    A("")
    A("## Як користуватись")
    A("")
    A("1. Знайди сутність у розділі за типом.")
    A("2. Для NPC/істот: промпт уже у форматі `full body, T-pose` — можна лити прямо в")
    A("   `meshy_text_to_3d` (`pose_mode=\"t-pose\"`), або скормити референс-кадр у `image_to_3d`.")
    A("3. Дотримуйся кредитного бюджету: ~15–20 cr/модель (meshy-5), рігінг +5 cr.")
    A("4. Локації/сцени — це середовище й лейаут, **не** генеруй з них персонажів.")
    A("")
    A(f"**Усього:** {len(ENT)} концептів · "
      + " · ".join(f"{TYPE_LABEL[k].split(' ',1)[1]}: {len(groups[k])}" for k in ORDER if groups[k]))
    A("")
    A("---")
    A("")

    for t in ORDER:
        ids = groups[t]
        if not ids:
            continue
        A(f"## {TYPE_LABEL[t]}")
        A("")
        for i in sorted(ids):
            rec = by_id[i]
            _, hp, prompt = ENT[i]
            cap = rec["caption"].strip() or "(без підпису)"
            A(f"### {i:02d}. {cap}")
            A("")
            A(f"![{cap}]({rec['image']})")
            A("")
            A(f"- **Тип:** {TYPE_LABEL[t]}")
            if hp:
                A(f"- **HP:** {hp}")
            A(f"- **Референс:** стор. {rec['image_page']} PDF · `{rec['image']}`")
            A(f"- **Маршрут Meshy:** {meshy_route(t)}")
            if prompt:
                A("- **Meshy prompt:**")
                A("")
                A("  ```text")
                A(f"  {prompt}")
                A("  ```")
            else:
                A("- **Meshy prompt:** _—  спершу ідентифікувати кадр (немає підпису в PDF)._")
            A("")
        A("---")
        A("")

    DOC.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"wrote {DOC} ({DOC.stat().st_size} bytes, {len(lines)} lines)")
    # coverage check
    missing = [r["id"] for r in data if r["id"] not in ENT]
    print("concepts in manifest:", len(data), "| documented:", len(ENT), "| missing:", missing)


if __name__ == "__main__":
    main()
