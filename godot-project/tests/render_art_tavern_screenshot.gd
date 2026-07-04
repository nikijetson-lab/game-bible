extends SceneTree

var _cam: Camera3D
var _frames := 0

func _init() -> void:
	call_deferred("_setup")

func _setup() -> void:
	var packed: PackedScene = load("res://scenes/locations/greyford/TavernInterior.tscn")
	if packed == null:
		push_error("ART_SHOT: failed to load TavernInterior")
		quit(1)
		return
	var scene := packed.instantiate()
	root.add_child(scene)

	_hide_path(scene, "Player")
	_hide_path(scene, "NPCs")
	_hide_path(scene, "BackgroundPatrons")
	_hide_path(scene, "MeshyAssets")
	_hide_all_labels(scene)

	_cam = Camera3D.new()
	_cam.fov = 68.0
	root.add_child(_cam)
	_cam.make_current()
	# Camera only, no lighting changes. Eye level near the entrance, clear line to the bar.
	_cam.global_position = Vector3(0.3, 1.62, 4.9)
	_cam.look_at(Vector3(-2.6, 1.0, -3.6), Vector3.UP)
	get_root().get_viewport().msaa_3d = Viewport.MSAA_4X
	DirAccess.make_dir_recursive_absolute("res://screenshots")
	print("ART_SHOT_READY")

func _hide_path(root_node: Node, path: NodePath) -> void:
	var node := root_node.get_node_or_null(path)
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
	if _frames < 28:
		return false
	var out := "res://screenshots/tavern_art_assembled_overview.png"
	var err := get_root().get_viewport().get_texture().get_image().save_png(out)
	print("ART_SHOT_SAVED ", out, " err=", err)
	quit(0)
	return true
