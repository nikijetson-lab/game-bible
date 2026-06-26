# 🧪 Тестові Сценарії

## Test 1: Рух та Взаємодія
```gdscript
func test_movement():
    var player = Player.new()
    var start_pos = Vector2(100, 100)
    player.global_position = start_pos
    
    # Рух вправо
    player.move(Vector2.RIGHT)
    assert(player.global_position.x > start_pos.x, "Рух вправо не працює")
    
    # Взаємодія з NPC
    var npc = NPC.new()
    npc.global_position = player.global_position + Vector2(10, 0)
    player.interact()
    assert(npc.dialogue_active, "Діалог не активувався")
    
    print("✅ Test 1: Рух та взаємодія — OK")
```

## Test 2: Бойова Система
```gdscript
func test_combat():
    var player = Player.new()
    player.health = 100
    
    var enemy = Enemy.new()
    enemy.health = 50
    enemy.damage = 10
    
    # Гравець атакує
    player.attack(enemy)
    assert(enemy.health < 50, "Ворог не отримав шкоду")
    
    # Ворог атакує у відповідь
    enemy.attack(player)
    assert(player.health < 100, "Гравець не отримав шкоду")
    
    # Смерть ворога
    enemy.health = 0
    assert(enemy.is_dead(), "Ворог не помер")
    
    print("✅ Test 2: Бойова система — OK")
```

## Test 3: Квести та Репутація
```gdscript
func test_quests():
    # Прийняти квест
    var result = QuestSystem.accept_quest("blood_for_moor")
    assert(result, "Квест не прийнявся")
    
    # Прогрес
    QuestSystem.add_progress("blood_for_moor", "kill_cultists")
    var quest = QuestSystem.get_quest("blood_for_moor")
    assert(quest.progress > 0, "Прогрес не оновився")
    
    # Репутація
    ReputationSystem.modify_reputation("Muri", -20)
    assert(ReputationSystem.get_faction_standing("Muri") < 0, "Репутація не змінилась")
    
    print("✅ Test 3: Квести та репутація — OK")
```

## Test 4: Інвентар та Крафт
```gdscript
func test_inventory():
    # Додати предмет
    var result = Inventory.add_item("swamp_herb", 5)
    assert(result, "Предмет не додався")
    assert(Inventory.get_item_count("swamp_herb") == 5, "Неправильна кількість")
    
    # Крафт
    var recipe = CraftingSystem.get_recipe("health_potion")
    assert(recipe != null, "Рецепт не знайдено")
    
    var crafted = CraftingSystem.craft("health_potion")
    assert(crafted, "Крафт не вдався")
    assert(Inventory.has_item("health_potion"), "Зілля не створилось")
    
    print("✅ Test 4: Інвентар та крафт — OK")
```

## Test 5: Збереження та Завантаження
```gdscript
func test_save_load():
    # Налаштувати стан
    Player.health = 50
    Player.mana = 30
    Inventory.add_item("gold", 100)
    QuestSystem.accept_quest("test_quest")
    
    # Зберегти
    var saved = SaveSystem.save_game(1)
    assert(saved, "Збереження не вдалось")
    
    # Змінити стан
    Player.health = 100
    Player.mana = 100
    Inventory.remove_item("gold", 100)
    
    # Завантажити
    var loaded = SaveSystem.load_game(1)
    assert(loaded, "Завантаження не вдалось")
    assert(Player.health == 50, "Здоров'я не відновилось")
    assert(Player.mana == 30, "Мана не відновилась")
    assert(Inventory.has_item("gold"), "Золото не відновилось")
    
    print("✅ Test 5: Збереження/завантаження — OK")
```
