# 🛒 Система Торгівлі

```gdscript
# shop.gd
extends Control

var current_merchant: NPC
var player_gold: int

func open_shop(npc: NPC):
    current_merchant = npc
    player_gold = Player.inventory.get_gold()
    
    $MerchantName.text = npc.name
    $ReputationLabel.text = "Репутація: " + str(ReputationSystem.get_faction_standing(npc.faction))
    
    show_merchant_items()
    show_player_items()

func show_merchant_items():
    $MerchantInventory.clear()
    for item in current_merchant.shop_items:
        var price = calculate_price(item, "buy")
        $MerchantInventory.add_item(item.name + " - " + str(price) + "💰")

func calculate_price(item: Item, action: String) -> int:
    var base = item.base_price
    match action:
        "buy":
            return int(base * (1.0 + ReputationSystem.get_price_modifier(current_merchant.faction)))
        "sell":
            return int(base * 0.5 * (1.0 + ReputationSystem.get_price_modifier(current_merchant.faction)))

func _on_buy_pressed(item_id: String):
    var price = calculate_price(ItemDatabase.get(item_id), "buy")
    if player_gold >= price:
        player_gold -= price
        Inventory.add_item(item_id)
        update_ui()
    else:
        $ErrorLabel.text = "Недостатньо золота!"
```

## Система Крадіжки

```gdscript
# stealth_system.gd
extends Node

var is_hidden = false
var noise_level = 0.0
var detection_meter = 0.0

func enter_stealth():
    if Player.can_stealth():
        is_hidden = true
        Player.set_modulate(Color(1, 1, 1, 0.5))
        $StealthUI.visible = true

func exit_stealth():
    is_hidden = false
    Player.set_modulate(Color.WHITE)
    $StealthUI.visible = false

func try_pickpocket(npc: NPC) -> bool:
    if not is_hidden:
        return false
    
    var chance = 50 - detection_meter
    if randi() % 100 < chance:
        var loot = npc.inventory.get_random_item()
        Inventory.add_item(loot.id)
        npc.inventory.remove_item(loot.id)
        return true
    else:
        detection_meter += 30
        npc.alert()
        return false

func _process(delta):
    if is_hidden:
        # Пасивне накопичення шуму
        noise_level += delta * 1.0
        
        # Біг створює шум
        if Input.is_action_pressed("sprint"):
            noise_level += delta * 5.0
        
        # Детекція ворогів
        detection_meter = max(0, detection_meter - delta * 2.0)
        
        if noise_level > 100:
            exit_stealth()
            noise_level = 0.0

## Система Зламування Замків

func lockpick(lock_difficulty: int) -> bool:
    if not Inventory.has_item("lockpick"):
        show_message("Потрібна відмичка!")
        return false
    
    var skill = Player.skills.lockpicking
    var chance = skill * 10 - lock_difficulty * 5
    
    if randi() % 100 < chance:
        Inventory.remove_one("lockpick")
        show_message("Замок відкрито!")
        return true
    else:
        Inventory.remove_one("lockpick")
        show_message("Відмичка зламалась!")
        return false
```
