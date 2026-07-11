extends SceneTree

var _cam: Camera3D
var _frames: Variant = 0

func _init() -> void:
	call_deferred("_setup")

func _setup() -> void:
	var packed: PackedScene = load("res://scenes/locations/greyford/TavernInterior.tscn")
	if packed == null:
		push_error("SHOT: failed to load scene")
		quit(1)
		return
	var scene: Node = packed.instantiate()
	root.add_child(scene)

	_hide_path(scene, "Player")
	_hide_path(scene, "BackgroundPatrons")
	_hide_path(scene, "MeshyAssets")
	_hide_all_labels(scene)

	var npcs_node: Node = scene.get_node_or_null("NPCs")
	if npcs_node:
		for child in npcs_node.get_children():
			if child.name != "GreyfordGuard" and child.name != "Ervan":
				_hide_tree(child)

	var guard: Node = scene.get_node_or_null("NPCs/GreyfordGuard")
	if guard:
		var letter: Node = guard.get_node_or_null("CarriedLetter")
		if letter and letter is Node3D:
			(letter as Node3D).visible = false

	_cam = Camera3D.new()
	_cam.fov = 68.0
	root.add_child(_cam)
	_cam.make_current()
	_cam.global_position = Vector3(0.3, 1.62, 4.9)
	_cam.look_at(Vector3(-0.5, 1.2, -1.0), Vector3.UP)
	get_root().get_viewport().msaa_3d = Viewport.MSAA_4X
	DirAccess.make_dir_recursive_absolute("res://screenshots")
	print("SHOT_READY")

func _hide_path(root_node: Node, path: NodePath) -> void:
	var node: Node = root_node.get_node_or_null(path)
	if node:
		_hide_tree(node)

func _hide_tree(node: Node) -> void:
	if node is Node3D:
		(node as Node3D).visible = false
	for child in node.get_children():
		_hide_tree(child)

func _hide_all_labels(node: Node) -> void:
	if node is Label3D:
		(node as Label3D).visible = false
	for child in node.get_children():
		_hide_all_labels(child)

func _process(_delta: float) -> bool:
	_frames += 1
	if _frames < 60:
		return false
	var out: Variant = "res://screenshots/greyford_guard_v2.png"
	var err: Image = get_root().get_viewport().get_texture().get_image().save_png(out)
	print("SHOT_SAVED ", out, " err=", err)
	quit(0)
	return true
