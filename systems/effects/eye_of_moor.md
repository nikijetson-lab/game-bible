# 👁️ Око Моура — Третє Око

## Концепція
Давній артефакт, знайдений у Затопленій Обителі. Фрагмент свідомості самого Моура. Дозволяє бачити приховане... але ціна — постійний зв'язок з болотом.

## Отримання
```gdscript
func obtain_eye_of_moor():
    # Знайти в Затопленій Обителі
    # Потрібен ключ-амулет (квест "Серце Обителі")
    
    var dialogue = DialogueSystem.create_scene()
    dialogue.add_line("Ти знайшов мене...")
    dialogue.add_line("Я — Око Моура. Я бачу те, що приховано.")
    dialogue.add_choice("Прийняти дар", "activate_eye")
    dialogue.add_choice("Відмовитись", "refuse_eye")
    
    if choice == "activate_eye":
        activate_eye_of_moor()
    else:
        quest_item = "fragment_of_eye"  # Можна продати за 500 gold
```

## Механіка

### Активація
```gdscript
class_name EyeOfMoor

var is_active = false
var energy = 100  # 0-100
var tier = 1  # 1-5

func activate_eye():
    is_active = true
    # Око займає слот аксесуара
    EquipmentSystem.equip("accessory", "eye_of_moor")
    
    # Базові ефекти
    show_hidden_passages()
    show_invisible_enemies(radius=10)
    show_trap_locations(radius=5)
    
    # Постійний ефект
    MoorCorruptionSystem.corruption_rate *= 0.5  # Захищає від спотворення
    MoorCorruptionSystem.add_effect("moor_connection")
```

### Рівні Ока
```gdscript
var eye_tiers = {
    1: {
        "name": "Пробуджене Око",
        "effects": {
            "hidden_passages": true,
            "invisible_radius": 10,
            "trap_radius": 5,
            "energy_drain": 0.5  # Одиниць/сек при використанні
        },
        "vision_mod": Color(0.1, 0.3, 0.5, 0.3)  # Легкий синій фільтр
    },
    2: {
        "name": "Око Правди",
        "effects": {
            "hidden_passages": true,
            "invisible_radius": 20,
            "trap_radius": 10,
            "see_through_walls": 5,  # метрів
            "see_enemy_health": true,
            "energy_drain": 1.0
        },
        "vision_mod": Color(0.2, 0.5, 0.8, 0.4)
    },
    3: {
        "name": "Око Сутності",
        "effects": {
            "hidden_passages": true,
            "invisible_radius": 30,
            "trap_radius": 15,
            "see_through_walls": 10,
            "see_enemy_health": true,
            "see_enemy_level": true,
            "see_loot_quality": true,
            "energy_drain": 2.0
        },
        "vision_mod": Color(0.3, 0.6, 1.0, 0.5)
    },
    4: {
        "name": "Око Безодні",
        "effects": {
            "hidden_passages": true,
            "invisible_radius": 50,
            "trap_radius": 25,
            "see_through_walls": 20,
            "see_enemy_health": true,
            "see_enemy_level": true,
            "see_loot_quality": true,
            "see_alternative_dialogues": true,
            "energy_drain": 3.0
        },
        "vision_mod": Color(0.5, 0.8, 1.0, 0.6)
    },
    5: {
        "name": "Око Моура (Повне)",
        "effects": {
            "hidden_passages": true,
            "invisible_radius": 100,
            "trap_radius": 50,
            "see_through_walls": 50,
            "see_enemy_health": true,
            "see_enemy_level": true,
            "see_loot_quality": true,
            "see_alternative_dialogues": true,
            "see_weak_points": true,
            "see_quest_consequences": true,
            "energy_drain": 0  # Моур тепер годує око
        },
        "vision_mod": Color(0.8, 1.0, 1.0, 0.8)
    }
}
```

### Прокачка Ока
```gdscript
func upgrade_eye():
    var requirements = {
        2: {"moor_rep": 20, "eye_usage_hours": 10, "item": "essence_of_truth"},
        3: {"moor_rep": 40, "eye_usage_hours": 25, "item": "essence_of_essence"},
        4: {"moor_rep": 60, "eye_usage_hours": 50, "item": "essence_of_void"},
        5: {"moor_rep": 80, "eye_usage_hours": 100, "item": "essence_of_moor"}
    }
    
    var req = requirements[tier + 1]
    if ReputationSystem.faction_standing["Muri"] >= req.moor_rep \
       and eye_usage_hours >= req.eye_usage_hours \
       and Inventory.has_item(req.item):
        tier += 1
        apply_tier_effects(eye_tiers[tier])
        return true
    return false
```

## Можливості

### Приховані Проходи
```gdscript
func show_hidden_passages():
    # Позначає на міні-карті та у світі
    for passage in GameManager.get_hidden_passages():
        if distance_to_player(passage) < current_effects.see_through_walls:
            passage.visible = true
            passage.highlight(Color.AQUA)
```

### Невидимі Вороги
```gdscript
func show_invisible_enemies():
    for enemy in get_tree().get_nodes_in_group("invisible"):
        if distance_to_player(enemy) < current_effects.invisible_radius:
            enemy.modulate.a = 0.5  # Напівпрозорі
            enemy.show_health_bar()
```

### Альтернативні Діалоги
```gdscript
func see_alternative_dialogues():
    # Показує приховані варіанти діалогів
    for npc in get_tree().get_nodes_in_group("npc"):
        if distance_to_player(npc) < 20:
            # Показує справжні наміри NPC
            npc.show_hidden_intent()
            # Справжнє ім'я (якщо приховує)
            npc.show_true_name()
```

## Побічні Ефекти

### Енергія Ока
```gdscript
func drain_energy(delta):
    if is_active and current_effects.energy_drain > 0:
        energy -= current_effects.energy_drain * delta
        if energy <= 0:
            deactivate_eye()
            apply_overdose_effect()

func recharge_energy():
    # Пасивна регенерація
    energy += 2.0 * get_process_delta_time()
    energy = min(energy, 100)
    
    # Активна регенерація (в болотах)
    if GameManager.current_biome == "swamp":
        energy += 5.0 * get_process_delta_time()
```

### Спотворення від Ока
```gdscript
func eye_corruption_effects():
    match tier:
        1:
            # Іноді бачите тіні
            spawn_random_shadow()
        2:
            # Чуєте голоси
            play_whisper_random()
        3:
            # Бачите справжню сутність людей
            show_true_form_random_npc()
            # (Вони можуть бути монстрами)
        4:
            # Не можете відрізнити реальність від бачення
            if randf() < 0.1:
                swap_reality()
        5:
            # Ви — частина Моура
            MoorCorpusSystem.merge_with_player()
            # Гравець отримує +50% до всього, але втрачає контроль
```

### Симптоми Передозування
```gdscript
func apply_overdose_effect():
    var effects_table = {
        "blindness": {"duration": 30.0, "severity": 1.0},
        "screaming_voices": {"duration": 60.0, "severity": 0.5},
        "hallucinations": {"duration": 45.0, "severity": 0.7},
        "temporary_death": {"duration": 10.0},  # Імітація смерті
        "moor_vision": {"duration": 20.0, "severity": 2.0}
    }
    
    var overdose_effect = effects_table.pick_random()
    apply_effect(overdose_effect)
    energy = max(0, energy - 30)  # Штраф
```

## Інтеграція з Іншими Системами

### З Moor Whispers
```gdscript
func moor_whispers_synergy():
    # Око зменшує спотворення, але створює власні
    if is_active and tier >= 3:
        MoorCorruptionSystem.corruption_rate *= 0.3
        # Замість спотворення — "Просвітлення"
        MoorCorruptionSystem.add_effect("moor_enlightenment")
```

### З Живими Мечами
```gdscript
func living_sword_synergy():
    # Око бачить слабкі місця ворогів
    if is_active and tier >= 3:
        LivingSwordSystem.critical_chance += 0.1 * tier
        LivingSwordSystem.show_weak_points(true)
```

### З Динамічним Світом
```gdscript
func dynamic_world_synergy():
    # Око бачить майбутні події
    if is_active and tier >= 4:
        WorldEventSystem.show_upcoming_events(3)  # Показати наступні 3 події
        WorldEventSystem.show_event_consequences()
```

## UI для Ока

```gdscript
class EyeOfMoorUI:
    func draw_eye_interface():
        # Індикатор енергії
        var energy_bar = TextureProgress.new()
        energy_bar.texture_progress = preload("res://ui/eye_energy_bar.png")
        energy_bar.value = EyeOfMoor.energy
        
        # Рівень Ока
        var tier_icon = TextureRect.new()
        tier_icon.texture = preload("res://ui/eye_tier_" + str(EyeOfMoor.tier) + ".png")
        
        # Список активних ефектів
        var effects_list = VBoxContainer.new()
        for effect in EyeOfMoor.get_active_effects():
            var label = Label.new(effect.name)
            label.modulate = Color(0.5, 0.8, 1.0)
            effects_list.add_child(label)
        
        # Кнопка деактивації
        var deactivate_btn = Button.new("Закрити Око")
        deactivate_btn.pressed = func(): EyeOfMoor.deactivate_eye()
```
