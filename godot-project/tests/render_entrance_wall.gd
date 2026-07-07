extends SceneTree

var _cam: Camera3D
var _frames := 0
var _shot_idx := 0

var _shots := [
	# Entrance wall: from bar counter looking toward entrance
	{"name": "entrance_wall", "pos": Vector3(-1.5, 1.8, -1.5), "look": Vector3(-1.5, 1.3, 5.5)},
	# Entrance wall from right side
	{"name": "entrance_wall_right", "pos": Vector3(5.0, 1.8, 1.0), "look": Vector3(-2.0, 1.3, 5.5)},
]

func _init() -> void:
	call_deferred("_setup")

func _setup() -> void:
	var packed: PackedScene = load("res://scenes/locations/greyford/TavernInterior.tscn")
	if packed == null:
		push_error("SHOT: failed to load"); quit(1); return
	var scene := packed.instantiate()
	root.add_child(scene)

	_hide_path(scene, "Player")
	_hide_path(scene, "NPCs")
	_hide_path(scene, "BackgroundPatrons")
	_hide_all_labels(scene)

	_cam = Camera3D.new()
	_cam.fov = 68.0
	root.add_child(_cam)
	_cam.make_current()
	get_root().get_viewport().msaa_3d = Viewport.MSAA_4X
	DirAccess.make_dir_recursive_absolute("res://screenshots")
	_aim()

func _aim() -> void:
	var s = _shots[_shot_idx]
	_cam.global_position = s["pos"]
	_cam.look_at(s["look"], Vector3.UP)
	_frames = 0

func _hide_path(root_node: Node, path: NodePath) -> void:
	var node := root_node.get_node_or_null(path)
	if node: _hide_tree(node)

func _hide_tree(node: Node) -> void:
	if node is Node3D: (node as Node3D).visible = false
	for child in node.get_children(): _hide_tree(child)

func _hide_all_labels(node: Node) -> void:
	if node is Label3D: (node as Label3D).visible = false
	for child in node.get_children(): _hide_all_labels(child)

func _process(_delta: float) -> bool:
	_frames += 1
	if _frames < 24: return false
	var s = _shots[_shot_idx]
	var out := "res://screenshots/tavern_%s.png" % s["name"]
	var err := get_root().get_viewport().get_texture().get_image().save_png(out)
	print("SHOT_SAVED ", out, " err=", err)
	_shot_idx += 1
	if _shot_idx >= _shots.size():
		quit(0); return true
	_aim()
	return false
