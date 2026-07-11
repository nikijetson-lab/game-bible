extends Node3D
## VFXPlayer — програє візуальні ефекти з vfx_catalog.json.
##
## Використовується CutsceneManager для кроків типу "vfx".
## Може бути розміщений у будь-якій сцені для точкових ефектів.
class_name VFXPlayer

var _active_effects: Array[Node] = []

func play(effect_name: String, position: Vector3 = Vector3.ZERO, duration_override: float = -1.0) -> void:
	var catalog := _load_catalog()
	if catalog.is_empty(): return

	var data: Dictionary = catalog.get("effects", {}).get(effect_name, {})
	if data.is_empty():
		push_warning("VFX not found: " + effect_name)
		return

	var etype: String = data.get("type", "")
	match etype:
		"particles": _spawn_particles(data, position, duration_override)
		"point_light": _spawn_light(data, position, duration_override)
		"overlay": _spawn_overlay(data, duration_override)

func _load_catalog() -> Dictionary:
	var path := "res://data/vfx/vfx_catalog.json"
	if not FileAccess.file_exists(path): return {}
	var file := FileAccess.open(path, FileAccess.READ)
	var json := JSON.new()
	if json.parse(file.get_as_text()) != OK: return {}
	file.close()
	return json.data

func _spawn_particles(data: Dictionary, pos: Vector3, duration: float) -> void:
	var gpup := GPUParticles3D.new()
	gpup.name = "VFX_" + str(randi())
	gpup.emitting = true
	gpup.amount = data.get("amount", 100)
	gpup.lifetime = duration if duration > 0 else data.get("lifetime", 2.0)
	gpup.position = pos

	var mat := ParticleProcessMaterial.new()
	mat.spread = data.get("spread", 2.0)
	var col: Array = data.get("color", [1,1,1])
	mat.color = Color(col[0], col[1], col[2])
	gpup.process_material = mat

	var mesh := SphereMesh.new()
	mesh.radius = data.get("size", 0.05); mesh.height = mesh.radius * 2
	var draw := mesh
	gpup.draw_pass_1 = draw
	gpup.visibility_aabb = AABB(pos - Vector3(10,10,10), Vector3(20,20,20))

	add_child(gpup)
	_active_effects.append(gpup)

	if duration > 0:
		get_tree().create_timer(duration).timeout.connect(func(): _remove_effect(gpup))

func _spawn_light(data: Dictionary, pos: Vector3, duration: float) -> void:
	var light := OmniLight3D.new()
	light.name = "VFX_Light_" + str(randi())
	var col: Array = data.get("color", [1,1,1])
	light.light_color = Color(col[0], col[1], col[2])
	light.light_energy = data.get("energy", 2.0)
	light.omni_range = data.get("range", 5.0)
	light.position = pos
	add_child(light)
	_active_effects.append(light)

	if duration > 0 or data.has("duration"):
		var d := duration if duration > 0 else data.get("duration", 2.0)
		get_tree().create_timer(d).timeout.connect(func(): _remove_effect(light))

func _spawn_overlay(data: Dictionary, duration: float) -> void:
	# Color overlay — додається як ColorRect на UI
	var gm := get_node_or_null("/root/GameManager")
	var canvas := gm.get_tree().current_scene
	if not canvas: return

	var overlay := ColorRect.new()
	overlay.name = "VFX_Overlay"
	var col: Array = data.get("color", [0,0,0])
	overlay.color = Color(col[0], col[1], col[2], 0)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)

	canvas.add_child(overlay)
	_active_effects.append(overlay)

	var d := duration if duration > 0 else data.get("duration", 2.0)
	var fi := data.get("fade_in", 0.5)
	var fo := data.get("fade_out", 1.0)

	var t := create_tween()
	t.tween_property(overlay, "color:a", 0.7, fi)
	t.tween_property(overlay, "color:a", 0.7, d - fi - fo)
	t.tween_property(overlay, "color:a", 0.0, fo)
	t.tween_callback(func(): _remove_effect(overlay))

func _remove_effect(node: Node) -> void:
	_active_effects.erase(node)
	if is_instance_valid(node):
		node.queue_free()

func clear_all() -> void:
	for n in _active_effects:
		if is_instance_valid(n):
			n.queue_free()
	_active_effects.clear()
