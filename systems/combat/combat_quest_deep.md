# ⚔️ Поглиблення Бойової Системи

## 1. Спеціалізації Зброї

### Кинджали
```gdscript
class_name DaggerSkills

var skills = [
    {
        "name": "Удар Зі Спини",
        "condition": "атака ззаду",
        "multiplier": 3.0,
        "cost": 15
    },
    {
        "name": "Кривавий Танець",
        "condition": "3+ вороги поруч",
        "effect": "атака по всіх + відкат",
        "cost": 25
    },
    {
        "name": "Отруйний Клинок",
        "condition": "є отрута в інвентарі",
        "effect": "авто-отруєння зброї",
        "permanent": true
    }
]
```

### Мечі
```gdscript
class_name SwordSkills

var skills = [
    {
        "name": "Розсічення",
        "condition": "звичайна атака",
        "chance": 0.2,
        "effect": "шкода x1.5 по 2 ворогам"
    },
    {
        "name": "Щит Крові",
        "condition": "<30% HP",
        "effect": "кожна атака лікує 10% від шкоди",
        "duration": 10
    },
    {
        "name": "Фінальний Випад",
        "condition": "ворог <20% HP",
        "multiplier": 2.5,
        "cost": 30
    }
]
```

### Дворучна Зброя
```gdscript
class_name HeavyWeaponSkills

var skills = [
    {
        "name": "Крушитель",
        "condition": "заряд 3с",
        "effect": "шкода x3, пробиває броню",
        "cooldown": 15
    },
    {
        "name": "Тремтіння Землі",
        "condition": "атака по землі",
        "effect": "AOE 5м, вороги приголомшені 2с",
        "cost": 40
    }
]
```

### Луки/Арбалети
```gdscript
class_name RangedSkills

var skills = [
    {
        "name": "Точний Постріл",
        "condition": "цільнерухома 3с",
        "multiplier": 3.0,
        "cost": 20
    },
    {
        "name": "Дощ Стріл",
        "condition": "відкрите небо",
        "effect": "5 стріл за 1с по площі",
        "cooldown": 20
    }
]
```

### Магія (через артефакти/прокльони)
```gdscript
class_name MagicSkills

var skills = [
    {
        "name": "Болотяний Опік",
        "condition": "ворог у воді",
        "effect": "50 шкоди + отрута 3с",
        "cost": 30
    },
    {
        "name": "Прикликання Тіней",
        "condition": "рівень спотворення >30",
        "effect": "тінь-клон на 15с",
        "cooldown": 45
    },
    {
        "name": "Жертва",
        "condition": "є NPC поруч",
        "effect": "+100% шкоди на 10с, -20 репутації",
        "cooldown": 60
    }
]
```

---

## 2. Складніші Вороги

### Тактичні Вороги
```gdscript
class_name TacticalEnemy
extends Enemy

# Вороги з інтелектом
var tactics = [
    {
        "name": "Командир Розбійників",
        "behavior": "координує атаки",
        "abilities": [
            "наказ_оточити",
            "сигнал_відступу",
            "призов_підкріплення"
        ]
    },
    {
        "name": "Культист-Алхімік",
        "behavior": "кидає зілля",
        "abilities": [
            "вибухова_суміш",
            "отруйний_туман",
            "лікувальний_еліксир"
        ]
    },
    {
        "name": "Примарний Вартовий",
        "behavior": "фазова атака",
        "abilities": [
            "перехід_у_тінь",
            "атака_з_тіні",
            "паралізуючий_крик"
        ]
    }
]
```

### Елітні Вороги
```gdscript
class_name EliteEnemy
extends Enemy

var elite_types = [
    {
        "name": "Капітан Варти (Валькорн)",
        "hp": 500,
        "damage": 35,
        "abilities": ["парадний_удар", "щит_фаланги", "призов_2_вартових"],
        "loot": ["ключ_від_воріт", "знак_капітана", "100з"]
    },
    {
        "name": "Старійшина Культу",
        "hp": 400,
        "damage": 25,
        "abilities": ["болотяний_сплеск", "прикликання_слизу", "аура_спотворення_15"],
        "loot": ["ритуальний_кинджал", "книга_заклинань", "150з", "тіньовий_кристал"]
    },
    {
        "name": "Голова Контрабандистів",
        "hp": 350,
        "damage": 40,
        "abilities": ["отруйний_удар", "димова_завіса", "втеча_на_50%HP"],
        "loot": ["ключ_схрону", "300з", "заборонений_товар"]
    }
]
```

### Фатальні Вороги
```gdscript
class_name LethalEnemy

# Вороги, які можуть вбити з 1 удару
var lethal_types = [
    {
        "name": "Примара Боліт",
        "condition": "з'являється при >=50 спотворення",
        "attack": "дотик_смерті (100% HP)",
        "weakness": "свята_вода",
        "dodge": "відвернутися + не рухатися 3с"
    },
    {
        "name": "Пожирач Душ",
        "condition": "вбито >50 NPC",
        "attack": "крик_душі (параліч + drain 10 HP/с)",
        "weakness": "світло",
        "dodge": "закрити вуха + бігти до світла"
    }
]
```

---

## 3. Бойові Стани

```gdscript
enum BATTLE_STATE {
    NORMAL,           # Звичайний стан
    BLEEDING,         # Кровотеча (2 HP/с, 5с)
    POISONED,         # Отруєний (4 HP/с, 5с, стакається)
    STUNNED,          # Приголомшений (не рухається, 2с)
    ROOTED,           # Знерухомлений (на місці, 3с)
    FEARED,           # Наляканий (біжить випадково, 3с)
    BLINDED,          # Засліплений (не бачить, 4с)
    SILENCED,         # Німий (не може кричати/закликати, 5с)
    CONFUSED,         # Заплутаний (вороги — союзники, 3с)
    CURSED,           # Проклятий (-25% до всього, поки не зняти)
    CORRUPTED,        # Спотворений (+50% шкоди, атакує всіх, 10с)
    SACRIFICED        # Жертва (миттєва смерть, якщо HP <20%)
}
```

---

## 4. Квестові Розгалуження

### Система Наслідків
```gdscript
class_name QuestBranching

var quest_consequences = {
    "blood_for_moor_god_quest": [
        {
            "choice": "принести_жертву_3",
            "immediate": {
                "reputation": {"Muri": -30, "Smugglers": -10},
                "gold": 500,
                "item": "кривавий_амулет",
                "corruption": 25
            },
            "long_term": {
                "cult_trust": 50,
                "new_quests": ["cult_initiation"],
                "locked_quests": ["stop_the_cult"]
            },
            "world_state": {
                "altar_active": true,
                "more_cultists": true,
                "npc_reactions": {"Valkorn": "ворожість"}
            }
        },
        {
            "choice": "відмовитись_і_знищити_вівтар",
            "immediate": {
                "reputation": {"Muri": 20, "Valkorn": 30},
                "gold": 200,
                "item": "осколок_вівтаря",
                "corruption": -15
            },
            "long_term": {
                "cult_trust": -80,
                "new_quests": ["cult_revenge"],
                "locked_quests": ["full_cult_questline"]
            },
            "world_state": {
                "altar_destroyed": true,
                "cult_weak": true,
                "npc_reactions": {"Valkorn": "пошана"}
            }
        },
        {
            "choice": "вбити_жреця_але_забрати_силу",
            "immediate": {
                "reputation": {"Muri": 10, "Cult": -60},
                "item": "серце_жреця",
                "corruption": 50,
                "ability": "ритуальний_удар"
            },
            "long_term": {
                "new_quests": ["control_the_power"],
                "corruption_goal": "зняти_прокляття",
                "locked_quests": ["join_cult"]
            }
        }
    ]
}
```

### Динамічні NPC Реакції
```gdscript
class_name NPCMemorySystem

var npc_memory = {}

func on_quest_choice(quest_id, choice_id):
    for npc_id in affected_npcs[quest_id][choice_id]:
        npc_memory[npc_id] = {
            "quest": quest_id,
            "choice": choice_id,
            "timestamp": GameTime.now()
        }

func get_npc_dialogue_modifier(npc_id):
    if npc_id in npc_memory:
        var memory = npc_memory[npc_id]
        var quest = quest_data[memory.quest]
        var choice = quest.choices[memory.choice]
        
        return {
            "reputation_mod": choice.npc_reaction.get(npc_id, 0),
            "special_dialogue": choice.npc_dialogue.get(npc_id, null)
        }
    
    return null
```

### Світові Наслідки
```gdscript
class_name WorldStateManager

var world_flags = {}

func on_quest_complete(quest_id, choice_id):
    var consequences = quest_consequences[quest_id][choice_id]
    
    for (flag, value) in consequences.world_state:
        world_flags[flag] = value
    
    update_world()

func update_world():
    if world_flags.get("altar_active"):
        spawn_cult_patrols()
        block_road_to_valkorn()
    
    if world_flags.get("altar_destroyed"):
        add_reward_chest()
        unlock_cult_hideout()
```
