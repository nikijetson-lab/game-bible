extends Node
## Save Manager - Система збереження/завантаження гри
## Автор: nikijetson-lab

class_name SaveManager

# Шлях до папки збережень
const SAVE_DIR = "user://saves/"
const SAVE_EXTENSION = ".save"
const MAX_SAVE_SLOTS = 5

# Сигнали
signal game_saved(slot: int)
signal game_loaded(slot: int)
signal save_failed(error: String)

func _ready() -> void:
	print("SaveManager initialized")
	ensure_save_directory()

func ensure_save_directory() -> void:
	"""Створити папку для збережень якщо не існує"""
	var dir = DirAccess.open("user://")
	if dir and not dir.dir_exists("saves"):
		dir.make_dir("saves")
		print("Created saves directory")

func save_game(slot: int = 0) -> bool:
	"""Зберегти гру в слот"""
	if slot < 0 or slot >= MAX_SAVE_SLOTS:
		push_error("Invalid save slot: " + str(slot))
		save_failed.emit("Invalid save slot")
		return false
	
	var save_data = gather_save_data()
	var save_path = get_save_path(slot)
	
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file == null:
		var error = "Failed to open save file: " + save_path
		push_error(error)
		save_failed.emit(error)
		return false
	
	# Серіалізувати в JSON
	var json_string = JSON.stringify(save_data, "\t")
	file.store_string(json_string)
	file.close()
	
	print("Game saved to slot ", slot)
	game_saved.emit(slot)
	return true

func load_game(slot: int = 0) -> bool:
	"""Завантажити гру зі слоту"""
	if slot < 0 or slot >= MAX_SAVE_SLOTS:
		push_error("Invalid save slot: " + str(slot))
		return false
	
	var save_path = get_save_path(slot)
	
	if not FileAccess.file_exists(save_path):
		push_error("Save file does not exist: " + save_path)
		return false
	
	var file = FileAccess.open(save_path, FileAccess.READ)
	if file == null:
		push_error("Failed to open save file: " + save_path)
		return false
	
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(json_string)
	
	if error != OK:
		push_error("Failed to parse save file JSON")
		return false
	
	var save_data: Dictionary = json.data
	apply_save_data(save_data)
	
	print("Game loaded from slot ", slot)
	game_loaded.emit(slot)
	return true

func gather_save_data() -> Dictionary:
	"""Зібрати всі дані для збереження"""
	var data = {
		"version": "1.0",
		"timestamp": Time.get_unix_time_from_system(),
		"playtime": 0.0,  # TODO: Track playtime
		
		# Player state
		"player": {
			"position": Vector3.ZERO,  # TODO: Get from player
			"rotation": 0.0,
			"health": 100,
			"stamina": 100,
			# TODO: Player stats, equipment, inventory
		},
		
		# World state
		"world": {
			"current_scene": GameManager.current_scene,
		},
		
		# Quest system
		"quests": GameManager.quest_manager.save_data(),
		
		# Reputation system
		"reputation": GameManager.reputation_manager.save_data(),
		
		# Dialogue state
		# TODO: Track completed dialogues, NPC states
		
		# Global flags
		"flags": {},  # TODO: Global flags system
	}
	
	return data

func apply_save_data(data: Dictionary) -> void:
	"""Застосувати завантажені дані"""
	# Версія (для сумісності)
	var version = data.get("version", "unknown")
	print("Loading save version: ", version)
	
	# Player state
	if data.has("player"):
		var player_data = data["player"]
		# TODO: Apply to player character
		# - Position
		# - Stats
		# - Inventory
		# - Equipment
	
	# World state
	if data.has("world"):
		var world_data = data["world"]
		var scene_path = world_data.get("current_scene", "")
		if scene_path != "":
			GameManager.change_scene(scene_path)
	
	# Quest system
	if data.has("quests"):
		GameManager.quest_manager.load_data(data["quests"])
	
	# Reputation system
	if data.has("reputation"):
		GameManager.reputation_manager.load_data(data["reputation"])
	
	# Global flags
	if data.has("flags"):
		# TODO: Apply global flags
		pass

func get_save_path(slot: int) -> String:
	"""Отримати шлях до файлу збереження"""
	return SAVE_DIR + "slot_" + str(slot) + SAVE_EXTENSION

func save_exists(slot: int) -> bool:
	"""Перевірити чи існує збереження в слоті"""
	return FileAccess.file_exists(get_save_path(slot))

func get_save_info(slot: int) -> Dictionary:
	"""Отримати інформацію про збереження (для UI меню)"""
	if not save_exists(slot):
		return {
			"exists": false,
			"slot": slot
		}
	
	var save_path = get_save_path(slot)
	var file = FileAccess.open(save_path, FileAccess.READ)
	
	if file == null:
		return {"exists": false, "slot": slot}
	
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	if json.parse(json_string) != OK:
		return {"exists": false, "slot": slot}
	
	var data: Dictionary = json.data
	
	return {
		"exists": true,
		"slot": slot,
		"timestamp": data.get("timestamp", 0),
		"playtime": data.get("playtime", 0),
		"version": data.get("version", "unknown"),
		"scene": data.get("world", {}).get("current_scene", "Unknown"),
	}

func delete_save(slot: int) -> bool:
	"""Видалити збереження"""
	if not save_exists(slot):
		return false
	
	var save_path = get_save_path(slot)
	var dir = DirAccess.open(SAVE_DIR)
	
	if dir:
		dir.remove(save_path)
		print("Deleted save slot ", slot)
		return true
	else:
		push_error("Failed to delete save: " + save_path)
		return false

func get_all_saves() -> Array:
	"""Отримати інформацію про всі слоти (для UI)"""
	var saves = []
	for slot in range(MAX_SAVE_SLOTS):
		saves.append(get_save_info(slot))
	return saves

# Auto-save функція
func auto_save() -> void:
	"""Автоматичне збереження (на checkpoint)"""
	# Використовуємо слот 0 для auto-save
	save_game(0)
	print("Auto-saved")

# Quick save/load (клавіші F5/F9)
func quick_save() -> void:
	"""Швидке збереження"""
	save_game(1)  # Використовуємо слот 1 для quick save

func quick_load() -> void:
	"""Швидке завантаження"""
	if save_exists(1):
		load_game(1)
	else:
		push_warning("No quick save found")
