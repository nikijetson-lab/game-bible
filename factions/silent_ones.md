# 🤫 Мовчазні (The Silent Ones)

## Концепція
Давні істоти, що не говорять. Їхня мова — жести, символи та тиша. Вони існували ще до приходу людей у Хейзмур. Деякі вважають, що Мовчазні — перші діти Моура, які відмовились від голосу в обмін на знання.

## Зовнішність
```gdscript
var silent_ones_appearance = {
    "skin": "блідо-сіра, вкрита стародавніми рунами",
    "eyes": "білі без зіниць, світяться в темряві",
    "mouth": "назавжди закриті, зашиті чорною ниткою",
    "clothes": "довгі темні мантії з симолами мовчання",
    "height": "2.2-2.5 метра",
    "movement": "безшумний, плавний, ніби пливуть"
}
```

## Філософія
```markdown
### Принципи Мовчазних
1. **Слово — це брехня** (мовлення спотворює істину)
2. **Тиша — це правда** (лише в мовчанні пізнаєш суть)
3. **Жест — це дія** (рухи говорять більше за слова)
4. **Символ — це знання** (кожен знак має силу)
5. **Спостереження — це життя** (хто слухає — той існує)
```

## Розташування
```gdscript
var silent_ones_locations = [
    {
        "name": "Храм Тиші",
        "location": "Глибоко в болотах, прихований туманом",
        "access": "Тільки через Око Моура (рівень 3+)",
        "description": "Підземний храм з 7 залами, кожен присвячений аспекту мовчання"
    },
    {
        "name": "Стояння Каміння",
        "location": "На північ від Грейфорду",
        "access": "Відкритий для всіх",
        "description": "Коло з 12 менгірів, де Мовчазні залишають послання"
    },
    {
        "name": "Бібліотека Шепоту",
        "location": "Під Валькорном, катакомби",
        "access": "Тільки для запрошених",
        "description": "Зібрання знань Мовчазних, жодної книги зі словами"
    }
]
```

## Взаємодія

### Як Спілкуватись
```gdscript
class_name SilentOnesInteraction

enum GESTURE {
    GREETING,      # Піднята долоня
    THREAT,        # Стиснутий кулак
    QUESTION,      # Нахил голови
    AGREEMENT,     # Доторкнутись до грудей
    REFUSAL,       # Відвернутись
    GIFT,          # Простягнута рука
    THANKS,        # Поклон
    ANGER,         # Тупотіння ногою
    SADNESS,       # Опущені плечі
    KNOWLEDGE,     # Доторкнутись до чола
    SILENCE,       # Прикласти палець до губ
    FOLLOW         # Помахати рукою
}

func interact_with_silent_one(npc):
    # Спочатку гравець не знає жестів
    if not player.knows_gestures:
        npc.show_gesture_example()
        # Гравець може вивчити жест
        player.learn_gesture(npc.gesture_demonstrated)
    
    # Вибір жесту
    var player_gesture = show_gesture_menu()
    
    # Реакція NPC
    match player_gesture:
        GESTURE.GREETING:
            if npc.is_friendly():
                npc.respond(GESTURE.GREETING)
                ReputationSystem.faction_standing["SilentOnes"] += 2
            else:
                npc.ignore()
        GESTURE.GIFT:
            if player.gives_item():
                npc.respond(GESTURE.THANKS)
                npc.give_knowledge()
        GESTURE.THREAT:
            npc.respond(GESTURE.ANGER)
            ReputationSystem.faction_standing["SilentOnes"] -= 10
            # NPC йде геть
    ...
```

### Вивчення Мови Жестів
```gdscript
var gesture_progression = {
    "learner": {
        "known_gestures": 3,
        "understanding": 0.3,  # 30% розуміння
        "difficulty": "Базові жести (вітання, згода, відмова)"
    },
    "adept": {
        "known_gestures": 6,
        "understanding": 0.6,
        "difficulty": "Складні жести (питання, подяка, гнів)"
    },
    "master": {
        "known_gestures": 10,
        "understanding": 0.9,
        "difficulty": "Всі жести + символи"
    },
    "silent_one": {
        "known_gestures": 12,
        "understanding": 1.0,
        "difficulty": "Повне розуміння + мовчання"
    }
}
```

## Нагороди

### За Репутацію
```gdscript
var silent_ones_rewards = {
    10: {
        "name": "Амулет Тиші",
        "effect": "Безшумне пересування",
        "description": "Твої кроки не чутні для ворогів"
    },
    25: {
        "name": "Плащ Мовчання",
        "effect": "+50% до скритності вночі",
        "description": "Тканина, що поглинає звук"
    },
    40: {
        "name": "Кинджал Без Шуму",
        "effect": "Атаки не привертають увагу",
        "description": "Зброя, що вбиває без звуку"
    },
    60: {
        "name": "Зілля Тиші",
        "effect": "Можна ходити безшумно 5 хвилин",
        "description": "Тимчасовий ефект невидимості звуку"
    },
    80: {
        "name": "Символ Мовчання (тату)",
        "effect": "Постійне безшумне пересування",
        "description": "Тиша стає частиною тебе"
    },
    100: {
        "name": "Стати Мовчазним",
        "effect": "Втрата голосу назавжди",
        "bonus": "+100% до всіх здібностей скритності",
        "note": "Необоротне — подумай добре!"
    }
}
```

### За Знання (через жести)
```gdscript
var knowledge_rewards = [
    {
        "gesture": "KNOWLEDGE",
        "reveals": "Приховані входи в катакомбах",
        "locations": ["Valkorn", "Greyford"]
    },
    {
        "gesture": "SILENCE", 
        "reveals": "Місця сили Моура",
        "locations": ["All Swamps"]
    },
    {
        "gesture": "FOLLOW",
        "reveals": "Таємні стежки між містами",
        "locations": ["Swamp", "Forest"]
    }
]
```

## Квести Мовчазних

### "Втрачений Шепіт"
```gdscript
var quest_lost_whisper = {
    "giver": "Старійшина Мовчазних (Храм Тиші)",
    "requirements": {"reputation": 20, "eye_of_moor": 2},
    "steps": [
        {
            "description": "Знайти втрачений символ мовчання",
            "location": "Затоплена Обитель",
            "challenge": "Уникати звуку (не битись, не бігти)"
        },
        {
            "description": "Повернути символ у Храм Тиші",
            "gesture_needed": "THANKS"
        },
        {
            "description": "Отримати благословення Мовчання",
            "reward": "Амулет Тиші"
        }
    ]
}
```

### "Голос Предків"
```gdscript
var quest_ancestors_voice = {
    "giver": "Символ на камені (Стояння Каміння)",
    "requirements": {"gestures_known": 6},
    "steps": [
        {
            "description": "Розшифрувати 3 стародавні символи",
            "locations": ["Храм Тиші", "Бібліотека Шепоту", "Підземелля Валькорну"],
            "gestures_needed": ["QUESTION", "KNOWLEDGE", "SILENCE"]
        },
        {
            "description": "Скласти символи в правильному порядку",
            "puzzle": "Головоломка на 3 рівні"
        },
        {
            "description": "Відкрити таємницю предків",
            "reward": "Символ Мовчання (тату)"
        }
    ]
}
```

### "Останнє Слово"
```gdscript
var quest_last_word = {
    "giver": "Вмираючий Мовчазний",
    "requirements": {"reputation": 50, "master_gestures": true},
    "steps": [
        {
            "description": "Вислухати останнє послання (через жести)",
            "gesture_sequence": ["SADNESS", "KNOWLEDGE", "FOLLOW", "SILENCE"],
            "translation": "Таємниця Моура в серці болота"
        },
        {
            "description": "Знайти Серце Моура",
            "location": "Найглибша точка болота",
            "requires": "eye_of_moor_tier_5"
        },
        {
            "description": "Знищити або зберегти Серце",
            "choice": {
                "destroy": "Моур гине, світ змінюється",
                "preserve": "Моур отримує повну силу, гра змінюється"
            },
            "reward": "Вибір впливає на фінал гри"
        }
    ]
}
```

## Ціна Співпраці

### Тимчасова Втрата Голосу
```gdscript
func silent_bargain(duration_minutes: int):
    # Гравець не може говорити
    player.can_speak = false
    player.dialogue_options = []  # Тільки жести
    
    # Вплив на гру
    merchant_prices *= 1.3  # Не можете торгуватись
    quest_acceptance_chance *= 0.7  # Складніше брати квести
    enemy_alert_radius *= 0.3  # Вороги не чують
    
    # Через duration хвилин повертається
    Timer.new().start(duration_minutes * 60).timeout = func():
        player.can_speak = true
        player.dialogue_options = default_dialogues()
```

### Постійна Втрата Голосу
```gdscript
func permanent_silence():
    # Фінальний квест Мовчазних
    player.can_speak = false  # Назавжди
    
    # Переваги
    player.stealth += 50
    player.invisibility += 30
    player.critical_chance += 15
    
    # Недоліки
    player.dialogue = "gestures_only"
    player.quest_options = "reduced"
    
    # Унікальні можливості
    player.can_join_silent_ones = true
    player.learn_all_gestures()
```

## Інтеграція

### З Eye of Moor
```gdscript
func eye_synergy():
    if EyeOfMoor.tier >= 3:
        # Бачите справжні наміри Мовчазних
        show_silent_one_intent()
        # І можете читати їхні символи без вивчення
        auto_translate_symbols = true
```

### З Dynamic World
```gdscript
func world_synergy():
    # Мовчазні залишають послання по всьому світу
    if player.gesture_level >= "adept":
        WorldEventSystem.add_silent_messages()
        # Нові послання з'являються щодня
```

### З Curses & Blessings
```gdscript
func curse_synergy():
    # Прокляття "Втрачений голос" дає бонус у Мовчазних
    if "silent_curse" in active_curses:
        SilentOnesInteraction.reputation_gain *= 1.5
        SilentOnesInteraction.gesture_learning *= 2.0
```
