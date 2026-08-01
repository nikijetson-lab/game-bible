extends SceneTree

const MODELS := [
	{"p": "res://assets/meshy/greyford_tavern/creaking_sign.glb", "o": "reuse_creaking_sign"},
	{"p": "res://assets/meshy/tykhy_shelist/boat.glb", "o": "reuse_boat"},
	{"p": "res://assets/meshy/tykhy_shelist/stilt_hut.glb", "o": "reuse_stilt_hut"},
	{"p": "res://assets/meshy/tykhy_shelist/walkway.glb", "o": "reuse_walkway"},
]
var _idx := 0
var _frames := 0
var _model: Node3D
var _camera: Camera3D

func _initialize() -> void:
	call_deferred("_next")

func _collect(node: Node, root_node: Node3D, merged: AABB, has_box: bool) -> Dictionary:
	if node is MeshInstance3D and (node as MeshInstance3D).mesh != null:
		var mi := node as MeshInstance3D
		var rel := root_node.global_transform.affine_inverse() * mi.global_transform
		var box := rel * mi.get_aabb()
		merged = box if not has_box else merged.merge(box)
		has_box = true
	for child in node.get_children():
		var result := _collect(child, root_node, merged, has_box)
		merged = result.box
		has_box = result.has_box
	return {"box": merged, "has_box": has_box}

func _next() -> void:
	if _model != null:
		_model.queue_free()
	_model = (load(MODELS[_idx].p) as PackedScene).instantiate() as Node3D
	root.add_child(_model)
	await process_frame
	var result := _collect(_model, _model, AABB(), false)
	var box: AABB = result.box
	_model.position = Vector3(-box.get_center().x, -box.position.y, -box.get_center().z)
	var height := max(box.size.y, 0.5)
	var radius: float = max(box.size.x, box.size.z) * 0.72
	if _camera == null:
		var world := WorldEnvironment.new()
		var env := Environment.new()
		env.background_mode = Environment.BG_COLOR
		env.background_color = Color(0.045, 0.05, 0.06)
		env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
		env.ambient_light_color = Color(0.62, 0.72, 0.82)
		env.ambient_light_energy = 1.35
		env.tonemap_mode = Environment.TONE_MAPPER_AGX
		env.tonemap_exposure = 1.0
		world.environment = env
		root.add_child(world)
		var key := DirectionalLight3D.new()
		key.rotation_degrees = Vector3(-48, -38, 0)
		key.light_color = Color(1.0, 0.78, 0.58)
		key.light_energy = 2.1
		key.shadow_enabled = true
		root.add_child(key)
		var fill := DirectionalLight3D.new()
		fill.rotation_degrees = Vector3(-28, 140, 0)
		fill.light_color = Color(0.48, 0.66, 1.0)
		fill.light_energy = 1.15
		root.add_child(fill)
		_camera = Camera3D.new()
		_camera.fov = 48.0
		root.add_child(_camera)
		_camera.make_current()
		root.get_viewport().msaa_3d = Viewport.MSAA_4X
		DirAccess.make_dir_recursive_absolute("res://screenshots/reuse_env")
	var distance := max(radius * 2.45, height * 1.45, 2.0)
	_camera.position = Vector3(distance * 0.82, height * 0.72, distance)
	_camera.look_at(Vector3(0, height * 0.46, 0), Vector3.UP)
	print("CANDIDATE %s bounds=%s" % [MODELS[_idx].o, box.size])
	_frames = 0

func _process(_delta: float) -> bool:
	_frames += 1
	if _frames < 36:
		return false
	var output: String = "res://screenshots/reuse_env/%s.png" % MODELS[_idx].o
	root.get_viewport().get_texture().get_image().save_png(output)
	print("SHOT: ", output)
	_idx += 1
	if _idx >= MODELS.size():
		print("ALL DONE")
		quit()
		return true
	call_deferred("_next")
	return false
