# 🌫️ Moor Whispers — Система Спотворень

## Концепція
Коли репутація з фракцією Моура падає нижче -80, гравець починає "чути" болото. Це проявляється у вигляді галюцинацій, фальшивих NPC та викривлення реальності.

## Механіка

### Рівні Спотворення
```gdscript
enum CORRUPTION_LEVEL {
    WHISPERS = 1,      # Шепіт
    VISIONS = 2,       # Візії 
    MANIFESTATION = 3, # Явлення
    ASCENSION = 4      # Вознесіння
}
```

### Система Накопичення
```gdscript
class_name MoorCorruptionSystem

var corruption_level = 0  # 0-100
var current_effect = CORRUPTION_LEVEL.WHISPERS

func _process(delta):
    # Пасивне накопичення в болотах
    if GameManager.current_biome == "swamp":
        corruption_level += delta * 0.2
    # У містах — повільне зменшення
    elif GameManager.current_biome == "city":
        corruption_level = max(0, corruption_level - delta * 0.05)
    
    update_effects()

func update_effects():
    if corruption_level > 75:
        current_effect = CORRUPTION_LEVEL.ASCENSION
    elif corruption_level > 50:
        current_effect = CORRUPTION_LEVEL.MANIFESTATION
    elif corruption_level > 25:
        current_effect = CORRUPTION_LEVEL.VISIONS
    else:
        current_effect = CORRUPTION_LEVEL.WHISPERS
```

## Ефекти за Рівнями

### Рівень 1: Шепіт (0-25)
```gdscript
func whispers_effects():
    # Слухові галюцинації
    var messages = [
        "Вони брешуть...",
        "Не вір їм...",
        "Болото пам'ятає...",
        "Ти вже мертвий...",
        "Дивись під ноги..."
    ]
    
    # Випадковий шепіт кожні 30-60 секунд
    Timer.new().start(randi_range(30, 60))
    
    # Фальшиві звуки кроків
    if randf() < 0.1:
        Audio.play("fake_footsteps")
```

### Рівень 2: Візії (25-50)
```gdscript
func visions_effects():
    # Візуальні галюцинації
    var effects = [
        "objects_moving",        # Предмети рухаються
        "walls_breathing",       # Стіни дихають
        "blood_dripping",        # Кров капає зі стелі
        "faces_in_shadows",      # Обличчя в тінях
        "false_reflections"      # У дзеркалах — не те відображення
    ]
    
    # Випадкове спрацювання
    if randi() % 100 < 15:  # 15% шанс кожні 10 секунд
        trigger_vision(effects.pick_random())
```

### Рівень 3: Явлення (50-75)
```gdscript
func manifestation_effects():
    # Фальшиві NPC
    var fake_npcs = [
        {"name": "Мертвий Селянин", "dialogue": "Чому ти не врятував мене?"},
        {"name": "Тінь Дружини", "dialogue": "Ти обрав меч замість мене..."},
        {"name": "Вартовий, що вижив", "dialogue": "Ти заплатиш за свої злочини!"}
    ]
    
    # Спавн фальшивого NPC поруч
    spawn_fake_npc(fake_npcs.pick_random())
    
    # Вони зникають при дотику
    # Якщо гравець атакує — отримує -5 HP (самонавіювання)
```

### Рівень 4: Вознесіння (75-100)
```gdscript
func ascension_effects():
    # Повне викривлення реальності
    var effects = [
        "inverted_controls",     # Інверсія керування
        "fake_quests",           # Квести, яких не існує
        "duplicate_npcs",        # Копії NPC
        "map_misalignment",      # Карта показує інше місце
        "time_distortion",       # Годинник скаче
        "loot_illusions"         # Предмети, які зникають
    ]
    
    # Кожні 5 секунд — новий ефект
    time_distortion_cycle.start(5.0)
```

## Система Фальшивих Квестів

```gdscript
func generate_fake_quest():
    var fake_quests = [
        {
            "title": "Врятувати мою доньку",
            "giver": "Привид жінки",
            "objective": "Знайти дівчинку в лісі",
            "reality": "У лісі нікого немає"
        },
        {
            "title": "Знищити культ Моура",
            "giver": "Священник (якого ви вбили)",
            "objective": "Спалити вівтар",
            "reality": "Ви стоїте біля звичайного дерева"
        },
        {
            "title": "Забрати скарб",
            "giver": "Труп розбійника",
            "objective": "Відкрити скриню в печері",
            "reality": "У скрині — ваші власні речі"
        }
    ]
    
    var quest = fake_quests.pick_random()
    QuestSystem.add_quest(quest)
    # Через 5 хвилин квест зникає без сліду
    Timer.new().start(300.0).timeout = func(): QuestSystem.remove_quest(quest)
```

## Інтеграція з Іншими Системами

### З Моральними Виборами
```gdscript
func on_karma_decide(choice: String):
    match choice:
        "kill_innocent":
            corruption_level += 10
            spawn_vision("face_of_victim")
        "save_innocent":
            corruption_level -= 5
        "join_cult":
            corruption_level += 20
```

### З Живими Мечами
```gdscript
func sword_interaction():
    if corruption_level > 50:
        # Меч провокує гравця
        LivingSwordSystem.speak_line("Вони заслуговують на смерть...")
        # Меч дає +10% шкоди за кожні 25 рівня спотворення
        var bonus = floor(corruption_level / 25) * 0.1
        LivingSwordSystem.damage_bonus = bonus
```

### З Бойовою Системою
```gdscript
func combat_modifiers():
    match current_effect:
        CORRUPTION_LEVEL.WHISPERS:
            # 10% шанс промахнутися через галюцинації
            hit_chance *= 0.9
        CORRUPTION_LEVEL.VISIONS:
            # 20% шанс атакувати тінь
            if randf() < 0.2:
                attack_shadow()
        CORRUPTION_LEVEL.MANIFESTATION:
            # Фальшиві вороги завдають "шкоди"
            take_damage(randi_range(0, 5))
        CORRUPTION_LEVEL.ASCENSION:
            # Хаотичні ефекти
            random_combat_effect()
```

## Лікування Спотворення

### Способи Зменшення
```gdscript
func cure_methods():
    var methods = [
        {
            "name": "Свята вода",
            "effect": -15,
            "location": "Церква Валькорну",
            "cost": 100
        },
        {
            "name": "Спокута (вбити 5 культистів)",
            "effect": -20,
            "location": "Будь-де"
        },
        {
            "name": "Паломництво до Валькорну",
            "effect": -30,
            "location": "Головний храм",
            "duration": "24 години спокою"
        },
        {
            "name": "Знищити живий меч",
            "effect": -50,
            "location": "Ковадло Моура",
            "note": "Назавжди втрачаєте меч"
        }
    ]
    return methods
```

### Візуальні Індикатори
```python
# Колір екрану змінюється
# 0-25: нормальний
# 25-50: легкий сірий фільтр
# 50-75: червоний відтінок
# 75-100: чорно-білий з червоними сполохами

# UI спотворюється
# Кнопки рухаються
# Текст змінюється (випадкові літери)
# HP/MP показують неправильні значення
```
