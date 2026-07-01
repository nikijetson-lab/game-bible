# 💬 Система Розгалужених Діалогів

## Базова Структура

```gdscript
class DialogueNode:
    var id: String
    var speaker: String
    var text: String
    var choices: Array[Choice]
    var conditions: Dictionary  # репутація, квести, предмети
    var on_enter: Callable      # при вході в ноду
    var on_exit: Callable       # при виході
```

## Типи Діалогів

### 1. Лінійний Діалог (NPC-інформатор)
```
NPC: "Чув я про Затоплену Обитель..."
→ Гравець: "Розкажи більше."
NPC: "Там водяться привиди..."
→ Гравець: "Дякую за інформацію."
[Кінець]
```

### 2. Розгалужений (Моральний вибір)
```
NPC: "Схопили контрабандиста. Що робити?"
├── "Стратити негайно!"
│   → Репутація: Валькорн +10, Контрабандисти -20
│   → Квест: "Поховати тіло"
└── "Відпустити."
    → Репутація: Контрабандисти +15
    → Квест: "Зустрітися з лідером контрабандистів"
    → NPC_Status: hostile (15 хв)
```

### 3. Динамічний (Залежить від стану світу)
```gdscript
func get_npc_dialogue():
    var reputation = ReputationSystem.get_faction("greyford")
    var completed_quests = QuestSystem.completed_ids
    var time = GameManager.time_of_day
    
    # Ніч — інші діалоги
    if time > 20 || time < 6:
        return night_phrases()
    
    # Репутація впливає
    if reputation > 50:
        return friendly_phrases()
    elif reputation < -30:
        return hostile_phrases()
    
    return neutral_phrases()
```

## Система Перевірок

### Умови для Варіантів
```gdscript
class ChoiceCondition:
    var requires_item: String     # "moor_tear"
    var requires_reputation: Dictionary  # {"greyford": 30, "valkorn": -10}
    var requires_quest: String    # "completed:q_01"
    var requires_level: int       # 5
    var requires_gold: int        # 500
    var requires_stat: Dictionary # {"strength": 10, "intelligence": 8}

func is_available(player: Player) -> bool:
    # Перевіряє всі умови
    for condition in conditions:
        if not condition.check(player):
            return false
    return true
```

### Відображення
```gdscript
func display_choices():
    for choice in current_node.choices:
        if choice.conditions.is_available(player):
            # Показати варіант
            if not choice.conditions.met_requirements(player):
                # Затемнений, з підписом "Потрібно: Сила 10"
                choice.button.modulate = Color.GRAY
                choice.button.tooltip = "Потрібно: " + choice.conditions.unmet_reason()
            else:
                # Яскравий, доступний
                choice.button.modulate = Color.WHITE
```

## Емоції NPC

### Система Настрою
```gdscript
enum NPC_MOOD {
    FRIENDLY,   # Зелений підсвітка
    NEUTRAL,    # Сірий
    ANGRY,      # Червоний
    FEARFUL,    # Фіолетовий
    SAD,        # Синій
    CRAZY,      # Жовтий (зсув тексту)
    BLESSED,    # Золотий
    CURSED      # Чорний з зеленим
}

# Вплив на діалоги
func apply_mood_to_text(text: String, mood: NPC_MOOD) -> String:
    match mood:
        NPC_MOOD.FRIENDLY:
            return text.replace(".", "!").replace("?", "?!")
        NPC_MOOD.ANGRY:
            return text.to_upper()
        NPC_MOOD.CRAZY:
            return shuffle_letters(text)
        NPC_MOOD.FEARFUL:
            return text + "..." + " Будь ласка, не робіть мені шкоди..."
        NPC_MOOD.SAD:
            return "..." + text + "..." + " (зітхає)"
```

## Запис Розмов

```gdscript
# Журнал діалогів
class DialogueLog:
    var history: Array = []
    
    func log(node: DialogueNode, choice: String):
        history.append({
            "time": Time.get_unix(),
            "speaker": node.speaker,
            "line": node.text,
            "player_choice": choice,
            "location": GameManager.current_location
        })
    
    # Для повторних діалогів
    func get_summary() -> String:
        var result = ""
        for entry in history.slice(-10):  # Останні 10
            result += entry.speaker + ": " + entry.line + "\n"
        return result
```

## Візуальний Стиль

### HUD Діалогу
```
┌──────────────────────────────┐
│  [Портрет NPC]               │
│  Ім'я: Старий Мурі          │
│  Настрій: 😠 (Злий)         │
├──────────────────────────────┤
│  "Ти прийшов по мою душу?"  │
├──────────────────────────────┤
│  [1] "Ні, я просто хочу...  │
│  [2] "Так, готуйся!" ✗     │
│  [3] "Хто ти?"              │
│  [4] [Сховати зброю]        │
└──────────────────────────────┘
```

## Спеціальні Діалоги

### Шепіт Моура (спотворення)
```gdscript
# Коли рівень спотворення > 50, діалоги змінюються
func apply_corruption_to_dialogue(text: String) -> String:
    if MoorCorruption.corruption_level > 75:
        return random_fake_dialogue()  # Повна маячня
    elif MoorCorruption.corruption_level > 50:
        return text.replace("допомога", "жертва").replace("друг", "ворог")
    else:
        return text  # Нормально
```

### Діалоги-Події
```gdscript
# Діалоги, що змінюють світ
func create_event_dialogue():
    var event = DynamicWorld.get_current_event()
    
    match event:
        DynamicWorld.Events.SWAMP_BLOOM:
            return DialogueEvent("Болото цвіте! Треба знайти протиотруту...")
        DynamicWorld.Events.MOOR_AWAKENING:
            return DialogueEvent("Земля трясеться! Втікайте до храму!")
        DynamicWorld.Events.BANDIT_RAID:
            return DialogueEvent("Розбійники напали на селище! Терміново!")
```
