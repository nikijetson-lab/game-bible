# 🗺️ Живі Локації — Карта, що Змінюється

## Концепція
Локації в Хейзмурі не статичні. Вони живуть, дихають і змінюються залежно від часу, погоди, дій гравця та глобальних подій.

## Механіка Змін

### Часова Циклічність
```gdscript
class_name LivingLocation

enum TIME_STATE {
    DAWN,      # Світанок (05:00-08:00)
    DAY,       # День (08:00-18:00)
    DUSK,      # Сутінки (18:00-21:00)
    NIGHT,     # Ніч (21:00-05:00)
    DEEP_NIGHT # Глибока ніч (00:00-04:00)
}

enum WEATHER {
    CLEAR,
    FOG,
    RAIN,
    STORM,
    MOOR_MIST  # Особливий туман Моура
}

var location_state = {
    "time": TIME_STATE.DAY,
    "weather": WEATHER.CLEAR,
    "danger_level": 0,      # 0-100
    "population": 0,
    "resources": {},        # Поточні ресурси
    "active_events": [],    # Поточні події
    "modifications": []     # Зміни від гравця
}
```

### Зміна Стану
```gdscript
func update_state(delta):
    # Оновлення часу
    update_time(delta)
    
    # Оновлення погоди
    update_weather()
    
    # Перевірка спеціальних умов
    check_special_conditions()
    
    # Застосування змін
    apply_visual_changes()
    update_npc_behaviors()
    update_resource_nodes()
```

---

## 🏘️ Грейфорд (Greyford)

### Денний Цикл
```gdscript
var greyford_daily_cycle = {
    "dawn": {
        "visual": "Туман підіймається, чути дзвони",
        "npc_behavior": "Ринок відкривається, селяни йдуть на поля",
        "merchant_status": "half_open",
        "guard_count": 8,
        "special": "Сніданок у таверні (знижки на їжу)"
    },
    "day": {
        "visual": "Ясно, сонце пробивається крізь туман",
        "npc_behavior": "Повна активність, торгівля, розмови",
        "merchant_status": "open",
        "guard_count": 12,
        "special": "Можна знайти роботу (випадкові квести)"
    },
    "dusk": {
        "visual": "Сутінки, запалюються смолоскипи",
        "npc_behavior": "Селяни повертаються додому",
        "merchant_status": "closing",
        "guard_count": 10,
        "special": "Підвищений шанс нічних подій"
    },
    "night": {
        "visual": "Темно, тільки смолоскипи та місяць",
        "npc_behavior": "Вулиці майже порожні, патрулі",
        "merchant_status": "closed",
        "guard_count": 6,
        "special": "Злодії та контрабандисти активні"
    },
    "deep_night": {
        "visual": "Майже непроглядна темрява",
        "npc_behavior": "Лише вартові біля воріт",
        "merchant_status": "closed",
        "guard_count": 2,
        "special": "Таємні входи відкриті (якщо знаєш)"
    }
}
```

### Погодні Зміни
```gdscript
var greyford_weather_effects = {
    "fog": {
        "visibility": -40,
        "npc_activity": -30,
        "stealth_bonus": 20,
        "special": "Шепіт Моура чутно в тумані"
    },
    "rain": {
        "visibility": -15,
        "npc_activity": -20,
        "merchant_prices": 1.1,  # Товари дорожчі
        "special": "Канави заповнюються водою"
    },
    "storm": {
        "visibility": -60,
        "npc_activity": -80,
        "buildings_damage": "possible",
        "special": "Блискавки можуть вразити"
    },
    "moor_mist": {
        "visibility": -90,
        "npc_activity": -95,
        "corruption_increase": 10,
        "special": "Моур близько — реальність викривлена"
    }
}
```

---

## 🌿 Болота Хейзмуру (Hazemoor Swamps)

### Зміна Рівня Води
```gdscript
var swamp_water_level = {
    "low_tide": {
        "visual": "Вода відступила, видно коріння та мул",
        "accessible": ["печери", "підземні ходи", "затонулі скрині"],
        "danger": "Менше ворогів, але брудні пастки видимі",
        "loot_bonus": 1.5  # Рідкісний лут доступний
    },
    "normal": {
        "visual": "Звичайний рівень води",
        "accessible": ["основні стежки", "очерет"],
        "danger": "Стандартний",
        "loot_bonus": 1.0
    },
    "high_tide": {
        "visual": "Вода піднялася, деякі стежки затоплені",
        "accessible": ["верхні рівні", "кроны дерев"],
        "danger": "Водяні вороги частіше",
        "loot_bonus": 0.7
    },
    "flood": {
        "visual": "Все затоплено, стиржать лише верхівки",
        "accessible": ["дахи", "високі дерева", "човни"],
        "danger": "Водяні монстри повсюди",
        "special": "Можна знайти затоплені скарби"
    }
}

# Зміна рівня води
func update_water_level():
    var tide_cycle = {
        "low_tide": 4,   # 4 години
        "rising": 2,     # 2 години
        "high_tide": 4,  # 4 години
        "falling": 2     # 2 години
    }
    
    # Повний цикл — 12 годин
    var cycle_hour = world_time % 12
    if cycle_hour < 4:
        return "low_tide"
    elif cycle_hour < 6:
        return "rising"
    elif cycle_hour < 10:
        return "high_tide"
    else:
        return "falling"
```

### Активність Істот
```gdscript
var swamp_creature_activity = {
    "day": {
        "creatures": ["очеретяні ходці", "болотяні змії"],
        "density": 0.3,        # 30% від максимуму
        "aggressiveness": 0.2  # 20% агресивні
    },
    "dusk": {
        "creatures": ["причайдухи", "вогняні мухи"],
        "density": 0.6,
        "aggressiveness": 0.5
    },
    "night": {
        "creatures": ["примари", "зіпсовані Мурі", "вовкулаки"],
        "density": 1.0,
        "aggressiveness": 0.8
    },
    "deep_night": {
        "creatures": ["стародавні болотяні духи", "аватари Моура"],
        "density": 1.5,
        "aggressiveness": 1.0
    }
}
```

---

## 🏰 Валькорн (Valkorn)

### Режими Безпеки
```gdscript
var valkorn_security_states = {
    "peace": {
        "guard_count": 20,
        "patrol_frequency": "normal",
        "access_restrictions": "none",
        "merchant_prices": 1.0,
        "special": "Можна вільно пересуватись"
    },
    "alert": {
        "trigger": "злочин гравця або напад",
        "guard_count": 30,
        "patrol_frequency": "increased",
        "access_restrictions": "checkpoints",
        "merchant_prices": 1.2,
        "duration": "24 години"
    },
    "lockdown": {
        "trigger": "велика загроза",
        "guard_count": 50,
        "patrol_frequency": "maximum",
        "access_restrictions": "curfew",
        "merchant_prices": 0,  # Закриті
        "duration": "48 годин"
    },
    "siege": {
        "trigger": "напад на місто",
        "guard_count": 100,
        "patrol_frequency": "war",
        "access_restrictions": "combat_only",
        "merchant_prices": 0,
        "special": "Бойові дії на вулицях"
    }
}
```

### Райони та Їхні Цикли
```gdscript
var valkorn_districts_cycles = {
    "upper_city": {
        "day": "Аристократи, торгівля, патрулі",
        "night": "Патрулі, порожньо",
        "access": "Потрібен пропуск вночі"
    },
    "industrial": {
        "day": "Шум машин, робітники",
        "night": "Порожньо, злодії",
        "access": "Вільний"
    },
    "docks": {
        "day": "Розвантаження, торгівля",
        "night": "Контрабанда, п'яні матроси",
        "access": "Вільний"
    },
    "slums": {
        "day": "Звичайне життя",
        "night": "Небезпечна зона, банди",
        "access": "Вільний, але ризиковано"
    },
    "cathedral_district": {
        "day": "Паломники, служби",
        "night": "Тиша, молитви",
        "access": "Вільний, але вночі лише віряни"
    }
}
```

---

## ⛴️ Сонк-Феррі (Sonk-Ferry)

### Розклад Порома
```gdscript
var ferry_schedule = {
    "to_valkorn": ["06:00", "09:00", "12:00", "15:00", "18:00", "21:00"],
    "to_greyford": ["07:00", "10:00", "13:00", "16:00", "19:00", "22:00"],
    "special_night": ["00:00"],  # Таємний рейс
    "price": 5,
    "night_price": 15,
    "requirements": {
        "00:00": "знати пароль 'Тиха вода' або мати 20 репутації з контрабандистами"
    }
}

# Поки порома немає — локація відрізана
func is_ferry_available():
    var current_time = get_time_string()
    
    # Вдень — звичайний розклад
    if current_time in ferry_schedule.to_valkorn \
       or current_time in ferry_schedule.to_greyford:
        return true
    
    # Опівночі — таємний рейс
    if current_time == "00:00":
        return has_ferry_password() or reputation["Smugglers"] >= 20
    
    return false
```

### Життя Селища
```gdscript
var sonk_ferry_daily = {
    "dawn": {
        "description": "Рибалки лагодять сіті, поромник готує човен",
        "merchants": ["рибний ринок"]
    },
    "day": {
        "description": "Прибуття/відправлення порома, торговці",
        "merchants": ["рибний ринок", "заїжджий торговець"]
    },
    "dusk": {
        "description": "Пором іде в останній рейс, таверна наповнюється",
        "merchants": ["таверна", "підпільний шинок"]
    },
    "night": {
        "description": "Тиша, тільки таверна працює",
        "merchants": ["таверна (до 02:00)"]
    }
}
```

---

## 🏛️ Тихий Шелест (Whisper's Rest / Muri Village)

### Фази Місяця та Селище
```gdscript
var muri_moon_phases = {
    "new_moon": {
        "visual": "Селище зникає в темряві",
        "inhabitants": "вдвічі менше",
        "moor_presence": "+50%",
        "special": "Примарні жителі ходять вулицями"
    },
    "waxing": {
        "visual": "Звичайний стан",
        "inhabitants": "норма",
        "moor_presence": "normal"
    },
    "full_moon": {
        "visual": "Селище залите білим світлом",
        "inhabitants": "всі ховаються",
        "moor_presence": "+100%",
        "special": "Моур говорить через жителів"
    }
}
```

### Жителі
```gdscript
var muri_villagers_daily = {
    "day": {
        "visible": ["старійшина", "діти", "ремісники"],
        "dialogue": "звичайні теми",
        "quests": "доступні"
    },
    "night": {
        "visible": ["старійшина (вдома)", "вартові"],
        "dialogue": "шепіт, застереження",
        "quests": "обмежені"
    },
    "full_moon_night": {
        "visible": ["всі, але з білими очима"],
        "dialogue": "голос Моура через них",
        "quests": "тільки квести Моура"
    }
}
```

---

## 🌐 Глобальні Події для Локацій

### Зміна Сезонів
```gdscript
var seasonal_location_changes = {
    "spring": {
        "greyford": "Ринок квітів, фестиваль посадки",
        "swamps": "Повінь, цвітіння болотяних рослин",
        "valkorn": "Великий ярмарок",
        "sonk_ferry": "Розклад порома розширено"
    },
    "summer": {
        "greyford": "Спекотно, більше активності",
        "swamps": "Випаровування, отруйні міазми",
        "valkorn": "Аристократи виїжджають за місто",
        "sonk_ferry": "Туристи, багато поромів"
    },
    "autumn": {
        "greyford": "Збір врожаю, фестиваль врожаю",
        "swamps": "Туман, грибний сезон",
        "valkorn": "Підготовка до зими, розпродаж",
        "sonk_ferry": "Останні рейси перед зимою"
    },
    "winter": {
        "greyford": "Холод, менше активності на вулиці",
        "swamps": "Частково замерзають, нові стежки",
        "valkorn": "Різдвяний ярмарок, свята",
        "sonk_ferry": "Пором не ходить (лід)"
    }
}
```

### Наслідки Дій Гравця
```gdscript
var player_actions_consequences = [
    {
        "action": "вбити старійшину Грейфорду",
        "effects": {
            "greyford": {
                "population": -50,
                "economy": -30,
                "guard_count": +10,
                "mood": "fearful"
            },
            "valkorn": {
                "reaction": "розслідування",
                "guard_patrols": true
            }
        }
    },
    {
        "action": "знищити схрон контрабандистів",
        "effects": {
            "greyford": "economy +10, border control -5",
            "sonk_ferry": "smuggler_activity -50",
            "valkorn": "warehouse_prices -10"
        }
    },
    {
        "action": "очистити болото від культу",
        "effects": {
            "muris": "reputation +30, moor_power -20",
            "swamps": "corruption -30, creature_density -40"
        }
    }
]
```

---

## 🎨 Візуальна Реалізація

### Зміна Кольорової Палітри
```gdscript
func get_location_palette(location, time, weather):
    var base_palette = location_palettes[location]
    
    match time:
        TIME_STATE.DAWN:
            return blend_colors(base_palette.day, base_palette.dawn, 0.5)
        TIME_STATE.NIGHT:
            return apply_night_filter(base_palette.day, 0.6)
        TIME_STATE.DEEP_NIGHT:
            return apply_night_filter(base_palette.day, 0.8)
    
    match weather:
        WEATHER.FOG:
            return apply_fog_filter(palette, 0.4)
        WEATHER.RAIN:
            return apply_rain_filter(palette, 0.3)
        WEATHER.MOOR_MIST:
            return apply_moor_filter(palette, 0.7)
    
    return base_palette[time]
```

### Аудіо Атмосфера
```gdscript
func get_location_audio(location, time, weather):
    var audio_layers = []
    
    # Базовий амбієнт
    audio_layers.append(location_ambient[location])
    
    # Часова зміна
    match time:
        TIME_STATE.NIGHT:
            audio_layers.append("night_crickets")
            audio_layers.append("distant_howls")
        TIME_STATE.DAWN:
            audio_layers.append("birds")
    
    # Погода
    match weather:
        WEATHER.RAIN:
            audio_layers.append("rain_heavy")
        WEATHER.STORM:
            audio_layers.append("thunder")
    
    return audio_layers
```
