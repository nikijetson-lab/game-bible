# Hazemoor — Godot 4 Project

> **Dark Gothic Fantasy RPG**  
> Темна готична фентезі гра в світі Хейзмуру  
> **Engine:** Godot 4.3+  
> **Дата створення:** 26.06.2026

---

## 🎮 Про проект

Це **Godot 4** реалізація гри **Hazemoor** на основі дизайн-документів з `game-bible`.

**Поточний стан:** 🟡 Pre-production / Prototyping

---

## 📁 Структура проекту

```
godot-project/
├── project.godot           # Конфігурація Godot проекту
├── scenes/                 # Сцени (.tscn файли)
│   ├── characters/         # Персонажі (гравець, NPC)
│   ├── environments/       # Локації (Greyford, Hazemoor)
│   └── ui/                 # UI екрани
├── scripts/                # GDScript коди
│   ├── core/               # Ядро (менеджери, autoload)
│   │   ├── game_manager.gd
│   │   ├── quest_manager.gd
│   │   └── reputation_manager.gd
│   ├── gameplay/           # Геймплей системи
│   │   └── player_controller.gd
│   └── ui/                 # UI логіка
├── assets/                 # Ресурси
│   ├── models/             # 3D моделі (.glb, .gltf)
│   ├── textures/           # Текстури
│   ├── audio/              # Звуки та музика
│   └── ui/                 # UI графіка
└── addons/                 # Плагіни та розширення
```

---

## 🚀 Швидкий старт

### **1. Встановити Godot**
- Завантажити **Godot 4.3+** з [godotengine.org](https://godotengine.org/download)
- Версія: **Standard** (не Mono, якщо не потрібен C#)

### **2. Відкрити проект**
1. Запустити Godot Engine
2. Натиснути **Import**
3. Вибрати файл `project.godot` з цієї папки
4. Клікнути **Import & Edit**

### **3. Налаштувати Autoload (Singletons)**
Перейти в **Project → Project Settings → Autoload** і додати:

| Path | Node Name |
|------|-----------|
| `res://scripts/core/game_manager.gd` | GameManager |
| `res://scripts/core/quest_manager.gd` | QuestManager |
| `res://scripts/core/reputation_manager.gd` | ReputationManager |

Це зробить менеджери доступними глобально у всіх скриптах.

---

## 🎯 Поточні завдання (Phase 0-1)

### ✅ **Completed:**
- [x] Структура проекту
- [x] `game_manager.gd` (пауза, зміна сцен)
- [x] `player_controller.gd` (рух, камера)
- [x] `quest_manager.gd` (квести, цілі)
- [x] `reputation_manager.gd` (репутація з фракціями)
- [x] `dialogue_manager.gd` (система діалогів з розгалуженням)
- [x] `save_manager.gd` (збереження/завантаження)
- [x] `inventory_manager.gd` (інвентар, предмети, крафт)
- [x] Перший квест у JSON (`greyford_01_missing_recipient`)
- [x] Діалоги для Келма та Ервана
- [x] NPC database (Келм, Ерван)
- [x] Items database (11 предметів)

### ⬜ **TODO (Next Steps):**
- [ ] Створити сцену `Player.tscn` (CharacterBody3D)
- [ ] Тестова локація `TestLevel.tscn` (ProGridMap floor)
- [ ] Базова система діалогів `DialogueSystem.gd`
- [ ] Quest UI (HUD для відображення цілей)
- [ ] Reputation UI (екран фракцій)
- [ ] Save/Load система

---

## 🛠️ Системи

### **GameManager** (`scripts/core/game_manager.gd`)
Singleton для глобального управління грою.

**Функції:**
- `pause_game()` / `resume_game()`
- `change_scene(path: String)`
- `quit_game()`

**Використання:**
```gdscript
GameManager.pause_game()
GameManager.change_scene("res://scenes/environments/greyford.tscn")
```

---

### **QuestManager** (`scripts/core/quest_manager.gd`)
Система квестів з цілями та наслідками.

**Функції:**
- `start_quest(quest_data: Dictionary)`
- `update_objective(quest_id, objective_id, progress)`
- `complete_quest(quest_id)`

**Приклад квесту:**
```gdscript
var quest_data = {
	"id": "greyford_01",
	"title": "Адресат відсутній",
	"description": "Знайти Руфіна в Грейфорді",
	"objectives": [
		{
			"id": "talk_kelm",
			"description": "Поговорити з Келмом",
			"type": "talk",
			"target": "npc_kelm"
		}
	]
}

QuestManager.start_quest(quest_data)
QuestManager.update_objective("greyford_01", "talk_kelm", 1)
```

---

### **ReputationManager** (`scripts/core/reputation_manager.gd`)
Система репутації з 5 фракціями.

**Фракції:**
- `greyford` — Адміністрація Грейфорда
- `knives` — Орден Семи Кинджалів
- `keepers` — Ключники
- `muri` — Мурі (болотяни)
- `lightbearers` — Вартові

**Функції:**
- `modify_reputation(faction: String, amount: int)`
- `get_reputation(faction: String) -> int`
- `get_faction_attitude(faction: String) -> String`

**Використання:**
```gdscript
# Гравець допоміг Грейфорду
ReputationManager.modify_reputation("greyford", 10)

# Перевірити ставлення
if ReputationManager.is_friendly("muri"):
	print("Мурі дружні до вас!")
```

---

### **PlayerController** (`scripts/gameplay/player_controller.gd`)
Контролер руху гравця (third-person).

**Керування:**
- **WASD** — рух
- **Shift** — спринт
- **Space** — стрибок
- **Mouse** — обертання камери
- **ESC** — показати/сховати курсор

**Параметри (export):**
- `walk_speed`, `run_speed`, `sprint_speed`
- `mouse_sensitivity`
- `camera_distance`

---

## 🎨 Art Style & References

**Атмосфера:**
- Темна готика (Bloodborne, Darkest Dungeon)
- Болотяна містика (Witcher 3 Crookback Bog)
- Приглушені кольори, густий туман

**Освітлення:**
- Low-key lighting (темні тіні)
- Warm candlelight у інтер'єрах
- Cold blue-grey на вулиці

---

## 📚 Документація

**Game Design:**
- [WORLD-BIBLE.md](../WORLD-BIBLE.md) — лор світу
- [TECHNICAL-DESIGN.md](../TECHNICAL-DESIGN.md) — технічний дизайн
- [PRODUCTION-ROADMAP.md](../PRODUCTION-ROADMAP.md) — план розробки

**Квести:**
- [quests/](../quests/) — всі квести детально

---

## 🐛 Known Issues

- [ ] Player controller потребує анімацій
- [ ] Quest UI поки що не реалізовано
- [ ] Dialogue система в розробці

---

## 🤝 Contributing

**Workflow:**
1. Create feature branch: `git checkout -b feature/dialogue-system`
2. Commit changes: `git commit -m "Add dialogue bubble UI"`
3. Push: `git push origin feature/dialogue-system`
4. Create Pull Request на GitHub

---

## 📞 Контакти

**Team Lead:** nikijetson-lab  
**Repo:** [github.com/nikijetson-lab/game-bible](https://github.com/nikijetson-lab/game-bible)

---

**Let's build Hazemoor! 🌿💀**
