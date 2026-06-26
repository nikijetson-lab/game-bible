# ⚒️ Система Крафту — Алхімія та Ковальство

## 1. АЛХІМІЯ

### Теорія
Алхімія у світі Хейзмуру — це не просто змішування інгредієнтів. Кожна рослина та мінерал мають "пам'ять" болота. Правильна комбінація може вивільнити силу, неправильна — проклясти.

### Рівні Алхімії
```gdscript
enum ALCHEMY_LEVEL {
    NOVICE = 0,     # Базові зілля
    APPRENTICE = 25,# Середні зілля
    ADEPT = 50,     # Складні зілля
    MASTER = 75,    # Еліксири
    LEGENDARY = 100 # Філософський камінь
}
```

### Інгредієнти

#### Рослини Болота
```yaml
swamp_herbs:
  - name: "Морочна Трава"
    rarity: common
    locations: [повсюдно_в_болоті]
    effects: [лікування_5, отрута_легка]
    price: 5
    
  - name: "Кривавий Мох"
    rarity: uncommon
    locations: [біля_трупів, кладовище]
    effects: [лікування_15, спотворення+5]
    price: 20
    
  - name: "Світлоносний Гриб"
    rarity: rare
    locations: [глибокі_печери]
    effects: [зцілення_25, антиотрута, сяйво]
    price: 50
    
  - name: "Примарна Лілія"
    rarity: very_rare
    locations: [тихі_заводі_вночі]
    effects: [невидимість_30с, манна+50]
    price: 150
    
  - name: "Корінь Забуття"
    rarity: legendary
    locations: [затоплена_обитель]
    effects: [скидання_спотворення, втрата_спогадів]
    price: 500
```

#### Мінерали
```yaml
minerals:
  - name: "Болотяна Руда"
    rarity: common
    locations: [мілкі_болота]
    effect: base_armor
    price: 10
    
  - name: "Тіньовий Кристал"
    rarity: rare
    locations: [катакомби_культу]
    effect: shadow_damage_+20%
    price: 100
    
  - name: "Крововий Алмаз"
    rarity: very_rare
    locations: [жертовник_жреця]
    effect: life_steal_10%
    price: 300
    
  - name: "Осколок Душі"
    rarity: legendary
    locations: [розрив_між_світами]
    effect: revive_once
    price: 1000
```

#### Частини Істот
```yaml
creature_parts:
  - name: "Слиз Причайдуха"
    source: "Причайдух"
    effect: отрута_повільна_5с
    price: 15
    
  - name: "Кіготь Очеретяного Ходця"
    source: "Очеретяний Ходь"
    effect: шкода+10
    price: 30
    
  - name: "Око Культиста"
    source: "Болотяний Посланець"
    effect: нічний_зір_60с
    price: 40
    
  - name: "Серце Верховного Жреця"
    source: "Верховний Жрець"
    effect: безсмертя_5с
    price: 500
```

### Рецепти Зіль

#### Базові (Novice)
```gdscript
var novice_recipes = [
    {
        "name": "Мала Зцілююча Настоянка",
        "ingredients": ["Морочна Трава x2"],
        "effect": "Відновлює 10 HP",
        "craft_time": 5,
        "xp": 10
    },
    {
        "name": "Протиотрута",
        "ingredients": ["Морочна Трава", "Вугілля"],
        "effect": "Знімає отруту",
        "craft_time": 10,
        "xp": 15
    },
    {
        "name": "Зілля Нічного Зору",
        "ingredients": ["Око Культиста", "Вода"],
        "effect": "Нічний зір 30с",
        "craft_time": 15,
        "xp": 20
    }
]
```

#### Середні (Apprentice)
```gdscript
var apprentice_recipes = [
    {
        "name": "Сильне Зцілення",
        "ingredients": ["Кривавий Мох x2", "Вода"],
        "effect": "Відновлює 30 HP",
        "craft_time": 20,
        "xp": 30
    },
    {
        "name": "Зілля Манни",
        "ingredients": ["Примарна Лілія", "Кривавий Мох"],
        "effect": "Відновлює 50 MP",
        "craft_time": 25,
        "xp": 35
    },
    {
        "name": "Болотяна Отрута",
        "ingredients": ["Слиз Причайдуха x2", "Морочна Трава"],
        "effect": "Отрута 5с, 5 DPS",
        "craft_time": 20,
        "xp": 25
    }
]
```

#### Складні (Adept)
```gdscript
var adept_recipes = [
    {
        "name": "Еліксир Невидимості",
        "ingredients": ["Примарна Лілія x2", "Осколок Тіні"],
        "effect": "Невидимість 30с",
        "craft_time": 45,
        "xp": 60
    },
    {
        "name": "Зілля Спотворення",
        "ingredients": ["Корінь Забуття", "Крововий Алмаз"],
        "effect": "+50% шкоди, -50% репутації з усіма",
        "craft_time": 60,
        "xp": 80
    },
    {
        "name": "Антидот Спотворення",
        "ingredients": ["Світлоносний Гриб x2", "Свята Вода"],
        "effect": "Знімає 30 спотворення",
        "craft_time": 50,
        "xp": 70
    }
]
```

#### Майстер (Master)
```gdscript
var master_recipes = [
    {
        "name": "Філософський Камінь",
        "ingredients": [
            "Осколок Душі x3",
            "Крововий Алмаз x2",
            "Корінь Забуття",
            "Серце Верховного Жреця"
        ],
        "effect": "Безсмертя на 10с АБО воскресіння",
        "craft_time": 120,
        "xp": 200
    }
]
```

---

## 2. КОВАЛЬСТВО

### Рівні Ковальства
```gdscript
enum SMITHING_LEVEL {
    NOVICE = 0,      # Залізо
    APPRENTICE = 25, # Сталь
    ADEPT = 50,      # Темна сталь
    MASTER = 75,     # Міфріл
    LEGENDARY = 100  # Живий метал
}
```

### Матеріали

#### Рудна Таблиця
```gdscript
var ores = [
    {
        "name": "Залізна Руда",
        "tier": 1,
        "locations": ["шахти_грейфорду"],
        "smelt_time": 10,
        "base_damage": 10,
        "base_armor": 5
    },
    {
        "name": "Вуглецева Сталь",
        "tier": 2,
        "locations": ["кузні_валькорну"],
        "smelt_time": 20,
        "base_damage": 20,
        "base_armor": 10
    },
    {
        "name": "Темна Сталь",
        "tier": 3,
        "locations": ["катакомби", "руїни_культу"],
        "smelt_time": 35,
        "base_damage": 35,
        "base_armor": 18,
        "special": "shadow_damage"
    },
    {
        "name": "Міфріл",
        "tier": 4,
        "locations": ["затоплена_обитель"],
        "smelt_time": 50,
        "base_damage": 50,
        "base_armor": 25,
        "special": "light_weight"
    },
    {
        "name": "Живий Метал",
        "tier": 5,
        "locations": ["серце_моура"],
        "smelt_time": 100,
        "base_damage": 80,
        "base_armor": 40,
        "special": ["regenerates", "bonded_to_owner"]
    }
]
```

### Крафт Зброї

```gdscript
var weapon_blueprints = [
    {
        "name": "Залізний Меч",
        "materials": {"Залізна Руда": 2, "Дерево": 1},
        "damage": 12,
        "skill_req": 0,
        "craft_time": 30
    },
    {
        "name": "Сталевий Меч",
        "materials": {"Вуглецева Сталь": 2, "Шкіра": 1},
        "damage": 22,
        "skill_req": 25,
        "craft_time": 45
    },
    {
        "name": "Темний Клинок",
        "materials": {"Темна Сталь": 2, "Серце Культиста": 1, "Тіньовий Кристал": 1},
        "damage": 38,
        "special": "shadow_damage_+15%",
        "skill_req": 50,
        "craft_time": 60
    },
    {
        "name": "Міфрілова Рапіра",
        "materials": {"Міфріл": 2, "Шовк Павука": 1},
        "damage": 45,
        "special": "armor_piercing_50%",
        "skill_req": 75,
        "craft_time": 90
    },
    {
        "name": "Живий Клинок (Створити)",
        "materials": {"Живий Метал": 1, "Осколок Душі": 1, "Кров Майстра": 100},
        "damage": 70,
        "special": ["grows_with_owner", "life_steal_5%", "bonded"],
        "skill_req": 100,
        "craft_time": 200,
        "note": "Це не просто зброя — це новий живий меч"
    }
]
```

### Крафт Броні

```gdscript
var armor_blueprints = [
    {
        "name": "Шкіряний Нагрудник",
        "materials": {"Шкіра": 3, "Нитки": 1},
        "armor": 5,
        "weight": 2,
        "skill_req": 0,
        "craft_time": 25
    },
    {
        "name": "Кольчуга",
        "materials": {"Залізна Руда": 3, "Вугілля": 2},
        "armor": 12,
        "weight": 5,
        "skill_req": 15,
        "craft_time": 40
    },
    {
        "name": "Темний Обладунок",
        "materials": {"Темна Сталь": 3, "Тіньовий Кристал": 2, "Кров": 50},
        "armor": 25,
        "weight": 4,
        "special": ["shadow_resistance_30%", "intimidation_+10"],
        "skill_req": 50,
        "craft_time": 75
    },
    {
        "name": "Міфрілова Кіраса",
        "materials": {"Міфріл": 3, "Світлоносний Гриб": 1},
        "armor": 35,
        "weight": 1,
        "special": "light_weight",
        "skill_req": 75,
        "craft_time": 100
    }
]
```

### Спеціальні Рецепти

#### Покращення Через Жертви
```gdscript
func sacrifice_upgrade(weapon, npc_souls):
    # Кожна душа дає +1 до шкоди
    var bonus_damage = npc_souls
    weapon.damage += bonus_damage
    
    # Але збільшує спотворення
    weapon.corruption_on_use = bonus_damage * 0.5
    
    return weapon
```

#### Руни та Зачарування
```gdscript
var runes = [
    {
        "name": "Руна Крові",
        "material": "Крововий Алмаз",
        "effect": "10% life_steal",
        "apply_cost": 500
    },
    {
        "name": "Руна Тіні",
        "material": "Тіньовий Кристал",
        "effect": "10% chance_to_dodge",
        "apply_cost": 400
    },
    {
        "name": "Руна Моура",
        "material": "Серце Жреця",
        "effect": "25% shadow_damage_aura",
        "apply_cost": 1000,
        "curse": "постійне спотворення +1/хв"
    }
]
```

### Станції Крафту

```yaml
crafting_stations:
  - name: "Алхімічний Стіл"
    location: "Дім Алхіміка (Ґрейфорд)"
    level_req: 0
    bonus: "+5% якість зіль"
    
  - name: "Кузня Валькорну"
    location: "Район Ковалів"
    level_req: 15
    bonus: "-10% час крафту"
    
  - name: "Таємна Алхімічна Лабораторія"
    location: "Катакомби Культу"
    level_req: 50
    bonus: "+20% сила ефектів"
    
  - name: "Жива Кузня Моура"
    location: "Затоплена Обитель"
    level_req: 75
    bonus: "Можна крафтити Living Metal"
    curse: "+5 спотворення за крафт"
```

### Механіка Якості Предметів

```gdscript
enum ITEM_QUALITY {
    CRUDE = 0,      # -20% статів
    STANDARD = 1,   # 100% статів
    FINE = 2,       # +15% статів
    SUPERIOR = 3,   # +30% статів
    MASTERWORK = 4, # +50% статів
    LEGENDARY = 5   # +100% статів + унікальний ефект
}

func calculate_quality(craft_time, ingredients_quality, skill_level):
    var base_chance = skill_level * 0.5
    
    if craft_time == max_craft_time:
        base_chance += 10
    
    for ingredient in ingredients:
        if ingredient.quality == "superior":
            base_chance += 5
    
    return clamp(base_chance, 0, 100)
```
