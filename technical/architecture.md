# 🏗️ Архітектура Проекту

## Діаграма Зв'язків Систем

```text
                        ┌─────────────┐
                        │   GAME CORE  │
                        │  (game_manager.gd) │
                        └──────┬──────┘
                               │
          ┌────────────────────┼────────────────────┐
          │                    │                    │
          ▼                    ▼                    ▼
   ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
   │   PLAYER    │     │    WORLD    │     │   EVENTS    │
   │ (player.gd) │     │ (world.gd)  │     │ (events.gd) │
   └──────┬──────┘     └──────┬──────┘     └─────────────┘
          │                   │
    ┌─────┼─────┐       ┌─────┼─────┐
    ▼     ▼     ▼       ▼     ▼     ▼
 ┌────┐ ┌────┐ ┌────┐ ┌────┐ ┌────┐ ┌────┐
 │БІЙ │ │МАГІЯ│ │ІНВЕН│ │ПОГО│ │ЛОКА│ │ЧАС │
 │    │ │    │ │    │ │ДА  │ │ЦІЇ │ │    │
 └────┘ └────┘ └────┘ └────┘ └────┘ └────┘

          ┌─────────────────────────────────┐
          │         DATA LAYER              │
          │  ┌──────┐ ┌──────┐ ┌──────┐   │
          │  │КВЕСТИ│ │NPC   │ │РЕПУТ│   │
          │  │.json │ │.json │ │.json │   │
          │  └──────┘ └──────┘ └──────┘   │
          └─────────────────────────────────┘
```

## Потік Даних

```text
Гравець натискає [E] (взаємодія)
         │
         ▼
Input → player.gd
         │
         ▼
emit_signal("interact", npc_id)
         │
         ▼
dialogue_system.gd отримує сигнал
         │
         ├── Завантажує dialogue_data.json
         │
         ├── Перевіряє reputation.gd (фракція NPC)
         │
         ├── Фільтрує діалог (ворожий/дружній)
         │
         └── Показує UI → dialogue_box.gd
```

## API Специфікація

### Signals (Сигнали подій)

```gdscript
# Глобальні сигнали (Events.gd)
signal quest_accepted(quest_id: String)
signal quest_completed(quest_id: String)
signal reputation_changed(faction: String, new_value: int)
signal player_damaged(amount: int)
signal player_died()
signal npc_killed(npc_id: String)
signal item_collected(item_id: String)
signal zone_entered(zone_id: String)
signal time_changed(hour: int, minute: int)
signal weather_changed(weather_type: String)
signal dialogue_started(npc_id: String)
signal dialogue_ended(npc_id: String, choice: String)
```

### Методи Основних Класів

```gdscript
# Player.gd
func move(direction: Vector2) -> void
func attack() -> void
func take_damage(amount: int) -> void
func heal(amount: int) -> void
func use_item(item_id: String) -> bool
func get_status() -> Dictionary

# QuestSystem.gd
func accept_quest(quest_id: String) -> bool
func add_progress(quest_id: String, objective: String) -> void
func complete_quest(quest_id: String) -> void
func get_active_quests() -> Array
func get_available_quests() -> Array

# ReputationSystem.gd
func get_faction_standing(faction: String) -> int
func modify_reputation(faction: String, delta: int) -> void
func get_faction_status(faction: String) -> String
func get_faction_bonuses(faction: String) -> Dictionary

# Inventory.gd
func add_item(item_id: String, quantity: int = 1) -> bool
func remove_item(item_id: String, quantity: int = 1) -> bool
func has_item(item_id: String, quantity: int = 1) -> bool
func get_item_count(item_id: String) -> int
func get_inventory() -> Dictionary
func get_weight() -> float
```

### Формати Даних (JSON)

```json
// NPC Data Format
{
  "npc_id": "greyford_innkeeper",
  "name": "Боромир",
  "faction": "Greyford",
  "location": "greyford_tavern",
  "dialogues": {
    "greeting": "Заходь, подорожній!",
    "hostile": "Йди геть...",
    "quest_giver": true
  },
  "shop": {
    "buys": ["monster_parts", "herbs"],
    "sells": ["food", "drink", "info"]
  }
}

// Quest Data Format
{
  "quest_id": "blood_for_moor",
  "title": "Кров для Болотяного Бога",
  "type": "main",
  "requirements": {
    "min_level": 5,
    "reputation": {"Muri": -30}
  },
  "stages": [
    {"id": 1, "description": "Знайти культистів", "location": "swamp_camp"},
    {"id": 2, "description": "Жертва 3 NPC", "location": "moor_altar"},
    {"id": 3, "description": "Здолати Аватара", "location": "sunken_temple"}
  ],
  "rewards": {
    "gold": 500,
    "xp": 200,
    "items": ["cursed_blade"],
    "reputation": {"Muri": -50, "Cultists": 30}
  }
}
```

## Схема Папок (Повна)

```text
game-prototype/
├── project.godot           # Головний файл проекту
├── default_env.tres        # Оточення за замовчуванням
├── icon.png                # Іконка гри
│
├── scripts/                # Сценарії
│   ├── core/               # Ядро
│   │   ├── game_manager.gd
│   │   ├── events.gd
│   │   └── save_system.gd
│   │
│   ├── player/             # Гравець
│   │   ├── player.gd
│   │   ├── movement.gd
│   │   └── camera.gd
│   │
│   ├── npc/                # NPC та діалоги
│   │   ├── npc.gd
│   │   ├── dialogue.gd
│   │   └── quest_giver.gd
│   │
│   ├── combat/             # Бойова система
│   │   ├── combat.gd
│   │   ├── enemy.gd
│   │   └── projectile.gd
│   │
│   ├── systems/            # Системи
│   │   ├── inventory.gd
│   │   ├── reputation.gd
│   │   ├── magic.gd
│   │   ├── weather.gd
│   │   ├── time_system.gd
│   │   └── crafting.gd
│   │
│   └── ui/                 # Інтерфейс
│       ├── hud.gd
│       ├── menu.gd
│       ├── dialogue_box.gd
│       └── inventory_ui.gd
│
├── scenes/                 # Сцени
│   ├── main.tscn
│   ├── player.tscn
│   ├── npc.tscn
│   ├── enemy.tscn
│   └── ui/
│       ├── hud.tscn
│       ├── menu.tscn
│       └── inventory.tscn
│
├── assets/                  # Ресурси
│   ├── textures/
│   ├── sounds/
│   ├── music/
│   └── fonts/
│
├── data/                    # Дані
│   ├── npcs.json
│   ├── quests.json
│   ├── items.json
│   ├── enemies.json
│   ├── dialogues.json
│   └── locations.json
│
└── tests/                   # Тести
    ├── test_runner.gd
    ├── test_player.gd
    └── test_combat.gd
```

## Потік Завантаження Гри

```text
[Запуск] → project.godot
    │
    ▼
[Сцена 1: Splash] → Логотип студії
    │
    ▼
[Сцена 2: Main Menu] → Нова гра / Завантажити / Налаштування
    │
    ├── [Нова гра] → GameManager.new_game()
    │       │
    │       ▼
    │   [Сцена 3: Intro] → Кат-сцена з lore
    │       │
    │       ▼
    │   [Сцена 4: World] → Основна гра
    │       │
    │       ├── [Локація 1: Greyford]
    │       ├── [Локація 2: Swamp]
    │       └── [Локація 3: Valkorn]
    │
    └── [Завантажити] → SaveSystem.load_save()
            │
            ▼
        [Сцена 4: World] → Продовження гри
```
