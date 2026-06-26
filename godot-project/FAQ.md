# FAQ — Hazemoor Godot Project
## Часті питання та вирішення проблем

---

## 🔧 Налаштування

### Q: Як відкрити проект?
**A:** Godot → Import → вибрати `godot-project/project.godot` → Import & Edit

### Q: Autoload не знаходить скрипти!
**A:** Перевір що шлях починається з `res://`:
```
res://scripts/core/game_manager.gd
```
Якщо файл не знаходиться — перевір чи існує файл у файловій системі.

### Q: Скільки Autoload треба додавати?
**A:** 8 менеджерів (список у QUICKSTART.md). Всі обов'язкові!

---

## 🎮 Геймплей

### Q: Player не рухається!
**A:** Перевір:
1. Чи є `player_controller.gd` прикріплений до Player?
2. Чи налаштовані Input Actions (move_forward, move_back, etc.)?
3. Чи є CollisionShape3D?

### Q: Камера не обертається мишою!
**A:** Курсор має бути захоплений. У `player_controller.gd` є `Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)`.

Якщо курсор не ховається — натисни **ESC** двічі.

### Q: Player проваліється крізь підлогу!
**A:** Підлога має мати:
- StaticBody3D (або RigidBody3D)
- CollisionShape3D з Shape (BoxShape/etc)

### Q: NPC не реагує на E!
**A:** Перевір:
1. Чи є Input Action `interact` (E key)?
2. Чи є InteractionArea (Area3D) у NPC?
3. Чи Player в групі "player"?

---

## 📜 Квести

### Q: Квест не завантажується!
**A:** Перевір:
1. Чи файл є: `res://data/quests/<quest_id>.json`
2. Чи JSON валідний (без синтаксичних помилок)
3. В Output Console будуть помилки парсингу

### Q: Як стартувати квест?
**A:**
```gdscript
var quest_file = FileAccess.open("res://data/quests/greyford_01.json", FileAccess.READ)
var json = JSON.new()
json.parse(quest_file.get_as_text())
QuestManager.start_quest(json.data)
```

### Q: Objective не оновлюється!
**A:**
```gdscript
QuestManager.update_objective("quest_id", "objective_id", 1)
```
Перевір що `quest_id` та `objective_id` точно співпадають з JSON.

---

## 🗨️ Діалоги

### Q: Dialogue не показується!
**A:** DialogueManager.start_dialogue() тільки **завантажує** діалог. Треба створити UI для показу тексту.

Приблизна структура UI:
```
DialogueUI (Control)
├── Panel (background)
├── Label (speaker name)
├── RichTextLabel (dialogue text)
└── VBoxContainer (choice buttons)
```

### Q: Як підключити діалог до NPC?
**A:** У NPC скрипті:
```gdscript
func start_dialogue():
    DialogueManager.start_dialogue("kelm", "first_meeting")
```

### Q: Choices не працюють!
**A:** Підпишись на сигнал:
```gdscript
DialogueManager.choice_selected.connect(_on_choice_selected)

func _on_choice_selected(choice_id, consequences):
    print("Selected: ", choice_id)
    # Застосувати consequences
```

---

## ⚔️ Combat

### Q: Урон не наноситься!
**A:** Перевір:
1. Чи є HealthComponent у цілі?
2. Чи CombatManager у Autoload?
3. Викликай:
```gdscript
CombatManager.deal_damage(self, target, 20, CombatManager.DamageType.PHYSICAL)
```

### Q: Enemy не атакує!
**A:** Перевір:
1. Чи Player у групі "player"?
2. Чи detection_range достатньо великий?
3. Output Console: `enemy_ai.gd` логує "detected player!"

### Q: Health bar не оновлюється!
**A:** Підпишись на сигнал:
```gdscript
health_component.health_changed.connect(_on_health_changed)

func _on_health_changed(old, new):
    health_bar.value = new / health_component.max_health
```

---

## 🎨 UI

### Q: UI елементи не видно!
**A:** Control nodes мають бути дочірніми до CanvasLayer або Camera.

### Q: Button не клікається!
**A:** Перевір:
1. Mouse Filter = **Stop** (не Ignore або Pass)
2. Focus Mode = **All** (для keyboard navigation)

### Q: Label текст обрізаний!
**A:** Збільши розмір або увімкни **Autowrap**.

---

## 💾 Save/Load

### Q: Як зберегти гру?
**A:**
```gdscript
SaveManager.save_game(slot_index)  # 0-4
```

### Q: Як завантажити?
**A:**
```gdscript
SaveManager.load_game(slot_index)
```

### Q: Де зберігаються файли?
**A:** `user://saves/slot_X.save`

На Windows: `%APPDATA%/Godot/app_userdata/Hazemoor/saves/`

### Q: Мої дані не зберігаються!
**A:** SaveManager зберігає тільки:
- Player stats (HP, position)
- Quest progress
- Reputation
- Inventory

Якщо треба зберегти щось інше — додай в `SaveManager.save_game()`.

---

## 🌦️ Atmosphere

### Q: Як увімкнути дощ?
**A:**
```gdscript
WeatherManager.set_weather("rain", 0.8)  # intensity 0-1
```

### Q: Fog не видно!
**A:** Перевір WorldEnvironment:
- Environment → Fog → Enabled
- Fog Density (виставляється через WeatherManager)

### Q: Музика не грає!
**A:** AudioStreamPlayer треба додати в сцену і play():
```gdscript
WeatherManager.play_ambience("tavern")
```

---

## 🐛 Debuging

### Q: Як подивитись логи?
**A:** Output Console (внизу редактора). Всі `print()` виводяться там.

### Q: Гра крешиться без помилок!
**A:** Перевір **Debugger → Errors** — там деталі.

### Q: Як дебажити скрипт?
**A:** Поставити **breakpoint** (клік зліва від номера лінії), запустити гру, коли код досягне breakpoint — зупиниться.

### Q: FPS низький!
**A:**
1. **Debug → FPS** показує поточний FPS
2. **Performance Monitor** — показує bottleneck
3. Зменш кількість MeshInstance, Lights, Particles

---

## 📂 Файли та структура

### Q: Де зберігати нові assets?
**A:**
- Models: `assets/models/`
- Textures: `assets/textures/`
- Audio: `assets/audio/`
- UI: `assets/ui/`

### Q: Як додати новий item?
**A:** Додати запис у `data/items/items_database.json`:
```json
{
  "id": "item_my_sword",
  "name": "Мій меч",
  "type": "weapon",
  ...
}
```

### Q: Як working directory працює?
**A:**
- `res://` — корінь проекту
- `user://` — user data folder (saves, config)

---

## ❓ Інше

### Q: Godot 4.2 підтримується?
**A:** Ні, тільки **4.3+**. Деякі функції (як Navigation) змінилися.

### Q: Чи можна використовувати C#?
**A:** Проект написаний на **GDScript**. C# можна додати, але треба перекомпілювати.

### Q: Multiplayer підтримується?
**A:** Ні, тільки single-player.

### Q: Mobile (Android/iOS)?
**A:** Можливо, але треба адаптувати UI та контроли (touch).

---

## 📚 Додаткові ресурси

- **Official Docs:** https://docs.godotengine.org/
- **GDScript Basics:** https://gdscript.com/
- **Community:** Godot Discord, Reddit /r/godot

---

**Не знайшов відповідь?** Пиши issue на GitHub! 🙋
