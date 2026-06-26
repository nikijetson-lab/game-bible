# 💀 Система Прокльонів та Благословень

## Як це працює
Гравець може отримувати прокльони та благословення через:
- Взаємодію з певними NPC
- Виконання/провал квестів
- Дослідження небезпечних зон
- Жертвоприношення
- Випадкові події

## Механіка

### Структура
```gdscript
class_name CurseBlessingSystem

enum TYPE { CURSE, BLESSING }
enum RARITY { COMMON, UNCOMMON, RARE, EPIC, LEGENDARY }

struct Effect {
    var id: String
    var type: TYPE
    var name: String
    var description: String
    var rarity: RARITY
    var duration: float  # -1 = permanent
    var modifiers: Dictionary
    var visual_effect: String
    var removal_condition: String
}

var active_effects: Dictionary = {}
```

### Накладання
```gdscript
func apply_effect(effect_id: String):
    var effect = EFFECTS_DATABASE[effect_id].duplicate()
    active_effects[effect_id] = {
        "effect": effect,
        "time_left": effect.duration,
        "stacks": 1
    }
    
    apply_modifiers(effect.modifiers)
    show_effect_notification(effect)
    spawn_visual_effect(effect.visual_effect)
```

---

## 📜 Прокльони

### Звичайні (Common)
| Назва | Ефект | Мінус | Зняття |
|-------|-------|-------|--------|
| **Тінь, що шепоче** | Чуєте шепіт померлих | -10% концентрації | Свята вода |
| **Важкі кроки** | +15% шуму руху | Шанс привернути ворогів | Змінити взуття |
| **Холодна шкіра** | Стійкість до вогню +10% | -10% до захисту | Зілля тепла |
| **Слабке око** | Нічне бачення | -5% точності вдень | Краплі звіробою |

### Незвичайні (Uncommon)
```gdscript
var uncommon_curses = {
    "blood_thirst": {
        "name": "Кровожерливість",
        "effect": "+15% шкоди мечем",
        "downside": "-1 HP кожні 30 секунд",
        "duration": 300.0,
        "removal": "Випити зілля спокою"
    },
    "moor_touch": {
        "name": "Дотик Моура",
        "effect": "Бачите невидимі сліди",
        "downside": "Вороги відчувають вас здалеку",
        "duration": 600.0,
        "removal": "Паломництво до храму"
    },
    "heavy_burden": {
        "name": "Тягар провини",
        "effect": "+20% ваги предметів",
        "downside": "-20% швидкості",
        "duration": -1.0,
        "removal": "Сповідь у Валькорні"
    }
}
```

### Рідкісні (Rare)
```gdscript
var rare_curses = {
    "rotten_flesh": {
        "name": "Гниюча плоть",
        "effect": "Отруйна аура (шкода 2 HP/с навколо)",
        "downside": "-30% лікування зіль",
        "duration": -1.0,
        "removal": "Жертва 500 HP вівтарю"
    },
    "soul_fragment": {
        "name": "Фрагмент душі",
        "effect": "+25% магічної шкоди",
        "downside": "-15% фізичного захисту",
        "duration": -1.0,
        "removal": "Знайти і знищити фрагмент"
    },
    "nightmare_vision": {
        "name": "Бачення жахів",
        "effect": "Бачите справжню сутність істот",
        "downside": "Періодичні галюцинації",
        "duration": 1200.0,
        "removal": "Сон у святому місці"
    }
}
```

### Епічні (Epic)
```gdscript
var epic_curses = {
    "eternal_hunger": {
        "name": "Вічний голод",
        "effect": "Можете їсти отруйну їжу",
        "downside": "Голод настає вдвічі швидше",
        "duration": -1.0,
        "removal": "З'їсти Плід Життя (квестовий предмет)"
    },
    "shadow_bound": {
        "name": "Пов'язаний з тінню",
        "effect": "Можете ховатися у тінях",
        "downside": "Сонячне світло завдає шкоди 1 HP/с",
        "duration": -1.0,
        "removal": "Ритуал розриву зв'язку"
    },
    "voice_of_dead": {
        "name": "Голос мертвих",
        "effect": "Розумієте мову померлих",
        "downside": "Мертві постійно з вами говорять",
        "duration": -1.0,
        "removal": "Запечатати вуха воском (назавжди -20% слуху)"
    }
}
```

### Легендарні (Legendary)
```gdscript
var legendary_curses = {
    "moor_ascension": {
        "name": "Вознесіння Моура",
        "effect": "+50% до всього урону, безсмертя на 10 секунд раз на день",
        "downside": "-100 до репутації з усіма фракціями",
        "duration": -1.0,
        "removal": "НЕМОЖЛИВО (стаєте частиною Моура)",
        "note": "Game Over — персонаж стає фінальним босом"
    },
    "eternal_watch": {
        "name": "Вічне спостереження",
        "effect": "Бачите всі секрети, знаєте всі відповіді",
        "downside": "Більше не можете прогресувати (знаєте все)",
        "duration": -1.0,
        "removal": "Реліз (видалення персонажа)"
    },
    "blood_curse": {
        "name": "Криваве прокляття роду",
        "effect": "Кожне вбивство дає +1 HP (макс +100)",
        "downside": "Всі NPC агресивні, магазини закриті",
        "duration": -1.0,
        "removal": "Вбити 1000 ворогів (автоматичне зняття)"
    }
}
```

---

## 🌟 Благословення

### Звичайні (Common)
| Назва | Ефект | Джерело |
|-------|-------|---------|
| **Легкий крок** | +10% швидкості руху | Благословення мандрівника |
| **Зір сови** | +15% дальності огляду | Перша ніч у безпеці |
| **Міцний сон** | +20% лікування від сну | Готель Валькорну |
| **Сила землі** | +5 фізичної шкоди | Відвідування кургану |

### Незвичайні (Uncommon)
```gdscript
var uncommon_blessings = {
    "moon_touched": {
        "name": "Дотик Місяця",
        "effect": "+20% магічної шкоди вночі",
        "source": "Молитися під повним місяцем",
        "duration": 300.0
    },
    "iron_will": {
        "name": "Залізна воля",
        "effect": "+15% стійкості до прокльонів",
        "source": "Перемогти внутрішнього демона",
        "duration": -1.0
    },
    "lucky_find": {
        "name": "Вдала знахідка",
        "effect": "Рідкісний лут випадає на 10% частіше",
        "source": "Знайти 4-листу конюшину в болоті",
        "duration": 600.0
    }
}
```

### Рідкісні (Rare)
```gdscript
var rare_blessings = {
    "phoenix_tear": {
        "name": "Сльоза Фенікса",
        "effect": "Один раз автоматичне воскресіння",
        "source": "Врятувати людину від смерті",
        "duration": -1.0,
        "note": "Витрачається після використання"
    },
    "nature_favor": {
        "name": "Прихильність природи",
        "effect": "Рослини не заважають руху",
        "source": "Посадити 10 дерев",
        "duration": 1800.0
    }
}
```

### Епічні (Epic)
```gdscript
var epic_blessings = {
    "guardian_angel": {
        "name": "Янгол-охоронець",
        "effect": "Автоматичний блок кожного 5-го удару",
        "source": "Завершити квест Віри",
        "duration": -1.0
    },
    "eternal_youth": {
        "name": "Вічна молодість",
        "effect": "Відновлення здоров'я поза боєм у 2 рази швидше",
        "source": "Купатися в джерелі молодості",
        "duration": -1.0
    }
}
```

### Легендарні (Legendary)
```gdscript
var legendary_blessings = {
    "gods_favor": {
        "name": "Прихильність Богів",
        "effect": "50% шанс уникнути смертельної шкоди",
        "source": "Принести в жертву найцінніше",
        "duration": -1.0
    },
    "world_soul": {
        "name": "Душа світу",
        "effect": "Розумієте мову всіх істот",
        "source": "Зібрати всі фрагменти душі",
        "duration": -1.0
    }
}
```

---

## ⚔️ Взаємодія з іншими системами

### Прокльони vs Бойова Система
```gdscript
func apply_combat_modifiers(damage: int, type: String):
    for effect_id in active_effects:
        var effect = active_effects[effect_id].effect
        
        # Кровожерливість
        if effect_id == "blood_thirst" and type == "melee":
            damage *= 1.15
            take_damage(1)  # HP cost
            
        # Фрагмент душі
        if effect_id == "soul_fragment" and type == "magic":
            damage *= 1.25
            physical_defense *= 0.85
    
    return damage
```

### Прокльони vs Moor Whispers
```gdscript
func corruption_interaction():
    # Деякі прокльони підсилюють спотворення
    if "shadow_bound" in active_effects:
        MoorCorruptionSystem.corruption_rate *= 1.5
    
    # І навпаки
    if MoorCorruptionSystem.corruption_level > 50:
        chance_to_get_cursed *= 2.0
```

### Благословення vs Репутація
```gdscript
func reputation_bonuses():
    if "nature_favor" in active_effects:
        ReputationSystem.faction_standing["Muri"] += 2  # Щоденний бонус
    if "moon_touched" in active_effects:
        ReputationSystem.faction_standing["Valkorn"] += 1
```

---

## 🖥️ UI Відображення

### Список активних ефектів
```gdscript
class EffectUI:
    func display_effects():
        # Прокльони — червоним, благословення — зеленим
        for effect_id in active_effects:
            var effect = active_effects[effect_id].effect
            var color = Color.RED if effect.type == TYPE.CURSE else Color.GREEN
            var icon = load("res://ui/effects/" + effect.id + ".png")
            var timer = effect.duration if effect.duration > 0 else ""
            
            draw_effect_entry(icon, effect.name, color, timer)
```

### Сповіщення
```gdscript
func show_effect_notification(effect):
    var notification = preload("res://ui/effect_notification.tscn").instantiate()
    notification.text = effect.name
    notification.modulate = Color.RED if effect.type == TYPE.CURSE else Color.GREEN
    notification.description = effect.description
    
    # Анімація появи
    notification.position = Vector2(400, -50)
    var tween = create_tween()
    tween.tween_property(notification, "position:y", 50, 0.5)
    tween.tween_interval(3.0)
    tween.tween_property(notification, "modulate:a", 0.0, 1.0)
    
    add_child(notification)
```
