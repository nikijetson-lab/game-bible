import os

files_to_concatenate = [
    # Part 1: Design/World Docs
    "design/vision.md",
    "design/world-premise.md",
    "design/world.md",
    "design/world-names.md",
    "design/world-map.md",
    "design/protagonist.md",
    "design/hero-progression.md",
    "design/gameplay-loop.md",
    "design/systems.md",
    "design/reputation.md",
    "design/crafting.md",
    "design/factions.md",
    "design/orden-semy-kyndzhativ.md",
    "design/ilia-voice-mechanic.md",

    # Part 2: Episode 1 (Greyford and Hazemoor)
    "characters/iliya.md",
    "characters/lileya.md",
    "regions/greyford.md",
    "letters/until-forgotten.md",
    "quests/greyford-01-adresat-vidsutniy.md",
    "characters/mia.md",
    "quests/hazemoor-01-shlyakh-kriz-boloto.md",
    "races/muri.md",
    "regions/tykhyy-shelest.md",
    "quests/muri-path-01-seven-lessons-old.md",
    "quests/tykhy-shelist-quests.md",
    "regions/hazemoor-galyavyna-moura.md",
    "quests/hazemoor-02-halyna-dusha.md",

    # Part 3: Parallel Quests (Sunk-Ferry)
    "regions/sunk-ferry.md",
    "quests/hazemoor-lantsyuzhok.md",
    "quests/holod-znuzu.md",
    "quests/holod-znuzu-naslidky.md",
    "quests/sil-u-knyzi.md",
    "quests/poromna-prysyaga.md",
    "quests/popil-pid-kaplytseyu.md",
    "quests/nizh-kvoty.md",

    # Part 4: Episode 2 (Valkorn)
    "regions/valkorn.md",
    "characters/tessa.md",
    "quests/valkorn-01-lyudyna-z-bolota.md",
    "quests/valkorn-02-dvi-versii-pravdy.md",
    "quests/valkorn-03-pravylna-tsina.md",
    "quests/valkorn-04-lyudyna-shcho-poslala-rufina.md",
    "characters/jester.md",
    "quests/valkorn-05-khranitel-pershoyi-pechatky.md",

    # Part 5: Episode 3 (Deep Bog)
    "quests/deep-bog-01-holos-iz-tumanu.md",
    "characters/odrin.md",
    "quests/deep-bog-02-shalyaniy-porom.md",
    "quests/deep-bog-03-zatoplena-obytel.md",

    # Part 6: Episode 4 (Two Shores - Final)
    "quests/episode-4-01-povernennya-do-valkorna.md",
    "quests/episode-4-02-kulminatsiya-valkorna.md",
    "quests/episode-4-03-hazemoor-moura.md",
    "quests/episode-4-04-final-rozvyazka.md",
    "quests/episode-4-05-vidhid-heroya.md"
]

with open("FullStory.md", "w", encoding="utf-8") as outfile:
    for i, file_path in enumerate(files_to_concatenate):
        if not os.path.exists(file_path):
            print(f"Warning: File not found: {file_path}")
            continue

        with open(file_path, "r", encoding="utf-8") as infile:
            content = infile.read()
            outfile.write(content)

            # Add visual separator except after the last file
            if i < len(files_to_concatenate) - 1:
                outfile.write("\n\n---\n\n")

print("FullStory.md created successfully.")
