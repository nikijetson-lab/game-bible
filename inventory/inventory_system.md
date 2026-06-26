# 🎒 Система Інвентарю та Екіпірування

## Базова Архітектура

```gdscript
class InventoryItem:
    var id: String
    var name: String
    var description: String
    var type: ItemType
    var rarity: Rarity
    var weight: float
    var value: int
    var stackable: bool
    var max_stack: int
    var icon: Texture
    var on_use: Callable

enum ItemType {
    WEAPON,         # Зброя
    ARMOR,          # Броня
    ACCESSORY,      # Аксесуар
    CONSUMABLE,     # Витратний
    KEY_ITEM,       # Ключовий (квестовий)
    MATERIAL,       # Матеріал (крафт)
    TREASURE,       # Скарб (продаж)
    READABLE        # Читанка (книги, листи)
}

enum Rarity {
    COMMON,     # Білий
    UNCOMMON,   # Зелений
    RARE,       # Синій
    EPIC,       # Фіолетовий
    LEGENDARY,  # Помаранчевий
    UNIQUE,     # Червоний (тільки 1 у світі)
    CURSED,     # Сірий (не можна зняти)
    QUEST       # Жовтий (тільки для квестів)
}
```

## Інвентар

### Структура
```gdscript
class Inventory:
    var items: Array[InventorySlot]
    var max_weight: float
    var max_slots: int = 40
    
    # Слоти
    const EQUIP_SLOTS = {
        "main_hand": null,     # Основна рука (меч, палиця)
        "off_hand": null,      # Другорядна (щит, кинджал, ліхтар)
        "head": null,          # Шолом/капюшон
        "chest": null,         # Нагрудник/плащ
        "legs": null,          # Штани/поножі
        "feet": null,          # Чоботи
        "hands": null,         # Рукавиці
        "neck": null,          # Амулет
        "ring1": null,         # Перстень
        "ring2": null,         # Перстень
        "cloak": null,         # Плащ
        "belt": null           # Пояс (зілля, гранати)
    }
    
    var quick_slots: Array[String] = []  # Швидкий доступ (4 слоти)
```

### Вага та Вантажопідйомність
```gdscript
class WeightSystem:
    var base_capacity = 50.0  # кг
    var strength_multiplier = 5.0  # +5 кг за кожну одиницю сили
    
    func get_max_weight(strength: int) -> float:
        return base_capacity + (strength * strength_multiplier)
    
    func get_weight_penalty(current_weight: float, max_weight: float) -> Dictionary:
        var ratio = current_weight / max_weight
        match ratio:
            r < 0.5:
                return {"speed": 1.0, "dodge": 1.0}
            r < 0.75:
                return {"speed": 0.9, "dodge": 0.85}
            r < 1.0:
                return {"speed": 0.7, "dodge": 0.6}
            _:
                return {"speed": 0.4, "dodge": 0.3, "cannot_sprint": true}
```

### UI Інвентарю
```gdscript
class InventoryUI:
    func _draw():
        # Сітка інвентарю (6x7 + 40 слотів)
        draw_grid(6, 7, Vector2(100, 100))
        
        # Слоти екіпірування (фігура людини)
        draw_equipment_slots()
        
        # Вага
        draw_weight_bar(current_weight, max_weight)
        
        # Швидкий доступ
        draw_quick_slots(4)
    
    func _input(event):
        # Drag & drop
        if event is InputEventMouseButton:
            if event.button_index == MOUSE_BUTTON_LEFT:
                start_drag()
            elif event.button_index == MOUSE_BUTTON_RIGHT:
                use_item()  # Використати/одягнути
```

## Предмети

### Зброя
```gdscript
class Weapon:
    var damage: Dictionary = {"min": 5, "max": 15}
    var damage_type: DamageType  # PHYSICAL, MAGIC, FIRE, POISON, DARKNESS
    var speed: float = 1.0       # Атаки за секунду
    var range: float             # Дальність (melee: 2-3, ranged: 10-30)
    var requirements: Dictionary = {"strength": 10}
    
    # Спеціальні ефекти
    var on_hit_effects: Array[StatusEffect] = []  # Кровотеча, отрута...
    var on_crit_effects: Array[SpellEffect] = []  # При критичному ударі
    var weapon_skill: String                      # Спеціальна атака (Q)
    
    # Стан зброї
    var durability: int = 100
    var max_durability: int = 100
    
    func take_damage():
        durability -= randi_range(1, 3)
        if durability <= 0:
            break_weapon()
    
    func repair(amount: int):
        durability = min(durability + amount, max_durability)
```

### Броня
```gdscript
class Armor:
    var defense: int
    var defense_type: DefenseType  # PHYSICAL, MAGICAL, ELEMENTAL
    var weight: float
    var speed_penalty: float
    
    # Спеціальні властивості
    var resistances: Dictionary = {"poison": 0.1, "fire": 0.2}
    var set_bonus: String         # Назва сету
    var enchants: Array[Enchant]  # Зачарування
    
    # Сетові бонуси
    func apply_set_bonus(equipped_set: Dictionary):
        var count = 0
        for slot in ["head", "chest", "legs", "hands", "feet"]:
            if equipped_set[slot] and equipped_set[slot].set_bonus == set_bonus:
                count += 1
        
        match count:
            2: # 2 частини: +10% захисту
                defense *= 1.1
            4: # 4 частини: +25% захисту
                defense *= 1.25
            5: # Повний сет: унікальна здатність
                activate_full_set_skill()
```

### Витратні Предмети
```gdscript
# Рецепти зілль
var potions = {
    "health_potion": {"effect": "heal 50 HP", "recipe": ["moor_herb", "water"]},
    "mana_potion": {"effect": "restore 30 MP", "recipe": ["crystal_shard", "water"]},
    "strength_potion": {"effect": "+5 STR for 60s", "recipe": ["wolf_blood", "moor_herb"]},
    "invisibility_potion": {"effect": "invisible 30s", "recipe": ["shadow_essence", "moon_water"]},
    "antidote": {"effect": "cure poison", "recipe": ["healing_moss", "water"]},
    "explosive_grenade": {"effect": "50 AOE damage", "recipe": ["sulfur", "coal", "cloth"]}
}

# Сміття (для продажу)
var trash_items = {
    "bone_fragment": "Уламок кістки. Можна продати.",
    "swamp_moss": "Мох із болота. Нічого особливого.",
    "rusty_coin": "Стара монета з невідомим гербом."
}
```

## Крафт

### Ковальство
```gdscript
class Smithing:
    var recipes: Dictionary = {
        "iron_sword": {
            "materials": {"iron_ingot": 3, "leather": 1},
            "station": "anvil",
            "skill_required": 10,
            "result": {"damage": 15, "speed": 0.9}
        },
        "steel_armor": {
            "materials": {"steel_ingot": 5, "chainmail": 1},
            "station": "forge",
            "skill_required": 25,
            "result": {"defense": 30}
        },
        "moor_blade": {
            "materials": {"moor_crystal": 1, "shadow_steel": 2},
            "station": "moor_altar",
            "skill_required": 40,
            "result": {"damage": 40, "on_hit": "curse"}
        }
    }
```

### Поліпшення
```gdscript
# Модифікатори зброї
var weapon_mods = {
    "sharp": {"effect": "+5 damage", "material": "whetstone"},
    "poisoned": {"effect": "poison on hit", "material": "venom_sack"},
    "flaming": {"effect": "fire damage", "material": "fire_crystal"},
    "cursed": {"effect": "+15 damage, -5 HP/sec", "material": "cursed_gem"},
    "silent": {"effect": "no sound", "material": "shadow_silk"}
}
```

## Економіка

### Ціни
```gdscript
class Economy:
    var price_multipliers = {
        "common": 1.0,
        "uncommon": 2.5,
        "rare": 5.0,
        "epic": 15.0,
        "legendary": 50.0,
        "unique": 100.0
    }
    
    func get_sell_price(item: InventoryItem, reputation: int) -> int:
        var base = item.value * price_multipliers[item.rarity]
        var rep_mult = 1.0 + (reputation * 0.01)  # +1% за одиницю репутації
        return int(base * rep_mult)
```

### Торговці
```gdscript
var merchants = {
    "greyford_blacksmith": {
        "name": "Коваль Бертольд",
        "buys": ["weapon", "armor", "material"],
        "sells": ["iron_sword", "leather_armor", "repair_service"],
        "reputation_threshold": 0
    },
    "smuggler_den": {
        "name": "Таємний торговець",
        "buys": ["treasure", "cursed"],
        "sells": ["shadow_items", "stolen_goods"],
        "reputation_threshold": -20  # Тільки для контрабандистів
    }
}
```
