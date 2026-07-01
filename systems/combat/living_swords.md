# 🗡️ Живі Мечі з Підсвіту (Living Blades of the Underworld)

## Концепція
Зброя, викута в Підсвіті з плоті та болотної крові. Меч — жива істота, яка росте разом із господарем.

## Характеристики

### Рівні Меча
| Рівень | Жертв | Сила | Ефект |
|--------|-------|------|-------|
| 1 (Зародок) | 0 | 5 | Базовий удар |
| 2 (Голодний) | 3 | 12 | +5% вампіризм |
| 3 (Спраглий) | 10 | 25 | +10% вампіризм, кривавий сплеск |
| 4 (Ненаситний) | 30 | 45 | +15% вампіризм, виклик тіні |
| 5 (Бог Війни) | 100 | 80 | +25% вампіризм, армія тіней |

### Система Годування
```gdscript
extends Node

class_name LivingSwordSystem

const SACRIFICE_TYPES = {
    "bandit": {"rep": 1, "faction": "any"},
    "guard": {"rep": 3, "faction": "Valkorn"},
    "innocent": {"rep": 5, "faction": "Greyford"},
    "player_hp": {"rep": 2, "cost": 50}  # 50 HP = 2 од. голоду
}

var hunger = 100  # 0 = ситий, 100 = голодний
var level = 1
var kills = 0

func _process(delta):
    # Меч голодніє з часом
    hunger = min(100, hunger + delta * 0.5)
    
    if hunger > 80:
        apply_debuff()  # -20% шкоди, випадкові крики
    elif hunger > 50:
        apply_penalty()  # -10% шкоди

func feed(target_type: String, target_faction: String = "any"):
    var data = SACRIFICE_TYPES.get(target_type)
    if not data: 
        return false
    
    if target_type == "player_hp":
        if GameManager.player_hp < data.cost:
            return false
        GameManager.player_hp -= data.cost
    
    hunger = max(0, hunger - data.rep * 15)
    kills += 1
    check_level_up()
    return true

func check_level_up():
    var new_level = 1
    for i in range(5, 0, -1):
        if kills >= [0, 3, 10, 30, 100][i-1]:
            new_level = i
            break
    
    if new_level > level:
        level = new_level
        apply_level_bonus()
```

### Візуальні Ефекти
- **Рівень 1-2**: Меч — це просто згусток плоті
- **Рівень 3-4**: З'являються очі на лезі, меч пульсує
- **Рівень 5**: Меч обростає щупальцями, має власну волю

### Випадкові Події
```gdscript
func random_event():
    var events = [
        {"chance": 0.05, "effect": "sword_scream", "text": "Меч пронизливо кричить!"},
        {"chance": 0.02, "effect": "sword_attack", "text": "Меч атакує союзника!"},
        {"chance": 0.01, "effect": "sword_talk", "text": "...вб...ива...й..."},
    ]
    
    for event in events:
        if randf() < event.chance:
            trigger_event(event)
            break
```

### Діалоги Меча (голос у голові)
- **Ситий**: "Смачна... кров..."
- **Голодний**: "Ж...ра...ти..."
- **Після вбивства**: "Ще... ще... ЩЕ!"
- **При зміні рівня**: "НАРЕШТІ... СИЛА..."

### Інтеграція з Квестом
```gdscript
# Коли меч досягає 3 рівня, активується квест "Кров для Болотяного Бога"
func on_level_three():
    QuestSystem.activate_quest("blood_for_moor_god")
    Events.emit_signal("sword_awakened")
```
