extends SceneTree

# Standalone asset preview of the Meshy tavern GLB (NOT the game scene).
# Neutral preview light is only to inspect the raw model; it does not touch
# TavernInterior.tscn lighting.

var _cam: Camera3D
var _shots: Array[Dictionary] = []
var _idx := 0
var _positioned := false
var _wait := 0
var _center := Vector3.ZERO
var _radius := 5.0

func _init() -> void:
	call_deferred("_setup")

func _setup() -> void:
	var packed: PackedScene = load("res://assets/meshy/greyford_tavern/tavern_interior_from_art.glb")
	if packed == null:
		push_error("PREVIEW: failed to load GLB")
		quit(1)
		return
	var model := packed.instantiate()
	root.add_child(model)

	var aabb := _combined_aabb(model)
	_center = aabb.position + aabb.size * 0.5
	_radius = max(aabb.size.x, max(aabb.size.y, aabb.size.z))
	print("PREVIEW_AABB pos=", aabb.position, " size=", aabb.size, " center=", _center, " radius=", _radius)

	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.11, 0.12, 0.14)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.7, 0.68, 0.64)
	env.ambient_light_energy = 1.3
	var world := WorldEnvironment.new()
	world.environment = env
	root.add_child(world)

	var key := DirectionalLight3D.new()
	key.rotation_degrees = Vector3(-50, -40, 0)
	key.light_energy = 1.8
	root.add_child(key)
	var fill := DirectionalLight3D.new()
	fill.rotation_degrees = Vector3(-25, 135, 0)
	fill.light_energy = 1.0
	root.add_child(fill)

	_cam = Camera3D.new()
	_cam.fov = 60.0
	_cam.near = 0.01
	root.add_child(_cam)
	_cam.make_current()
	get_root().get_viewport().msaa_3d = Viewport.MSAA_4X

	var d := _radius * 1.15
	_shots = [
		{"name": "meshy_tavern_front", "pos": _center + Vector3(0, _radius*0.25, d), "look": _center},
		{"name": "meshy_tavern_45", "pos": _center + Vector3(d*0.8, _radius*0.35, d*0.8), "look": _center},
		{"name": "meshy_tavern_inside", "pos": _center + Vector3(-_radius*0.15, _radius*0.1, _radius*0.2), "look": _center + Vector3(_radius*0.3, 0, -_radius*0.3)},
		{"name": "meshy_tavern_top", "pos": _center + Vector3(0.01, d, 0.01), "look": _center},
	]
	DirAccess.make_dir_recursive_absolute("res://screenshots")
	print("PREVIEW_READY count=", _shots.size())

func _combined_aabb(node: Node) -> AABB:
	var acc := AABB()
	var has := false
	for mi in _all_mesh_instances(node):
		var a: AABB = (mi as MeshInstance3D).global_transform * (mi as MeshInstance3D).get_aabb()
		if not has:
			acc = a
			has = true
		else:
			acc = acc.merge(a)
	return acc

func _all_mesh_instances(node: Node) -> Array:
	var out := []
	if node is MeshInstance3D and (node as MeshInstance3D).mesh != null:
		out.append(node)
	for c in node.get_children():
		out += _all_mesh_instances(c)
	return out

func _process(_delta: float) -> bool:
	if _idx >= _shots.size():
		quit(0)
		return true
	var shot := _shots[_idx]
	if not _positioned:
		_cam.global_position = shot["pos"]
		_cam.look_at(shot["look"], Vector3.UP)
		_positioned = true
		_wait = 0
		return false
	_wait += 1
	if _wait < 12:
		return false
	var img := get_root().get_viewport().get_texture().get_image()
	var out := "res://screenshots/%s.png" % shot["name"]
	print("PREVIEW_SAVED ", out, " err=", img.save_png(out))
	_idx += 1
	_positioned = false
	return false
