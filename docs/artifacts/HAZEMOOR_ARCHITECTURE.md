#   HAZEMOOR — Архітектура проекту 

 
> Повна документація архітектури RPG гри Hazemoor (Godot 4.3) 
>  
> **Статус:** 9 критичних + важливих компонентів готові (4608 рядків 
коду) 
>  
> **Дата:** 01.07.2026 
 
--- 
 
##   ЗМІСТ 
 
1. [Огляд системи](#огляд-системи) 
2. [Структура папок](#структура-папок) 
3. [Архітектура даних](#архітектура-даних) 
4. [Потік виконання](#потік-виконання) 
5. [Компоненти й їхні взаємозв'язки](#компоненти--їхні-взаємозв'язки) 
6. [Системи гри](#системи-гри) 
7. [Життєвий цикл квесту](#життєвий-цикл-квесту) 
8. [Інтеграція компонентів](#інтеграція-компонентів) 
 
--- 
 
##   Огляд системи 
 
### Тип гри 
- **Жанр:** Dark Fantasy RPG 
- **Перспектива:** Третьо-особовий вид (over-shoulder) 
- **Механіка:** Quest-driven narrative з вибором і наслідками 
- **Настроль:** Мрачна атмосфера болота й окультизму 
 
### Цільові платформи 
- Windows (основно) 
- Linux (Future) 
- WebGL (Future) 
 
### Технічний стек 
- **Engine:** Godot 4.3 
- **Мова:** GDScript 
- **Дані:** JSON (quests, NPCs, items, locations) 
- **3D Моделі:** Meshy AI, Blender (FBX/GLB) 
- **Audio:** ElevenLabs TTS (dialogue), Royalty-free MP3 (music/SFX) 
- **Вхідні дані:** WASD + Mouse + E (interact) + Space (dodge) 
 
--- 
 
##   Структура папок 
 
``` 
game-bible/ 
├── godot-project/                    # Основний Godot проект 
│   ├── project.godot                 # Конфіг проекту 
│   │ 
│   ├── scripts/ 
│   │   ├── systems/                  # AUTOLOAD СИНГЛТОНИ 
│   │   │   ├── PlayerState.gd        # (440) Стан гравця 
│   │   │   ├── QuestManager.gd       # (320) Керування квестами 
│   │   │   ├── SaveManager.gd        # (396) Збереження/завантаження 
│   │   │   ├── ReputationManager.gd  # (417) Репутація фракцій 
│   │   │   ├── DialogueManager.gd    # (428) Мініділоги & voice 
│   │   │   ├── InventoryManager.gd   # (543) Інвентар & обладнання 
│   │   │   └── AudioManager.gd       # (425) Музика & SFX 

│   │   │ 
│   │   ├── player/ 
│   │   │   └── PlayerController.gd   # (359) Рух, камера, введення 
│   │   │ 
│   │   ├── characters/ 
│   │   │   └── NPC.gd                # (267) Базовий клас для персонажів 
│   │   │ 
│   │   ├── ui/ 
│   │   │   └── DialogueUI.gd         # (284) UI панель діалогів 
│   │   │ 
│   │   └── gameplay/ 
│   │       ├── InteractableObject.gd # (368) Двері, сундуки, предмети 
│   │       └── Level.gd              # (392) Керування рівнем 
│   │ 
│   ├── scenes/                       # ТSCN сцени (будуть створені в 
Editor) 
│   │   ├── player/ 
│   │   │   └── Player.tscn           # Гравець (CharacterBody3D) 
│   │   ├── ui/ 
│   │   │   ├── DialoguePanel.tscn    # Панель діалогів (CanvasLayer) 
│   │   │   ├── HUD.tscn              # (TODO) Health, stamina bar 
│   │   │   ├── QuestLog.tscn         # (TODO) Журнал квестів 
│   │   │   └── MainMenu.tscn         # (TODO) Стартовий екран 
│   │   └── levels/ 
│   │       ├── Greyford/ 
│   │       │   ├── TavernInterior.tscn 
│   │       │   ├── MainStreet.tscn   # (TODO) 
│   │       │   └── AdminBuilding.tscn # (TODO) 
│   │       ├── SonkFerry.tscn        # (TODO) 
│   │       ├── Valkorn.tscn          # (TODO) 
│   │       └── Hazemoor.tscn         # (TODO) Бос-арена 
│   │ 
│   ├── data/                         # JSON дані (37 файлів) 
│   │   ├── quests/ 
│   │   │   ├── грейфорд_та_scenes.json         # 14 сцен 
│   │   │   ├── зустріч_з_scenes.json           # 2 сцени 
│   │   │   ├── повний_триденний_scenes.json    # 42 сцени 
│   │   │   ├── великий_валькорн_scenes.json    # 21 сцена 
│   │   │   ├── глибоке_болото_scenes.json      # 15 сцен 
│   │   │   ├── два_береги_scenes.json          # 21 сцена 
│   │   │   ├── абсолютні_фінали_scenes.json    # 2 сцени 
│   │   │   ├── unknown_scenes.json             # 1 сцена 
│   │   │   └── meta.json                       # Мета-інформація 
│   │   │ 
│   │   ├── npcs/                     # Персонажи 
│   │   │   ├── mia.json 
│   │   │   ├── ervan.json 
│   │   │   ├── kelm.json 
│   │   │   ├── altea.json 
│   │   │   ├── mour.json 
│   │   │   ├── generic_npcs.json 
│   │   │   └── ... 2 more 
│   │   │ 
│   │   ├── items/ 
│   │   │   ├── items_database.json   # 8+ items (consumables, etc.) 
│   │   │   └── weapons_database.json # 3 weapons 
│   │   │ 
│   │   ├── locations/ 
│   │   │   ├── greyford.json 
│   │   │   ├── sonk_ferry.json 
│   │   │   ├── valkorn.json 
│   │   │   └── hazemoor.json 
│   │   │ 

│   │   ├── dialogues/ 
│   │   │   ├── minidialogues.json    # Мініділоги (greeting, reaction) 
│   │   │   ├── ervan/ 
│   │   │   ├── mia/ 
│   │   │   └── ... per NPC 
│   │   │ 
│   │   └── audio/ 
│   │       └── ambience_database.json 
│   │ 
│   ├── assets/                       # 3D моделі й текстури (Meshy AI) 
│   │   ├── models/ 
│   │   │   ├── characters/ 
│   │   │   │   ├── player_character.fbx/.glb 
│   │   │   │   ├── ervan.fbx/.glb 
│   │   │   │   ├── mia.fbx/.glb 
│   │   │   │   └── ... інші персонажи 
│   │   │   └── environments/ 
│   │   │       ├── tavern_interior.fbx 
│   │   │       ├── city_mainstreet.fbx 
│   │   │       └── ... інші локації 
│   │   │ 
│   │   ├── textures/ 
│   │   │   ├── wood_01_albedo.png 
│   │   │   ├── wood_01_normal.png 
│   │   │   └── ... 10+ PBR текстур 
│   │   │ 
│   │   └── shaders/                  # (TODO) GLSL шейдери 
│   │       ├── fog_volume.gdshader 
│   │       ├── water_reflection.gdshader 
│   │       └── glow_material.gdshader 
│   │ 
│   ├── audio/ 
│   │   ├── music/ 
│   │   │   ├── tavern_ambient.ogg    # Музика для таверни 
│   │   │   ├── exploration.ogg       # Дослідження 
│   │   │   └── boss_battle.ogg       # (Future) Бос-бій 
│   │   ├── sfx/ 
│   │   │   ├── door_open.ogg 
│   │   │   ├── sword_hit.ogg 
│   │   │   └── ... 20+ SFX 
│   │   └── dialogue/ 
│   │       ├── ervan_greeting.mp3    # Від ElevenLabs TTS 
│   │       ├── mia_reaction.mp3 
│   │       └── ... 50+ voice lines 
│   │ 
│   └── [ГАЙДИ - Markdown документи] 
│       ├── GODOT-EDITOR-SETUP.md              # (431) Від А до Я 
│       ├── DIALOGUE_PANEL_SETUP.md            # (208) UI в Editor 
│       ├── INPUT_MAP_CONFIG.md                # (272) Клавіші 
│       ├── ANIMATION_TREE_SETUP.md            # (437) Анімації 
│       ├── TECHNICAL-DESIGN.md                # (505) Архітектура Godot 
│       ├── GREYFORD-LEVEL-DESIGN.md           # (604) Перша локація 
│       └── ASSET-LIST.md                      # (739) 3D модельки 
│ 
└── web/ 
    └── quests-data.js                # (Original) Web браузерний 
симулятор 
``` 
 
--- 
 
##   Архітектура даних 
 

### Глобальний стан (PlayerState) 
 
```gdscript 
PlayerState { 
  # Квести 
  completed_quests: {quest_id: true, ...} 
  active_quests: {quest_id: progress_data, ...} 
   
  # Репутація (-40 to +40) 
  reputation: { 
    "greyford_admin": 0, 
    "muri": 0, 
    "keepers": 0, 
    "order_seven_daggers": 0, 
    "lightbearers": 0 
  } 
   
  # Докрини (0-3 рівні) 
  doctrines: { 
    "lantern": 0, 
    "judge": 0, 
    "mediator": 0, 
    "tracker": 0 
  } 
   
  # Здоров'я й витримка 
  hp: 100 
  stamina: 50 
   
  # Прогрес персонажа 
  level: 1 
  experience: 0 
   
  # Інвентар & обладнання 
  inventory: [{item_id, quantity}, ...] 
  equipment: {weapon: "sword_01", armor_chest: "plate_01", ...} 
   
  # Позиція гравця 
  player_position: Vector3(x, y, z) 
  current_location: "greyford_tavern" 
} 
``` 
 
### JSON структури 
 
#### Quest Scene 
```json 
{ 
  "id": "arriving", 
  "title": "Прибуття у таверну", 
  "text": "Ви входите у напівтемну таверну...", 
  "choices": [ 
    { 
      "text": "Говорити з Ерваном", 
      "conditions": [ 
        {"type": "reputation", "faction": "greyford_admin", "min_value": 
-10} 
      ], 
      "effects": [ 
        {"type": "add_reputation", "faction": "greyford_admin", "amount": 
5}, 
        {"type": "goto_scene", "scene_id": "ervan_greeting"} 
      ] 

    } 
  ] 
} 
``` 
 
#### NPC Data 
```json 
{ 
  "id": "ervan", 
  "name": "Ерван", 
  "age": 52, 
  "faction": null, 
  "bio": "Таверна становить його добре...", 
  "dialogue_sets": { 
    "greeting": ["Привіт, друже!"], 
    "reaction_positive": ["Мені подобається твій дух!"] 
  } 
} 
``` 
 
#### Item Data 
```json 
{ 
  "id": "health_potion", 
  "name": "Зелье здоров'я", 
  "type": "consumable", 
  "rarity": "common", 
  "description": "Вилікувати 50 HP", 
  "max_stack": 99, 
  "weight": 0.1, 
  "value": 25, 
  "effects": [{"type": "heal", "amount": 50}] 
} 
``` 
 
--- 
 
##   Потік виконання (на старті гри) 
 
``` 
1. Godot engine starts 
   ↓ 
2. Autoload Singeltons initialize (_ready): 
   • PlayerState._ready() 
   • QuestManager._ready() 
   • SaveManager._ready() 
   • ReputationManager._ready() 
   • DialogueManager._ready() 
   • InventoryManager._ready() 
   • AudioManager._ready() 
   ↓ 
3. Main Scene loads (TavernInterior.tscn): 
   • Level._ready() 
     - _load_spawn_points() 
     - _register_npcs() 
     - _register_interactive_objects() 
     - _spawn_player() 
   • Player (CharacterBody3D) spawns at spawn point 
   • NPCs initialize (Ervan, Mia, etc.) 
   ↓ 
4. Game starts with first dialogue: 
   QuestManager.load_episode("грейфорд_та") 
   QuestManager.display_scene("arriving") 

   ↓ 
5. DialogueUI shows scene on screen 
   Player reads text + sees choices 
   ↓ 
6. Player makes choice (E key → apply_choice) 
   QuestManager processes effects: 
   - Add reputation 
   - Mark quest complete 
   - Transition to next scene 
   ↓ 
7. Loop: next scene displayed... 
``` 
 
--- 
 
##   Компоненти й їхні взаємозв'язки 
 
### Архітектура синглтонів 
 
``` 
                    ┌─────────────┐ 
                    │ PlayerState │ (Global state) 
                    └──────┬──────┘ 
                           │ 
        ┌──────────────────┼──────────────────┐ 
        │                  │                  │ 
    ┌───▼────┐      ┌─────▼────┐     ┌──────▼────┐ 
    │ Quest  │      │ Dialogue │     │ Inventory│ 
    │Manager │      │ Manager  │     │ Manager  │ 
    └───┬────┘      └──────────┘     └──────────┘ 
        │                                    │ 
        │                           ┌────────▼─────┐ 
        │                           │ Items/Weapons│ 
        │                           │ (JSON data)  │ 
        │                           └──────────────┘ 
        │ 
    ┌───▼──────────┐ 
    │ Scene data   │ 
    │ (JSON)       │ 
    │ 119 scenes   │ 
    └──────────────┘ 
``` 
 
### Ієрархія класів 
 
``` 
Node3D (Godot) 
├── CharacterBody3D 
│   ├── Player 
│   │   ├── CollisionShape3D 
│   │   ├── MeshInstance3D (FBX модель) 
│   │   ├── AnimationPlayer 
│   │   ├── AnimationTree 
│   │   ├── Camera3D (over-shoulder) 
│   │   └── RayCast3D (для взаємодій) 
│   └── NPC (extends CharacterBody3D) 
│       ├── Area3D (DialogueTrigger) 
│       ├── AnimationPlayer 
│       └── [Наслідується для Ervan, Mia, Kelm...] 
│ 
└── StaticBody3D 
    └── InteractableObject (extends StaticBody3D) 
        ├── Area3D (InteractionTrigger) 

        ├── AnimationPlayer 
        ├── AudioStreamPlayer3D 
        └── [Наслідується для Door, Chest, Item...] 
 
Level (extends Node3D) 
├── SpawnPoints → Marker3D x N 
├── NPCs → NPC instances 
├── InteractiveObjects → InteractableObject instances 
└── Environment → WorldEnvironment, Lighting 
``` 
 
--- 
 
##   Системи гри 
 
### 1. Quest System 
 
``` 
QuestManager (Autoload) 
  ├─ load_episode(name) 
  │  └─ JSON: res://data/quests/{name}_scenes.json 
  ├─ display_scene(id) 
  │  └─ Signal: scene_displayed → DialogueUI 
  ├─ apply_choice(index) 
  │  ├─ _evaluate_conditions() 
  │  ├─ _apply_effects() 
  │  │  ├─ mark_quest_complete() → PlayerState 
  │  │  ├─ add_reputation() → PlayerState + ReputationManager 
  │  │  └─ unlock_doctrine() → PlayerState 
  │  └─ goto_scene() → next scene 
  └─ Signals: quest_completed, choice_made 
``` 
 
### 2. Reputation System 
 
``` 
ReputationManager (Autoload) 
  ├─ add_reputation_for_quest(faction, type, multiplier) 
  ├─ get_reputation_tier(faction) 
  │  └─ Returns: hostile, unfriendly, neutral, friendly, trusted 
  ├─ has_perk(faction, perk_name) 
  │  └─ Checks: min reputation threshold 
  ├─ get_reputation_bonuses(faction) 
  │  └─ Returns: damage_bonus, price_discount, quest_reward_multiplier 
  └─ Signals: 
     ├─ reputation_threshold_reached 
     └─ faction_perk_unlocked/lost 
``` 
 
### 3. Dialogue System 
 
``` 
DialogueUI (CanvasLayer scene) 
  └─ Display text + choices 
     ├─ Signal: choice_made → QuestManager 
     └─ Signal: choice_made → NPC (for reactions) 
 
DialogueManager (Autoload) 
  ├─ play_minidialogue(id, npc) 
  │  ├─ dialogue_line_spoken signal → UI 
  │  └─ play_voice_line() → MP3 audio 
  ├─ Conditional dialogue (reputation, doctrine, quest_completed) 
  └─ Dialogue history for journal 

``` 
 
### 4. Inventory System 
 
``` 
InventoryManager (Autoload) 
  ├─ add_item(item_id, quantity) 
  │  ├─ Weight check 
  │  └─ Stack system for consumables 
  ├─ equip_item(item_id, slot) 
  │  ├─ Slot validation (weapon, armor, trinket) 
  │  └─ Equipment state in PlayerState 
  ├─ use_item(item_id) 
  │  ├─ _apply_item_effect() 
  │  │  ├─ heal → PlayerState 
  │  │  ├─ add_reputation → PlayerState 
  │  │  └─ add_item → recursive 
  │  └─ remove_item() 
  └─ Weight management: MAX_WEIGHT = 50kg 
``` 
 
### 5. Audio System 
 
``` 
AudioManager (Autoload) 
  ├─ play_music(track_name) 
  │  ├─ fade_out (previous) 
  │  └─ fade_in (new) 
  ├─ play_sfx(sfx_name, volume, pitch) 
  │  └─ Creates AudioStreamPlayer 
  ├─ play_sfx_3d(sfx_name, position) 
  │  └─ Creates AudioStreamPlayer3D 
  ├─ play_ambient(ambient_name) 
  │  └─ Looped sound 
  └─ AudioBus management: 
     ├─ Master 
     ├─ Music 
     ├─ SFX 
     ├─ UI 
     ├─ Dialogue 
     └─ Ambient 
``` 
 
### 6. Save System 
 
``` 
SaveManager (Autoload) 
  ├─ save_game(slot) 
  │  └─ JSON: user://saves/slot_{1-5}.json 
  ├─ load_game(slot) 
  │  └─ PlayerState.from_dict() 
  ├─ auto_save_game() 
  │  ├─ Every 5 minutes 
  │  └─ On quest_completed signal 
  └─ get_save_info(slot) 
     └─ Returns: playtime, location, level, timestamp 
``` 
 
### 7. Level System 
 
``` 
Level (Node3D scene root) 
  ├─ _load_spawn_points() 

  │  └─ Register Marker3D children 
  ├─ _register_npcs() 
  │  └─ Register NPC children 
  ├─ _register_interactive_objects() 
  │  └─ Register InteractableObject children 
  ├─ start_npc_dialogue(npc_id, quest_id) 
  │  └─ NPC.start_dialogue() → QuestManager flow 
  ├─ transition_to_level(scene_path, spawn_point) 
  │  └─ Change scene + respawn player 
  └─ set_checkpoint(name) 
     └─ SaveManager.save_game() (auto-save) 
``` 
 
--- 
 
##   Життєвий цикл квесту 
 
``` 
1. QUEST INITIATION 
   └─ QuestManager.load_episode("грейфорд_та") 
      └─ Load JSON: 14 scenes 
 
2. SCENE DISPLAY 
   └─ QuestManager.display_scene("arriving") 
      ├─ _process_scene_choices() — filter by conditions 
      ├─ scene_displayed signal → DialogueUI 
      └─ DialogueUI shows: 
         ├─ Title: "Постоялий двір Грейфорда" 
         ├─ Text: "Ви входите у напівтемну таверну..." 
         └─ Choices: [Кнопка 1, Кнопка 2, Кнопка 3, Кнопка 4] 
 
3. PLAYER CHOICE 
   └─ DialoguePanel.tscn receives input (E key pressed) 
      └─ QuestManager.apply_choice(choice_index) 
         ├─ _apply_effects(): 
         │  ├─ mark_quest_complete("arriving") 
         │  │  └─ PlayerState.completed_quests["arriving"] = true 
         │  ├─ add_reputation("greyford_admin", +5) 
         │  │  └─ ReputationManager checks threshold 
         │  │     └─ "friendly" threshold reached → signal 
         │  └─ goto_scene("ervan_greeting") 
         └─ display_scene("ervan_greeting") [LOOP] 
 
4. NPC REACTION 
   └─ NPC.start_dialogue("arriving") 
      ├─ Play talking animation 
      └─ DialogueManager.play_minidialogue("ervan_greeting") 
         ├─ Play voice line (MP3) 
         └─ Show text on screen 
 
5. LOOP CONTINUES 
   └─ Until scene has no more choices 
      └─ Scene has no goto_scene effect 
         └─ DialoguePanel hides 
            └─ PlayerState updated 
               └─ SaveManager.auto_save() 
``` 
 
--- 
 
##   Інтеграція компонентів 
 
### Сценарій: Гравець говорить з Ерваном 

 
``` 
Timeline: 
 
T0: Player moves near Ervan in TavernInterior 
    ↓ 
T1: PlayerController._physics_process() 
    └─ Detects input "interact" (E key) 
    └─ Player.interact() called 
    ↓ 
T2: NPC._on_dialogue_trigger_entered() triggered 
    ├─ _player_in_range = true 
    └─ Show UI hint "Press E to talk" 
    ↓ 
T3: Player presses E 
    ├─ Level.start_npc_dialogue("ervan", "arriving") 
    └─ NPC.start_dialogue("arriving") 
       ├─ PlayerController.lock_movement = true (блокуємо рух) 
       ├─ Play talking animation 
       └─ Signal to QuestManager 
    ↓ 
T4: QuestManager loads episode "грейфорд_та" 
    ├─ Load JSON: грейфорд_та_scenes.json 
    └─ display_scene("arriving") 
       ├─ Create choices from JSON 
       └─ Signal scene_displayed → DialogueUI 
    ↓ 
T5: DialogueUI._on_scene_displayed() 
    ├─ Show TitleLabel: "Постоялий двір Грейфорда" 
    ├─ Show TextLabel: "Ви входите у таверну..." 
    ├─ Create ChoiceButtons dynamically 
    └─ Fade in with animation 
    ↓ 
T6: Player clicks choice #0: "Ви домовились з ним?" 
    ↓ 
T7: QuestManager.apply_choice(0) 
    ├─ _evaluate_conditions() → pass 
    ├─ _apply_effects(): 
    │  ├─ mark_quest_complete("arriving") 
    │  │  └─ PlayerState.completed_quests["arriving"] = true 
    │  │     └─ SaveManager.auto_save() triggered 
    │  ├─ add_reputation("greyford_admin", +5) 
    │  │  └─ ReputationManager._on_reputation_changed() 
    │  │     └─ Check thresholds, perks, bonuses 
    │  └─ goto_scene("ervan_reaction_positive") 
    └─ display_scene("ervan_reaction_positive") 
    ↓ 
T8: DialogueManager.play_minidialogue("ervan_reaction_positive") 
    ├─ Load voice: res://assets/audio/dialogue/ervan_reaction.mp3 
    └─ Play audio (ElevenLabs TTS) 
    ↓ 
T9: NPC._react_to_reputation_change(+5) 
    ├─ Play positive_reaction animation 
    └─ Play SFX: "positive_chime.ogg" 
    ↓ 
T10: Scene ends (no more choices) 
     ├─ DialogueUI.hide_panel() 
     ├─ NPC.end_dialogue() 
     ├─ PlayerController.lock_movement = false 
     └─ Player can move again 
``` 
 
--- 

 
##   Статистика проекту 
 
| Категорія | Кількість | 
|-----------|-----------| 
| GDScript файлів | 9 | 
| Рядків коду (GDScript) | 4,608 | 
| JSON файлів (дані) | 37 | 
| Markdown гайдів | 7 | 
| Рядків документації | 2,000+ | 
| Quest сцен | 119 | 
| NPC персонажів | 8 | 
| Interactable об'єктів | 20+ (TODO) | 
| Локацій | 4 | 
| Item типів | 8+ | 
| AudioBus каналів | 6 | 
| Анімаційних станів | 15+ (TODO) | 
| **ВСЬОГО** | **~7,000+ рядків** | 
 
--- 
 
##   Статус розвитку 
 
###   ГОТОВО (9 компонентів) 
 
- QuestManager.gd (320 рядків) 
- PlayerState.gd (440 рядків) 
- DialogueUI.gd (284 рядки) 
- PlayerController.gd (359 рядків) 
- SaveManager.gd (396 рядків) 
- NPC.gd (267 рядків) 
- InteractableObject.gd (368 рядків) 
- ReputationManager.gd (417 рядків) 
- DialogueManager.gd (428 рядків) 
- InventoryManager.gd (543 рядків) 
- AudioManager.gd (425 рядків) 
- Level.gd (392 рядків) 
- **7 Гайдів** (2,000+ рядків) 
 
###   TODO (опціонально) 
 
- [ ] UI Скелети (HUD.tscn, QuestLog.tscn, MainMenu.tscn) 
- [ ] Shader Library (fog, water, glow effects) 
- [ ] Test Scenes (для дебагування) 
- [ ] Combat System (CombatManager.gd, Enemy AI) 
- [ ] Performance Optimization Guide 
 
--- 
 
##   Наступні кроки 
 
1. **Відкрити Godot 4.3** 
2. **Слідувати GODOT-EDITOR-SETUP.md** 
3. **Створити сцени:** 
   - Player.tscn 
   - DialoguePanel.tscn 
   - TavernInterior.tscn 
4. **Запустити F5 → перша гра!** 
 
--- 
 
**Проект готовий до розвитку!  ** 

 
*Дата: 01.07.2026 | Версія: 1.0 | Engine: Godot 4.3*
