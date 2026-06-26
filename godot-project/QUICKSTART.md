# Quick Start Guide — Hazemoor
## За 15 хвилин до першого запуску!

> Швидкий старт для тих, хто вже знайомий з Godot

---

## 🚀 Швидкий старт (15 хвилин)

### 1. Імпорт (2 хв)
```
Godot → Import → godot-project/project.godot → Import & Edit
```

### 2. Autoload (5 хв) ⚠️ ОБОВ'ЯЗКОВО
**Project → Project Settings → Autoload** — додати 8 менеджерів:

| Path | Name |
|------|------|
| `res://scripts/core/game_manager.gd` | GameManager |
| `res://scripts/core/quest_manager.gd` | QuestManager |
| `res://scripts/core/reputation_manager.gd` | ReputationManager |
| `res://scripts/core/dialogue_manager.gd` | DialogueManager |
| `res://scripts/core/save_manager.gd` | SaveManager |
| `res://scripts/core/inventory_manager.gd` | InventoryManager |
| `res://scripts/core/combat_manager.gd` | CombatManager |
| `res://scripts/core/weather_manager.gd` | WeatherManager |

### 3. Input Map (2 хв)
**Project → Project Settings → Input Map** — додати:

| Action | Key |
|--------|-----|
| `move_forward` | W |
| `move_back` | S |
| `move_left` | A |
| `move_right` | D |
| `sprint` | Shift |
| `jump` | Space |
| `interact` | E |

### 4. Створити Player (3 хв)
```
Scene → New → CharacterBody3D (Player)
├── CollisionShape3D (CapsuleShape)
├── CameraPivot (Node3D, Y=1.5)
│   └── Camera3D (Z=3)
├── MeshInstance3D (CapsuleMesh, placeholder)
└── HealthComponent (Node, script: health_component.gd)

Player → Attach Script → player_controller.gd (LOAD, не Create!)
Player → Groups → "player"
Save → scenes/characters/Player.tscn
```

### 5. Тестова локація (3 хв)
```
Scene → New → Node3D (TestLevel)
├── StaticBody3D (Floor)
│   ├── CollisionShape3D (BoxShape, 50x0.5x50)
│   └── MeshInstance3D (BoxMesh)
├── DirectionalLight3D (Y=10, Rotation=-45,-30,0)
└── WorldEnvironment (Sky)

Instantiate Player.tscn → Position (0,2,0)
Save → scenes/environments/TestLevel.tscn
```

### 6. Запуск!
```
F6 або ▶️ → WASD рух, Shift спринт, Mouse камера
```

✅ **Готово! Ти в грі!**

---

## 📚 Далі:

**Детальний tutorial:** `TUTORIAL.md`

**Системи документації:**
- Quest system → `data/quests/*.json`
- Dialogues → `data/dialogues/{npc}/*.json`
- NPCs → `data/npcs/*.json`
- Items → `data/items/*.json`

**Приклади використання:**

```gdscript
# Квест
QuestManager.start_quest(quest_data)
QuestManager.update_objective("quest_id", "objective_id", 1)

# Репутація
ReputationManager.modify_reputation("greyford", 10)

# Діалог
DialogueManager.start_dialogue("kelm", "first_meeting")

# Інвентар
InventoryManager.add_item("item_silver_coin", 50)

# Combat
CombatManager.deal_damage(attacker, target, 25, CombatManager.DamageType.PHYSICAL)

# Погода
WeatherManager.set_weather("rain", 0.8)
WeatherManager.set_fog_density(0.05)
```

**Потрібна допомога?** Читай `README.md` та `TUTORIAL.md`! 🎮
