# 🌍 Динамічний Світ — Живі Події

## Концепція
Світ Хейзмуру не стоїть на місці. Події відбуваються навіть коли гравець далеко. Деякі з них гравець може пропустити, інші — чекають на нього.

## Глобальний Таймер

```gdscript
class_name WorldEventSystem

enum EVENT_TYPE {
    NATURE,        # Природні явища
    NPC_ACTION,    # Дії населення
    CULT_ACTIVITY, # Активність культу
    TRADE,         # Торгівля
    DISASTER,      # Катастрофи
    MYSTERY        # Таємничі події
}

enum EVENT_STATUS {
    UPCOMING,
    ACTIVE,
    COMPLETED,
    FAILED,
    PREVENTED
}

var event_calendar: Dictionary = {}
var active_events: Array = []
var world_time: float = 0.0
```

## Розклад Подій

### Щоденні Події
```gdscript
func generate_daily_events():
    var today_events = []
    
    # Базові події щоранку
    today_events.append({
        "type": EVENT_TYPE.NPC_ACTION,
        "name": "Ринок відкривається",
        "time": "06:00",
        "location": "Greyford Market",
        "effects": {
            "merchants": "active",
            "prices": "normal"
        }
    })
    
    today_events.append({
        "type": EVENT_TYPE.NPC_ACTION,
        "name": "Варта змінюється",
        "time": "08:00/20:00",
        "location": "All Cities",
        "effects": {
            "guard_count": "changes",
            "patrol_routes": "new"
        }
    })
    
    # Випадкові щоденні події
    if randf() < 0.3:
        today_events.append(random_event())
    
    return today_events
```

### Тижневі Події
```gdscript
var weekly_events = [
    {
        "name": "Великий ярмарок",
        "day": 3,  # Середа
        "location": "Valkorn Plaza",
        "duration": 2.0,  # 2 дні
        "loot_bonus": 1.5,  # x1.5 до торгових цін
        "special": "Приїжджий торговець рідкісними товарами"
    },
    {
        "name": "Ніч Моура",
        "day": 6,  # Субота
        "location": "All Swamps",
        "duration": 1.0,
        "effects": {
            "corruption_rate": "x2",
            "moor_power": "+50%",
            "rare_mobs": "spawn"
        },
        "warning": "Уникати боліт цієї ночі!"
    },
    {
        "name": "Судний день",
        "day": 7,  # Неділя
        "location": "Greyford Cathedral",
        "duration": 0.5,  # Півдня
        "effects": {
            "reputation_change": "x1.5",
            "quest_rewards": "+25%"
        }
    }
]
```

### Місячні Події
```gdscript
var monthly_events = [
    {
        "name": "Повний місяць",
        "phase": "full_moon",
        "duration": 3.0,
        "effects": {
            "magic_power": "+30%",
            "werewolves": "spawn",
            "visibility": "reduced"
        }
    },
    {
        "name": "Місяць тіней",
        "phase": "new_moon",
        "duration": 3.0,
        "effects": {
            "stealth": "+50%",
            "shadow_magic": "+40%",
            "night_vision": "required"
        }
    },
    {
        "name": "Зміна сезону",
        "phase": "season_change",
        "duration": 1.0,
        "effects": {
            "weather": "changes",
            "mob_types": "change",
            "resources": "renew"
        }
    }
]
```

## Випадкові Події

```gdscript
func random_event():
    var events_pool = [
        # Природні
        {
            "name": "Болотяний туман",
            "type": EVENT_TYPE.NATURE,
            "probability": 0.15,
            "effects": {
                "visibility": -70,
                "lost_chance": 0.1,
                "mysterious_encounters": true
            },
            "duration": randi_range(2, 6)  # годин
        },
        {
            "name": "Землетрус",
            "type": EVENT_TYPE.DISASTER,
            "probability": 0.02,
            "effects": {
                "buildings_damage": "possible",
                "new_passages": "open",
                "enemies_scatter": true
            },
            "duration": 0.1  # 6 хвилин
        },
        
        # Дії NPC
        {
            "name": "Набіг розбійників",
            "type": EVENT_TYPE.NPC_ACTION,
            "probability": 0.1,
            "effects": {
                "merchants_flee": true,
                "guards_busy": true,
                "loot_scattered": true
            },
            "duration": 2.0,
            "reward": "Можна врятувати караван"
        },
        {
            "name": "Культ жертвує",
            "type": EVENT_TYPE.CULT_ACTIVITY,
            "probability": 0.08,
            "effects": {
                "moor_power": "+10",
                "cult_presence": "increased",
                "disappearances": true
            },
            "duration": 1.0
        },
        
        # Таємничі
        {
            "name": "Примарний караван",
            "type": EVENT_TYPE.MYSTERY,
            "probability": 0.03,
            "effects": {
                "ethereal_goods": true,
                "soul_debt": "possible",
                "unique_loot": true
            },
            "duration": 0.5
        }
    ]
    
    return weighted_random(events_pool)
```

## Система Наслідків

```gdscript
func process_event_outcomes(event):
    match event.name:
        "Набіг розбійників":
            if not player_intervened:
                # Світ змінюється
                Greyford.merchant_count -= 2
                Greyford.economy -= 15
                Greyford.guard_count += 5
                quest_available("Помста за караван")
            else:
                Greyford.reputation += 20
                Greyford.economy += 10
                reward_player(event.reward)
        
        "Культ жертвує":
            if not player_intervened:
                MoorCorruptionSystem.corruption_level += 15
                cult_influence += 5
                spawn_cultists(3)
            else:
                cult_influence -= 10
                reputation_all += 5
```

## Глобальні Зміни

### Економіка
```gdscript
func update_economy():
    for city in world_cities:
        var base_price = city.base_prices.duplicate()
        
        # Вплив подій
        for event in active_events:
            if event.location == city.name:
                base_price = apply_event_prices(base_price, event)
        
        # Вплив сезону
        match current_season:
            "spring": base_price.food *= 0.8
            "autumn": base_price.weapons *= 0.9
            "winter": base_price.resources *= 1.3
        
        city.current_prices = base_price
```

### Населення
```gdscript
func update_population():
    for city in world_cities:
        # Природний приріст
        city.population += randi_range(-5, 10)
        
        # Події впливають
        for event in active_events:
            if event.type == EVENT_TYPE.DISASTER:
                city.population -= randi_range(10, 50)
            elif event.type == EVENT_TYPE.TRADE:
                city.population += randi_range(5, 20)
        
        # Неможливо нижче 0
        city.population = max(0, city.population)
```

### Репутація
```gdscript
func update_reputation_globally():
    for faction in ReputationSystem.faction_standing:
        # Пасивні зміни
        if faction == "Muri":
            ReputationSystem.faction_standing[faction] += 0.5  # Моур завжди зростає
        elif faction == "Smugglers" and world_event("guard_patrol"):
            ReputationSystem.faction_standing[faction] -= 1  # Втрачають вплив
```

## Візуальне Відображення

```gdscript
class WorldEventUI:
    func show_event_calendar():
        # Інтерфейс календаря
        var calendar = preload("res://ui/world_calendar.tscn").instantiate()
        calendar.add_child(create_month_view())
        calendar.add_child(create_event_list())
        
        # Іконки подій
        for event in upcoming_events:
            var icon = TextureRect.new()
            icon.texture = load("res://ui/events/" + event.icon + ".png")
            icon.tooltip_text = event.name + "\n" + event.description
            calendar.add_child(icon)
    
    func show_active_events():
        # Список активних подій на HUD
        var panel = preload("res://ui/events_panel.tscn").instantiate()
        for event in active_events:
            var entry = HBoxContainer.new()
            entry.add_child(TextureRect.new())
            entry.add_child(Label.new(event.name))
            entry.add_child(ProgressBar.new(event.time_left / event.duration))
            panel.add_child(entry)
```

## Спеціальні Події (Квести)

```gdscript
var special_quest_events = [
    {
        "name": "Чума на селище",
        "trigger": "after_week_2",
        "description": "Тихий Шелест охоплює моровиця",
        "choices": [
            {
                "text": "Допомогти жителям",
                "result": "Greyford +20, ресурси -50",
                "quest": "Ліки для селища"
            },
            {
                "text": "Заробити на чумі",
                "result": "Gold +200, Muri -30",
                "quest": "Чорний ринок ліків"
            },
            {
                "text": "Ігнорувати",
                "result": "Селище зникає через тиждень"
            }
        ]
    },
    {
        "name": "Війна фракцій",
        "trigger": "moor_corruption_>_60",
        "description": "Моур стравлює фракції між собою",
        "choices": [
            {"text": "Миротворець", "result": "Всі +10, складно"},
            {"text": "Підтримати Валькорн", "result": "Valkorn +30, інші -20"},
            {"text": "Підтримати Грейфорд", "result": "Greyford +30, інші -20"}
        ]
    }
]
```

## Технічна Реалізація

```gdscript
# Основний цикл
func _process(delta):
    world_time += delta * time_scale
    
    # Перевірка розкладу
    check_schedule()
    
    # Генерація випадкових подій
    if randf() < event_chance * delta:
        trigger_random_event()
    
    # Оновлення активних подій
    update_active_events(delta)
    
    # Глобальні зміни
    if world_time % 3600 < delta:  # Кожну годину
        update_economy()
        update_population()
        update_reputation_globally()

func check_schedule():
    var hour = get_hour()
    var day = get_day()
    var week = get_week()
    
    # Перевірка щоденних
    for event in today_schedule:
        if event.time == hour:
            trigger_event(event)
    
    # Перевірка тижневих
    if hour == 0 and day == weekly_events[day].day:
        trigger_event(weekly_events[day])
    
    # Перевірка місячних
    if hour == 0 and day == 1:
        trigger_event(monthly_events[current_month])
```
