# Godot Tutorial — Hazemoor Project
## Покроковий гайд для роботи з проектом

> **Для:** Початківців та середнього рівня  
> **Час:** ~2 години на все  
> **Версія Godot:** 4.3+

---

## 📋 Зміст

1. [Перше відкриття проекту](#1-перше-відкриття-проекту)
2. [Налаштування Autoload (обов'язково!)](#2-налаштування-autoload)
3. [Створення Player сцени](#3-створення-player-сцени)
4. [Створення тестової локації](#4-створення-тестової-локації)
5. [Створення NPC з діалогами](#5-створення-npc-з-діалогами)
6. [Підключення квесту](#6-підключення-квесту)
7. [Тестування репутації](#7-тестування-репутації)
8. [Додавання нового квесту](#8-додавання-нового-квесту)
9. [Combat: створення ворога](#9-combat-створення-ворога)
10. [UI: підключення HUD](#10-ui-підключення-hud)

---

## 1. Перше відкриття проекту

### Крок 1.1: Імпорт проекту
1. Відкрити **Godot Engine 4.3+**
2. Клікнути **"Import"**
3. Вибрати файл `godot-project/project.godot`
4. Клікнути **"Import & Edit"**

### Крок 1.2: Перевірити структуру
У File System ліворуч ти побачиш:
```
res://
├── scenes/
├── scripts/
├── assets/
├── data/
└── addons/
```

✅ **Якщо все є — проект завантажився успішно!**

---

## 2. Налаштування Autoload

⚠️ **ЦЕ КРИТИЧНО! Без цього нічого не працюватиме!**

### Крок 2.1: Відкрити налаштування
**Project → Project Settings → Autoload**

### Крок 2.2: Додати менеджери (по черзі)

**1. GameManager:**
- Path: `res://scripts/core/game_manager.gd`
- Node Name: `GameManager`
- ✅ Enable
- Клікнути **Add**

**2. QuestManager:**
- Path: `res://scripts/core/quest_manager.gd`
- Node Name: `QuestManager`
- ✅ Enable
- Клікнути **Add**

**3. ReputationManager:**
- Path: `res://scripts/core/reputation_manager.gd`
- Node Name: `ReputationManager`
- ✅ Enable
- Add

**4. DialogueManager:**
- Path: `res://scripts/core/dialogue_manager.gd`
- Node Name: `DialogueManager`
- Add

**5. SaveManager:**
- Path: `res://scripts/core/save_manager.gd`
- Node Name: `SaveManager`
- Add

**6. InventoryManager:**
- Path: `res://scripts/core/inventory_manager.gd`
- Node Name: `InventoryManager`
- Add

**7. CombatManager:**
- Path: `res://scripts/core/combat_manager.gd`
- Node Name: `CombatManager`
- Add

**8. WeatherManager:**
- Path: `res://scripts/core/weather_manager.gd`
- Node Name: `WeatherManager`
- Add

### Крок 2.3: Перевірити
У вкладці **Autoload** маєш бачити всі 8 менеджерів.

✅ **Закрити Project Settings** (кнопка Close)

---

## 3. Створення Player сцени

### Крок 3.1: Нова сцена
1. **Scene → New Scene**
2. Вибрати **"Other Node"**
3. Знайти і вибрати **CharacterBody3D**
4. Rename node на **"Player"**

### Крок 3.2: Додати компоненти

**Структура:**
```
Player (CharacterBody3D)
├── CollisionShape3D
├── CameraPivot (Node3D)
│   └── Camera3D
├── MeshInstance3D (placeholder)
└── HealthComponent (Node)
```

**Як додати:**
1. **CollisionShape3D:**
   - Клік правою на Player → Add Child Node
   - Вибрати **CollisionShape3D**
   - У Inspector → Shape → New CapsuleShape3D
   - Налаштувати розмір: Height=2, Radius=0.5

2. **CameraPivot:**
   - Add Child Node → **Node3D**
   - Rename на "CameraPivot"
   - Position: (0, 1.5, 0)

3. **Camera3D:**
   - Клік правою на CameraPivot → Add Child Node
   - Вибрати **Camera3D**
   - Position: (0, 0.5, 3) — камера за спиною
   - Rotation: (-10, 0, 0)

4. **MeshInstance3D (тимчасово):**
   - Add Child Node → **MeshInstance3D**
   - Inspector → Mesh → New CapsuleMesh
   - Size: Height=2, Radius=0.5

5. **HealthComponent:**
   - Add Child Node → **Node**
   - Rename на "HealthComponent"
   - Клікнути на node
   - Inspector → Script → Attach Script
   - Path: вибрати `res://scripts/gameplay/health_component.gd`
   - **Load** (не Create!)

### Крок 3.3: Прикріпити PlayerController
1. Клікнути на **Player** (root node)
2. Inspector → Script → **Attach Script**
3. Path: вибрати `res://scripts/gameplay/player_controller.gd`
4. **Load**

### Крок 3.4: Налаштувати параметри
У Inspector побачиш export змінні:
- Walk Speed: `3.0`
- Run Speed: `5.0`
- Sprint Speed: `7.0`
- Mouse Sensitivity: `0.002`

### Крок 3.5: Додати до групи
1. Клікнути на Player node
2. **Node → Groups**
3. Написати `player`
4. Клікнути **Add**

### Крок 3.6: Зберегти сцену
- **Scene → Save Scene**
- Path: `res://scenes/characters/Player.tscn`
- Save

✅ **Player готовий!**

---

## 4. Створення тестової локації

### Крок 4.1: Нова 3D сцена
1. **Scene → New Scene**
2. **3D Scene** (автоматично створить Node3D)
3. Rename на **"TestLevel"**

### Крок 4.2: Додати підлогу
1. Add Child → **StaticBody3D**
2. Rename на "Floor"

**Додати CollisionShape:**
- Add Child до Floor → **CollisionShape3D**
- Shape → New BoxShape3D
- Size: (50, 0.5, 50)

**Додати візуал:**
- Add Child до Floor → **MeshInstance3D**
- Mesh → New BoxMesh
- Size: (50, 0.5, 50)
- Material → New StandardMaterial3D
- Albedo Color: сірий

### Крок 4.3: Додати світло
1. Add Child до TestLevel → **DirectionalLight3D**
2. Position: (0, 10, 0)
3. Rotation: (-45, -30, 0)
4. Energy: 1.0

### Крок 4.4: Додати Environment
1. Add Child → **WorldEnvironment**
2. Environment → New Environment
3. Background → Sky → New Sky
4. Sky Material → New ProceduralSkyMaterial

### Крок 4.5: Додати гравця
1. **Scene → Open Scene** → вибрати `Player.tscn`
2. **Scene → New Inherited Scene**
3. Назва: TestLevel
4. У TestLevel: правою кнопкою → **Instantiate Child Scene**
5. Вибрати `res://scenes/characters/Player.tscn`
6. Position гравця: (0, 2, 0)

### Крок 4.6: Зберегти
- Save Scene → `res://scenes/environments/TestLevel.tscn`

### Крок 4.7: Тест!
- **Клікнути F6** (Play Scene) або кнопку ▶️
- **WASD** — рух
- **Shift** — спринт
- **Mouse** — камера
- **ESC** — курсор

✅ **Якщо ходиш — все працює!**

---

## 5. Створення NPC з діалогами

### Крок 5.1: Створити NPC сцену
1. New Scene → **CharacterBody3D**
2. Rename на **"NPC_Kelm"**

**Структура:**
```
NPC_Kelm (CharacterBody3D)
├── CollisionShape3D (CapsuleShape)
├── MeshInstance3D (placeholder)
├── InteractionArea (Area3D)
│   └── CollisionShape3D (SphereShape)
└── Label3D (name tag)
```

### Крок 5.2: Створити скрипт NPC

Клікнути на NPC_Kelm → Attach Script → Create New:

```gdscript
extends CharacterBody3D

@export var npc_id: String = "kelm"
@export var npc_name: String = "Серіт Келм"
@export var dialogue_file: String = "kelm/first_meeting"

@onready var interaction_area = $InteractionArea
@onready var name_label = $Label3D

var player_in_range: bool = false

func _ready():
	name_label.text = npc_name
	
	# Підключити сигнали Area3D
	interaction_area.body_entered.connect(_on_body_entered)
	interaction_area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		print("Press E to talk to %s" % npc_name)

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false

func _input(event):
	if event.is_action_pressed("interact") and player_in_range:
		start_dialogue()

func start_dialogue():
	print("Starting dialogue with %s" % npc_name)
	DialogueManager.start_dialogue(npc_id, dialogue_file)
```

### Крок 5.3: Налаштувати InteractionArea
1. Клікнути на **InteractionArea**
2. Add Child → **CollisionShape3D**
3. Shape → New SphereShape3D
4. Radius: `3.0`

### Крок 5.4: Додати Input Map
**Project → Project Settings → Input Map**

Додати action `interact`:
- Name: `interact`
- Key: **E**
- Add

### Крок 5.5: Зберегти NPC
- Save Scene → `res://scenes/characters/NPC_Kelm.tscn`

### Крок 5.6: Додати на TestLevel
1. Відкрити TestLevel.tscn
2. Instantiate Child Scene → NPC_Kelm.tscn
3. Position: (5, 1, 0)
4. Save

### Крок 5.7: Тестувати
- F6 → підійти до NPC → натиснути **E**
- В Output побачиш: "Starting dialogue with Серіт Келм"

✅ **NPC працює!**

---

## 6. Підключення квесту

### Крок 6.1: Завантажити квест при старті гри

Створити скрипт **GameStarter.gd**:

```gdscript
extends Node

func _ready():
	# Завантажити перший квест
	load_quest("greyford_01_missing_recipient")

func load_quest(quest_id: String):
	var path = "res://data/quests/%s.json" % quest_id
	
	if not FileAccess.file_exists(path):
		push_error("Quest file not found: " + path)
		return
	
	var file = FileAccess.open(path, FileAccess.READ)
	var json = JSON.new()
	var error = json.parse(file.get_as_text())
	file.close()
	
	if error != OK:
		push_error("Failed to parse quest JSON")
		return
	
	var quest_data = json.data
	QuestManager.start_quest(quest_data)
	print("Quest loaded: %s" % quest_data["title"])
```

### Крок 6.2: Додати до TestLevel
1. Відкрити TestLevel.tscn
2. Add Child → **Node**
3. Rename на "GameStarter"
4. Attach Script → вставити код вище
5. Save

### Крок 6.3: Тест
- F6 → в Output побачиш:
```
Quest started: Адресат відсутній
```

✅ **Квести працюють!**

---

## 7. Тестування репутації

### Крок 7.1: Консоль для тестування

Додати в PlayerController (_ready):

```gdscript
func _input(event):
	# Debug: тестувати репутацію
	if event.is_action_pressed("ui_text_completion_accept"):  # Tab
		test_reputation()

func test_reputation():
	print("=== Reputation Test ===")
	ReputationManager.modify_reputation("greyford", 10)
	ReputationManager.modify_reputation("knives", -5)
	
	print("Greyford: %d (%s)" % [
		ReputationManager.get_reputation("greyford"),
		ReputationManager.get_faction_attitude("greyford")
	])
	print("Knives: %d (%s)" % [
		ReputationManager.get_reputation("knives"),
		ReputationManager.get_faction_attitude("knives")
	])
```

### Крок 7.2: Тест
- F6 → натиснути **Tab**
- Output:
```
=== Reputation Test ===
Reputation changed: greyford [0 -> 10] (+10)
Greyford: 10 (Neutral)
Knives: -5 (Neutral)
```

✅ **Репутація працює!**

---

## 8. Додавання нового квесту

### Крок 8.1: Створити JSON файл

`res://data/quests/my_custom_quest.json`:

```json
{
  "id": "my_custom_quest",
  "title": "Мій перший квест",
  "description": "Тестовий квест для навчання",
  "objectives": [
    {
      "id": "talk_to_npc",
      "description": "Поговорити з Келмом",
      "type": "talk",
      "target": "kelm",
      "count": 1
    },
    {
      "id": "collect_item",
      "description": "Зібрати 3 болотні трави",
      "type": "collect",
      "target": "item_swamp_reed",
      "count": 3
    }
  ],
  "rewards": {
    "experience": 100,
    "reputation": {
      "greyford": 5
    },
    "items": [
      {"id": "item_silver_coin", "count": 50}
    ]
  }
}
```

### Крок 8.2: Завантажити його
У GameStarter.gd додати:
```gdscript
load_quest("my_custom_quest")
```

✅ **Твій квест у грі!**

---

## 9. Combat: створення ворога

### Крок 9.1: Створити Enemy сцену
1. New Scene → **CharacterBody3D**
2. Rename на "Enemy_Bandit"

**Структура:**
```
Enemy_Bandit
├── CollisionShape3D
├── MeshInstance3D
├── HealthComponent
└── NavigationAgent3D
```

### Крок 9.2: Прикріпити AI скрипт
- Attach Script → `res://scripts/gameplay/enemy_ai.gd` (Load)

### Крок 9.3: Налаштувати параметри
- Max Health: `50`
- Move Speed: `3.5`
- Attack Range: `2.0`
- Detection Range: `10.0`
- Attack Damage: `15`

### Крок 9.4: Додати на рівень
- Position: (10, 1, 0)

### Крок 9.5: Тест
- F6 → підійти до ворога
- Він почне тебе переслідувати!

✅ **AI працює!**

---

## 10. UI: підключення HUD

### Крок 10.1: Створити HUD сцену
1. New Scene → **Control** (UI)
2. Rename на "HUD"

**Додати:**
- **Label** (top-left) — для HP
- **Label** (top-right) — для квестів

### Крок 10.2: Скрипт HUD

```gdscript
extends Control

@onready var health_label = $HealthLabel
@onready var quest_label = $QuestLabel

func _ready():
	update_health(100, 100)

func _process(delta):
	# Оновлювати UI кожен кадр
	pass

func update_health(current: float, max: float):
	health_label.text = "HP: %.0f / %.0f" % [current, max]

func update_quest(text: String):
	quest_label.text = text
```

✅ **UI готовий!**

---

## 🎉 Вітаю! Ти пройшов tutorial!

### Що ти вмієш:
- ✅ Відкривати проект
- ✅ Налаштовувати Autoload
- ✅ Створювати Player
- ✅ Створювати NPC з діалогами
- ✅ Підключати квести
- ✅ Тестувати репутацію
- ✅ Додавати нових ворогів
- ✅ Створювати UI

### Наступні кроки:
1. Створити більше NPC
2. Додати більше квестів
3. Створити Greyford локацію
4. Додати анімації
5. Створити інвентар UI

**Успіхів у розробці Hazemoor! 🌿💀**
