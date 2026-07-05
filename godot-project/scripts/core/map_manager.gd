extends Node
## MapManager — Autoload для керування мапою світу
## Відповідає за: стан відкриття локацій, подорожі між регіонами,
## відстеження поточного регіону гравця.

signal region_discovered(region_id: String)
signal region_entered(region_id: String)
signal travel_started(from_region: String, to_region: String, travel_time: int)

# Дані мапи
var world_data: Dictionary = {}

# Поточний регіон (де зараз гравець)
var current_region: String = "greyford"

# Відкриті регіони (ids)
var discovered_regions: Array[String] = ["greyford"]

# WorldMap UI сцена
var world_map_ui: Control = null

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_load_map_data()
	_instantiate_map_ui()
	print("MapManager initialized. Current region: ", current_region)

func _load_map_data() -> void:
	var file := FileAccess.open("res://data/world_map.json", FileAccess.READ)
	if file == null:
		push_error("MapManager: Failed to load world_map.json")
		return
	var text := file.get_as_text()
	file.close()
	var json := JSON.new()
	var err := json.parse(text)
	if err != OK:
		push_error("MapManager: JSON parse error: ", json.get_error_message())
		return
	world_data = json.data
	# Restore discovered state
	if world_data.has("regions"):
		for region_id in world_data.regions:
			if world_data.regions[region_id].get("discovered", false):
				if region_id not in discovered_regions:
					discovered_regions.append(region_id)

func _instantiate_map_ui() -> void:
	"""Створює WorldMap UI як дочірню сцену при старті"""
	var packed := load("res://scenes/map/WorldMap.tscn")
	if packed == null:
		push_error("MapManager: Failed to load WorldMap.tscn")
		return
	world_map_ui = packed.instantiate()
	if world_map_ui == null:
		push_error("MapManager: Failed to instantiate WorldMap")
		return
	get_tree().root.call_deferred("add_child", world_map_ui)

func is_region_discovered(region_id: String) -> bool:
	return region_id in discovered_regions

func discover_region(region_id: String) -> void:
	if region_id in discovered_regions:
		return
	discovered_regions.append(region_id)
	if world_data.has("regions") and world_data.regions.has(region_id):
		world_data.regions[region_id]["discovered"] = true
	region_discovered.emit(region_id)
	print("MapManager: Region discovered — ", region_id)

func enter_region(region_id: String) -> void:
	current_region = region_id
	discover_region(region_id)
	region_entered.emit(region_id)
	print("MapManager: Entered region — ", region_id)

func can_travel_to(region_id: String) -> bool:
	"""Перевіряє чи можна подорожувати до регіону (він відкритий)"""
	return is_region_discovered(region_id)

func get_connection(from_id: String, to_id: String) -> Dictionary:
	"""Повертає дані про зв'язок між двома регіонами"""
	for conn in world_data.get("connections", []):
		if conn.from_region == from_id and conn.to == to_id:
			return conn
		if conn.from == from_id and conn.to == to_id:
			return conn
	return {}

func get_available_connections(from_id: String) -> Array:
	"""Повертає список доступних для подорожі регіонів із поточного"""
	var available: Array = []
	for conn in world_data.get("connections", []):
		var source: String = conn.get("from", "")
		if source == from_id or conn.get("from_region", "") == from_id:
			var target: String = conn.get("to", "")
			if is_region_discovered(target):
				available.append({"region": target, "connection": conn})
	return available

func get_region_entry_scene(region_id: String) -> String:
	"""Повертає шлях до вхідної сцени регіону"""
	if world_data.has("regions") and world_data.regions.has(region_id):
		return world_data.regions[region_id].get("entry_scene", "")
	return ""

func travel_to_region(to_region: String) -> void:
	"""Виконати подорож до регіону"""
	var conn := get_connection(current_region, to_region)
	if conn.is_empty():
		push_error("MapManager: No connection from ", current_region, " to ", to_region)
		return

	var travel_time: int = conn.get("travel_time_minutes", 60)
	travel_started.emit(current_region, to_region, travel_time)

	var entry_scene := get_region_entry_scene(to_region)
	if entry_scene != "":
		var result := get_tree().change_scene_to_file(entry_scene)
		if result == OK:
			enter_region(to_region)
		else:
			push_error("MapManager: Failed to load entry scene: ", entry_scene)
	else:
		enter_region(to_region)
		print("MapManager: Traveled to ", to_region, " (no entry scene)")
