# 😈 Культисти Моура — фракція безумства

## Сутність
Культисти — це ті, хто почув голос болота і відповів на нього. Вони живуть у глибині Хейзмуру, поклоняючись живій свідомості болота.

## Ієрархія

### 1. Болотяні Посланці (рядові)
```gdscript
class_name SwampMessenger
extends NPC

var abilities = [
    "call_swamp",       # Викликає болотяну пастку
    "poison_breath",    # Отруйний подих
    "sacrificial_cry"   # Прикликає підкріплення
]

var loot_table = {
    "common": ["болотяна_слиз", "гнилий_амулет"],
    "rare": ["ключ_від_склепу"]
}
```

### 2. Різьбярі Кісток (еліта)
```gdscript
class_name BoneCarver
extends NPC

var abilities = [
    "bone_shield",      # Кістяний щит
    "necromantic_touch", # Піднімає мертвих
    "bone_storm"        # Шторм кісток
]

var corruption_aura = 10  # Щосекунди +10 спотворення поруч
```

### 3. Верховний Жрець (бос)
```gdscript
class_name HighPriest
extends Boss

var phases = [
    {"hp": 100, "ability": "sacrifice_cultist"},  # Жертвує культиста для зцілення
    {"hp": 50,  "ability": "open_the_gate"},       # Відкриває портал у Підсвіт
    {"hp": 20,  "ability": "become_avatar"}        # Стає аватаром Моура
]
```

## Локації культу

### Схрон у Болоті
```yaml
location: swamp_hideout
access: only_through_secret_path
features:
  - altar_circle: місце ритуалів
  - bone_pit: яма з кістками жертв
  - forbidden_library: книги з темних мистецтв
guards: 
  - 3 SwampMessengers
  - 1 BoneCarver
loot:
  guaranteed: "ritual_dagger"
  rare: "book_of_bones"
```

### Катакомби Під Валькорном
```yaml
location: under_valkorn
access: trap_door_in_abandoned_house
features:
  - hidden_altar: секретний вівтар
  - sacrificial_chamber: камера для жертвоприношень
  - connection_to_swamp: тунель до болота
danger: high
quest: "Гніздо змії під троном"
```

## Відносини з іншими фракціями

| Фракція | Ставлення | Причина |
|---------|-----------|---------|
| 🏰 Валькорн | Вороги (-80) | Офіційно заборонені |
| 🚢 Сонк-Феррі | Нейтрально (0) | Таємно торгують |
| 🏘️ Ґрейфорд | Вороги (-50) | Вигнані з міста |
| 💀 Контрабандисти | Союзники (+30) | Спільний бізнес (раби) |
| 🤫 Мовчазні | Страх (+10) | Не розуміють |

---

# 💀 Тіньовий Ринок — підпільна економіка

## Концепція
Тіньовий Ринок — це мережа таємних торговців, що працюють поза законом. Тут можна купити заборонені товари, найняти вбивць або продати душу.

## Локації Ринку

### 1. Нічний Причал (Сонк-Феррі)
```yaml
location: night_dock
access: only_at_night (+репутація з контрабандистами >20)
merchants:
  - name: "Сліпий П'єр"
    sells:
      - заборонена_зброя
      - отрути
      - фальшиві_документи
  - name: "Шепітлива Ліза"
    sells:
      - інформація
      - таємні_карти
      - ключі
```

### 2. Підвал "Ржавого Якоря" (Ґрейфорд)
```yaml
location: rusty_anchor_basement
access: пароль_від_шинкаря
features:
  - auction_house: аукціон рідкісних речей
  - fight_club: підпільні бої (ставки + нагороди)
  - fence: скуповує крадене
```

### 3. Покинутий Храм (Валькорн)
```yaml
location: abandoned_temple
access: secret_passage_in_sewers
danger: very_high
merchants:
  - name: "Торгівець Душами"
    currency: souls_of_innocents
    goods:
      - вічне_життя: 50 душ
      - демонічна_зброя: 30 душ
      - забуті_знання: 100 душ
```

## Товари та Послуги

### Зброя
```gdscript
var shadow_weapons = [
    {
        "name": "Кинджал Зради",
        "damage": 25,
        "special": "50% шанс отруїти",
        "cost": 500,
        "reputation_req": {"Smugglers": 30}
    },
    {
        "name": "Меч Забуття",
        "damage": 40,
        "special": "Жертви не залишають тіла",
        "cost": 1200,
        "reputation_req": {"Smugglers": 60}
    },
    {
        "name": "Пістоль Шепота",
        "damage": 35,
        "special": "Безшумний",
        "cost": 800,
        "reputation_req": {"Smugglers": 45}
    }
]
```

### Інформація
```gdscript
var shadow_info = [
    {
        "title": "Місцезнаходження скарбу графа",
        "cost": 300,
        "type": "treasure_map"
    },
    {
        "title": "Слабкість Верховного Жреця",
        "cost": 500,
        "type": "boss_hint"
    },
    {
        "title": "Пароль до катакомб",
        "cost": 200,
        "type": "access_code"
    }
]
```

### Послуги
```gdscript
var shadow_services = [
    {
        "name": "Найманий вбивця",
        "cost": 1000,
        "effect": "NPC зникає через 24 години",
        "reputation_penalty": -20
    },
    {
        "name": "Фальшива репутація",
        "cost": 500,
        "effect": "+30 до фракції на 1 день",
        "risk": "Розкриття = -60 до всіх фракцій"
    },
    {
        "name": "Зняття прокляття",
        "cost": 300,
        "effect": "Знімає прокляття",
        "note": "Не питай як"
    }
]
```

## Система Контрабанди

### Ризик та Винагорода
```gdscript
func calculate_contraband_risk(item_weight: int, location: String):
    var base_risk = item_weight * 10  # 10% за одиницю ваги
    
    match location:
        "Valkorn":
            risk += 30  # Валькорн — максимальна охорона
        "Greyford":
            risk += 15
        "Sonk-Ferry":
            risk += 5   # Розслаблений порт
    
    # Модифікатори від навичок
    risk -= player.skills.smuggling * 2
    
    return clamp(risk, 5, 95)
```

### Результати Перевірки
```gdscript
func contraband_check(risk: int):
    var roll = randi() % 100
    
    if roll < risk:
        # Спіймали
        match location:
            "Valkorn":
                # Конфіскація + арешт
                lose_all_contraband()
                prison_time(48)  # 48 годин у в'язниці
            "Greyford":
                # Хабар
                pay_bribe(randi_range(50, 200))
            "Sonk-Ferry":
                # Легкий штраф
                pay_fine(50)
    else:
        # Успіх
        profit = item_value * 2
        add_reputation("Smugglers", 5)
```

## Репутація на Тіньовому Ринку

### Рівні Доступу
```gdscript
enum SHADOW_ACCESS {
    UNKNOWN = 0,       # Не знають про вас
    NOTICED = 20,      # Помітили, базові товари
    REGULAR = 40,      # Постійний клієнт
    TRUSTED = 60,      # Довіряють, рідкісні товари
    INNER_CIRCLE = 80, # Внутрішнє коло, все
    SHADOW_LORD = 100  # Володар тіні, керує ринком
}
```

### Як Підвищити
- Купувати товари (+1 за кожні 100 витрачених монет)
- Продавати інформацію (+5 за одиницю)
- Виконувати завдання Ринку (+10-20)
- Вбити конкурента (+15)

### Як Втратити
- Співпраця з владою (-30)
- Недоплата (-20)
- Вбивство члена Inner Circle (-50)
- Розкриття таємниць Ринку (-100, назавжди)
