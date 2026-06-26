extends Node
## Inventory Manager - Система інвентаря та предметів
## Автор: nikijetson-lab

class_name InventoryManager

# Сигнали
signal item_added(item: Item, amount: int)
signal item_removed(item: Item, amount: int)
signal item_used(item: Item)
signal inventory_changed

# Інвентар (item_id -> amount)
var inventory: Dictionary = {}

# База даних предметів
var item_database: Dictionary = {}

# Обмеження
const MAX_STACK_SIZE = 99
const MAX_INVENTORY_SIZE = 50  # Максимум різних типів предметів

# Item class
class Item:
	var id: String
	var name: String
	var description: String
	var type: String  # "consumable", "quest", "material", "equipment"
	var icon_path: String
	var stackable: bool = true
	var max_stack: int = 99
	var sellable: bool = true
	var price: int = 0
	
	# Ефекти (для consumables)
	var effects: Dictionary = {}
	
	func _init(data: Dictionary):
		id = data.get("id", "")
		name = data.get("name", "Unknown Item")
		description = data.get("description", "")
		type = data.get("type", "material")
		icon_path = data.get("icon", "")
		stackable = data.get("stackable", true)
		max_stack = data.get("max_stack", 99)
		sellable = data.get("sellable", true)
		price = data.get("price", 0)
		effects = data.get("effects", {})

func _ready() -> void:
	print("InventoryManager initialized")
	load_item_database()

func load_item_database() -> void:
	"""Завантажити базу даних предметів"""
	# TODO: Load from JSON files in res://data/items/
	print("Item database loaded")

func add_item(item_id: String, amount: int = 1) -> bool:
	"""Додати предмет до інвентаря"""
	if amount <= 0:
		push_error("Invalid amount: " + str(amount))
		return false
	
	# Перевірити чи є місце
	if not inventory.has(item_id) and inventory.size() >= MAX_INVENTORY_SIZE:
		push_warning("Inventory is full!")
		return false
	
	# Отримати предмет з database
	var item = get_item_data(item_id)
	if item == null:
		push_error("Item not found in database: " + item_id)
		return false
	
	# Додати або збільшити кількість
	if inventory.has(item_id):
		if item.stackable:
			var new_amount = inventory[item_id] + amount
			inventory[item_id] = min(new_amount, item.max_stack * 10)  # Multiple stacks
		else:
			push_warning("Item is not stackable: " + item_id)
			return false
	else:
		inventory[item_id] = amount
	
	item_added.emit(item, amount)
	inventory_changed.emit()
	print("Added item: %s x%d" % [item.name, amount])
	return true

func remove_item(item_id: String, amount: int = 1) -> bool:
	"""Видалити предмет з інвентаря"""
	if not inventory.has(item_id):
		push_warning("Item not in inventory: " + item_id)
		return false
	
	var current_amount = inventory[item_id]
	
	if current_amount < amount:
		push_warning("Not enough items: " + item_id)
		return false
	
	var item = get_item_data(item_id)
	
	if current_amount == amount:
		inventory.erase(item_id)
	else:
		inventory[item_id] -= amount
	
	item_removed.emit(item, amount)
	inventory_changed.emit()
	print("Removed item: %s x%d" % [item.name, amount])
	return true

func use_item(item_id: String) -> bool:
	"""Використати предмет (consumable)"""
	if not inventory.has(item_id):
		return false
	
	var item = get_item_data(item_id)
	
	if item.type != "consumable":
		push_warning("Item is not consumable: " + item_id)
		return false
	
	# Застосувати ефекти
	apply_item_effects(item)
	
	# Видалити з інвентаря
	remove_item(item_id, 1)
	
	item_used.emit(item)
	print("Used item: ", item.name)
	return true

func apply_item_effects(item: Item) -> void:
	"""Застосувати ефекти предмета"""
	for effect_type in item.effects:
		var effect_value = item.effects[effect_type]
		
		match effect_type:
			"heal":
				# TODO: Heal player
				print("Heal: +%d HP" % effect_value)
			
			"stamina":
				# TODO: Restore stamina
				print("Stamina: +%d" % effect_value)
			
			"buff":
				# TODO: Apply temporary buff
				print("Buff applied: ", effect_value)
			
			_:
				push_warning("Unknown effect type: " + effect_type)

func has_item(item_id: String, amount: int = 1) -> bool:
	"""Перевірити чи є предмет в інвентарі"""
	return inventory.get(item_id, 0) >= amount

func get_item_count(item_id: String) -> int:
	"""Отримати кількість предмета"""
	return inventory.get(item_id, 0)

func get_item_data(item_id: String) -> Item:
	"""Отримати дані предмета з database"""
	if item_database.has(item_id):
		return item_database[item_id]
	
	# Якщо не знайдено, створити placeholder
	return Item.new({
		"id": item_id,
		"name": "Unknown",
		"description": "Item not found in database"
	})

func get_inventory_items() -> Array:
	"""Отримати всі предмети в інвентарі (для UI)"""
	var items = []
	for item_id in inventory:
		var item = get_item_data(item_id)
		var count = inventory[item_id]
		items.append({
			"item": item,
			"count": count
		})
	return items

func clear_inventory() -> void:
	"""Очистити інвентар"""
	inventory.clear()
	inventory_changed.emit()
	print("Inventory cleared")

# Збереження/завантаження
func save_data() -> Dictionary:
	"""Зберегти дані інвентаря"""
	return inventory.duplicate()

func load_data(data: Dictionary) -> void:
	"""Завантажити дані інвентаря"""
	inventory = data.duplicate()
	inventory_changed.emit()

# Crafting helper functions
func has_materials(recipe: Dictionary) -> bool:
	"""Перевірити чи є всі матеріали для крафту"""
	for material_id in recipe:
		var required_amount = recipe[material_id]
		if not has_item(material_id, required_amount):
			return false
	return true

func consume_materials(recipe: Dictionary) -> bool:
	"""Витратити матеріали для крафту"""
	if not has_materials(recipe):
		return false
	
	for material_id in recipe:
		var required_amount = recipe[material_id]
		remove_item(material_id, required_amount)
	
	return true
