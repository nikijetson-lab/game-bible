extends SceneTree
## Smoke test for WorldMap + MapManager
## Run: godot --headless --path . --script res://tests/smoke_world_map.gd

func _init() -> void:
	var failures: Array[String] = []

	# 1. Check world_map.json loads
	var world_json: Variant = load("res://data/world_map.json")
	if world_json == null:
		failures.append("Failed to load world_map.json directly (expected — it's JSON, not a resource)")

	var file: FileAccess = FileAccess.open("res://data/world_map.json", FileAccess.READ)
	if file == null:
		failures.append("Failed to open world_map.json")
	else:
		var text: String = file.get_as_text()
		file.close()
		var json: Variant = JSON.new()
		var err: Variant = json.parse(text)
		if err != OK:
			failures.append("world_map.json parse error: " + json.get_error_message())
		else:
			var data = json.data
			var regions: int = data.get("regions", {}).size()
			var conns: int = data.get("connections", []).size()
			print("world_map.json OK: %d regions, %d connections" % [regions, conns])
			if regions < 8:
				failures.append("Expected >= 8 regions, got %d" % regions)
			if conns < 7:
				failures.append("Expected >= 7 connections, got %d" % conns)

	# 2. Check MapManager script loads
	var mm_script: Variant = load("res://scripts/core/map_manager.gd")
	if mm_script == null:
		failures.append("Failed to load map_manager.gd")
	else:
		print("map_manager.gd OK")

	# 3. Check WorldMap script loads
	var wm_script: Variant = load("res://scripts/gameplay/WorldMap.gd")
	if wm_script == null:
		failures.append("Failed to load WorldMap.gd")
	else:
		print("WorldMap.gd OK")

	# 4. Check WorldMap scene loads
	var wm_packed: Variant = load("res://scenes/map/WorldMap.tscn")
	if wm_packed == null:
		failures.append("Failed to load WorldMap.tscn")
	else:
		var wm_instance = wm_packed.instantiate()
		if wm_instance == null:
			failures.append("Failed to instantiate WorldMap.tscn")
		else:
			print("WorldMap.tscn OK: ", wm_instance.get_class())
			wm_instance.queue_free()

	# 5. Check world map texture
	var img: Variant = Image.new()
	var tex_err: Variant = img.load("res://assets/textures/world_map.webp")
	if tex_err != OK:
		failures.append("Failed to load world_map.webp texture (err=%d)" % tex_err)
	else:
		print("world_map.webp OK: %dx%d" % [img.get_width(), img.get_height()])

	# 6. Check MapManager is registered in project.godot
	var pfile: FileAccess = FileAccess.open("res://project.godot", FileAccess.READ)
	if pfile == null:
		failures.append("Failed to open project.godot")
	else:
		var ptext: String = pfile.get_as_text()
		pfile.close()
		if "MapManager=" not in ptext:
			failures.append("MapManager NOT registered in project.godot [autoload]")
		else:
			print("MapManager autoload registration OK")

	# Result
	if failures.is_empty():
		print("WORLD_MAP_SMOKE_OK")
		quit(0)
	else:
		for f in failures:
			push_error(f)
		quit(1)
