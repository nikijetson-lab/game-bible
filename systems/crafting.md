# ⚒️ Система Ремесел

## 1. 🧪 Алхімія

### Інгредієнти
```gdscript
enum Ingredient {
    # Болотяні
    SWAMP_MOSS,        # Болотяний мох
    WILLOW_BARK,       # Кора верби
    FIREFLY_DUST,      # Пил світлячків
    MURKY_WATER,       # Каламутна вода
    BOG_MUSHROOM,      # Болотяний гриб
    CRYSTAL_SLIME,     # Кришталевий слиз
    
    # Підземельні
    SHADOW_ESSENCE,    # Есенція тіні
    CRYSTAL_SHARD,     # Осколок кристалу
    VAMPIRE_BLOOD,     # Кров вампіра
    DARK_STONE,        # Темний камінь
    
    # Рідкісні
    MOOR_TEAR,         # Сльоза Моура
    PHANTOM_ASH,       # Попіл фантома
    SOUL_FRAGMENT,     # Фрагмент душі
    BLOOD_RUBY         # Кривавий рубін
}
```

### Рецепти (15+)

#### Лікувальні
```gdscript
var potions = [
    {
        "name": "Мала зілля здоров'я",
        "ingredients": [SWAMP_MOSS, MURKY_WATER],
        "effect": "Відновлює 25 HP",
        "craft_time": 5, # секунд
        "difficulty": 1
    },
    {
        "name": "Велика зілля здоров'я",
        "ingredients": [SWAMP_MOSS, WILLOW_BARK, MURKY_WATER],
        "effect": "Відновлює 60 HP",
        "craft_time": 10,
        "difficulty": 2
    },
    {
        "name": "Зілля від отрути",
        "ingredients": [SWAMP_MOSS, FIREFLY_DUST],
        "effect": "Знімає отруту + імунітет 30с",
        "craft_time": 8,
        "difficulty": 2
    }
]
```

#### Бойові
```gdscript
var combat_potions = [
    {
        "name": "Зілля сили",
        "ingredients": [BOG_MUSHROOM, SHADOW_ESSENCE],
        "effect": "+30% шкоди на 20с",
        "craft_time": 15,
        "difficulty": 3
    },
    {
        "name": "Зілля невидимості",
        "ingredients": [FIREFLY_DUST, PHANTOM_ASH],
        "effect": "Невидимість на 10с",
        "craft_time": 20,
        "difficulty": 4
    },
    {
        "name": "Вибухова пляшка",
        "ingredients": [CRYSTAL_SLIME, DARK_STONE, MURKY_WATER],
        "effect": "50 шкоди в області",
        "craft_time": 12,
        "difficulty": 3
    }
]
```

#### Темні Еліксири
```gdscript
var dark_elixirs = [
    {
        "name": "Еліксир крові",
        "ingredients": [VAMPIRE_BLOOD, SOUL_FRAGMENT],
        "effect": "Кожен удар відновлює 5 HP на 30с",
        "craft_time": 25,
        "difficulty": 5,
        "price": "Старіння персонажа на 1 рік"
    },
    {
        "name": "Зілля спотворення",
        "ingredients": [MOOR_TEAR, BLOOD_RUBY],
        "effect": "+50% шкоди, але -50% HP на 60с",
        "craft_time": 30,
        "difficulty": 5,
        "price": "+20 спотворення"
    },
    {
        "name": "Еліксир безсмертя",
        "ingredients": [SOUL_FRAGMENT, MOOR_TEAR, BLOOD_RUBY, PHANTOM_ASH],
        "effect": "Воскресіння після смерті (одноразово)",
        "craft_time": 60,
        "difficulty": 5,
        "price": "-50% HP на 24 години"
    }
]
```

---

## 2. ⚒️ Ковальство

### Матеріали
```gdscript
enum Material {
    # Звичайні
    IRON_ORE,        # Залізна руда
    COAL,            # Вугілля
    LEATHER,         # Шкіра
    WOOD,            # Дерево
    
    # Рідкісні
    MOON_STEEL,      # Місячна сталь
    BLOOD_IRON,      # Криваве залізо
    SHADOW_SILVER,   # Тіньове срібло
    DEMON_BONE,      # Кістка демона
    
    # Легендарні
    MOOR_CRYSTAL,    # Кристал Моура
    VOID_METAL,      # Метал порожнечі
    SOUL_STEEL       # Сталь душі
}
```

### Рівні зброї
```gdscript
enum WeaponTier {
    WEAKENED = 1,    # Ослаблена
    COMMON = 2,      # Звичайна
    FINE = 3,        # Якісна
    MASTERWORK = 4,  # Майстерна
    LEGENDARY = 5    # Легендарна
}
```

### Рецепти зброї

#### Мечі
```gdscript
var swords = [
    {
        "name": "Залізний меч",
        "materials": [IRON_ORE(2), COAL(1)],
        "tier": COMMON,
        "stats": "12-18 шкоди",
        "craft_time": 30
    },
    {
        "name": "Кривавий клинок",
        "materials": [BLOOD_IRON(3), DEMON_BONE(1), COAL(2)],
        "tier": MASTERWORK,
        "stats": "25-35 шкоди, 15% вампіризм",
        "craft_time": 60,
        "special": "Кожне вбивство +5 HP"
    },
    {
        "name": "Тіньовий розріз",
        "materials": [SHADOW_SILVER(4), VOID_METAL(2), SOUL_FRAGMENT(1)],
        "tier": LEGENDARY,
        "stats": "40-55 шкоди, 20% крит",
        "craft_time": 120,
        "special": "Шанс створити тіньового клона"
    }
]
```

#### Броня
```gdscript
var armor = [
    {
        "name": "Шкіряний обладунок",
        "materials": [LEATHER(3), WOOD(1)],
        "tier": COMMON,
        "stats": "+15 броні",
        "craft_time": 40
    },
    {
        "name": "Кривава кольчуга",
        "materials": [BLOOD_IRON(4), DEMON_BONE(2)],
        "tier": MASTERWORK,
        "stats": "+35 броні, +10% опір кровотечі",
        "craft_time": 80
    },
    {
        "name": "Обладунок Моура",
        "materials": [MOOR_CRYSTAL(3), VOID_METAL(3), SOUL_STEEL(2)],
        "tier": LEGENDARY,
        "stats": "+60 броні, 25% шанс відбити атаку",
        "craft_time": 180,
        "special": "Кожні 30с щит, що блокує 1 атаку"
    }
]
```

---

## 3. 🌿 Травництво

### Зони збору
```gdscript
enum GatheringZone {
    SWAMP_EDGE,      # Край болота
    DEEP_SWAMP,      # Глибоке болото
    FOREST,          # Ліс
    RUINS,           # Руїни
    CEMETERY,        # Цвинтар
    CAVES            # Печери
}
```

### Рослини (20+)
```gdscript
var plants = [
    # Край болота
    {"name": "Болотяна кропива", "zone": SWAMP_EDGE, "rarity": "common"},
    {"name": "Вербова кора", "zone": SWAMP_EDGE, "rarity": "common"},
    {"name": "Світляковий мох", "zone": SWAMP_EDGE, "rarity": "common"},
    
    # Глибоке болото
    {"name": "Чорний лотос", "zone": DEEP_SWAMP, "rarity": "uncommon"},
    {"name": "Кривавий корінь", "zone": DEEP_SWAMP, "rarity": "uncommon"},
    {"name": "М'ясоїдна ліана", "zone": DEEP_SWAMP, "rarity": "rare"},
    
    # Цвинтар
    {"name": "Могильна троянда", "zone": CEMETERY, "rarity": "rare"},
    {"name": "Кісткова трава", "zone": CEMETERY, "rarity": "uncommon"},
    {"name": "Примарний гриб", "zone": CEMETERY, "rarity": "rare"},
    
    # Печери
    {"name": "Кришталевий лишайник", "zone": CAVES, "rarity": "rare"},
    {"name": "Сліпа лоза", "zone": CAVES, "rarity": "uncommon"},
    {"name": "Сяючий мох", "zone": CAVES, "rarity": "common"}
]
```

### Система збору
```gdscript
func gather(zone, skill_level):
    var available = plants.filter(p => p.zone == zone)
    var result = []
    
    # Базовий шанс 50% + бонус за навичку
    var chance = 0.5 + (skill_level * 0.05)
    
    for plant in available:
        if randf() < chance:
            result.append(plant)
            
            # Рідкісні рослини — додатковий чек
            if plant.rarity == "rare" and randf() > 0.3:
                result.erase(plant)
    
    return result
```

---

## Прокачка ремесел

```gdscript
class_name CraftingSkill

var alchemy_level = 1
var blacksmith_level = 1
var herbalism_level = 1

var alchemy_xp = 0
var blacksmith_xp = 0
var herbalism_xp = 0

const XP_PER_LEVEL = [100, 250, 500, 1000, 2000, 4000]

func add_xp(skill, amount):
    match skill:
        "alchemy":
            alchemy_xp += amount
            if alchemy_xp >= XP_PER_LEVEL[alchemy_level]:
                alchemy_level += 1
        "blacksmith":
            blacksmith_xp += amount
            if blacksmith_xp >= XP_PER_LEVEL[blacksmith_level]:
                blacksmith_level += 1
        "herbalism":
            herbalism_xp += amount
            if herbalism_xp >= XP_PER_LEVEL[herbalism_level]:
                herbalism_level += 1
```

### Бонуси за рівень
| Рівень | Алхімія | Ковальство | Травництво |
|--------|---------|------------|------------|
| 1 | Базові зілля | Залізні предмети | Збір у 1 зоні |
| 2 | Середні зілля | Сталеві предмети | Збір у 2 зонах |
| 3 | Бойові зілля | Майстерні предмети | Збір у 3 зонах |
| 4 | Темні еліксири | Криваві предмети | Збір у 4 зонах |
| 5 | Легендарні зілля | Легендарна зброя | Збір у всіх зонах |
| 6 | Еліксир безсмертя | Обладунок Моура | Авто-збір |

---

### Інтеграція з іншими системами

```gdscript
# Крафт впливає на репутацію
func craft_influence(item):
    match item:
        "blood_potion":
            ReputationSystem.update("Muri", 5)
            ReputationSystem.update("Valkorn", -3)
        "holy_armor":
            ReputationSystem.update("Valkorn", 10)
            ReputationSystem.update("Muri", -5)

# Рідкісні матеріали з квестів
func quest_reward_crafting():
    if active_quest.has("moor_crystal"):
        player.add_material(MOOR_CRYSTAL, 1)
```
