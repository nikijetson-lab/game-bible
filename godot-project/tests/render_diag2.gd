extends SceneTree

var _cam: Camera3D
var _frames: Variant = 0
var _shot_idx: Variant = 0

var _shots: Variant = [
	{"name": "diag_c_no_sign", "hide_sign": true, "hide_bar": false},
	{"name": "diag_d_no_bar", "hide_sign": false, "hide_bar": true},
]

func _init() -> void:
	call_deferred("_setup")

var _scene: Node

func _setup() -> void:
	var packed: PackedScene = load("res://scenes/locations/greyford/TavernInterior.tscn")
	if packed == null:
		push_error("SHOT: failed to load"); quit(1); return
	_scene = packed.instantiate()
	root.add_child(_scene)

	_hide_path(_scene, "Player")
	_hide_path(_scene, "NPCs")
	_hide_path(_scene, "BackgroundPatrons")
	_hide_all_labels(_scene)

	_cam = Camera3D.new()
	_cam.fov = 72.0
	root.add_child(_cam)
	_cam.make_current()
	_cam.global_position = Vector3(0.0, 1.55, -2.0)
	_cam.look_at(Vector3(0.0, 1.4, 6.0), Vector3.UP)
	get_root().get_viewport().msaa_3d = Viewport.MSAA_4X
	DirAccess.make_dir_recursive_absolute("res://screenshots")
	_aim()

func _aim() -> void:
	var s = _shots[_shot_idx]
	if s["hide_sign"]:
		_hide_path(_scene, "MeshyAssets/MeshyCreakingSign")
	if s["hide_bar"]:
		_hide_path(_scene, "MeshyAssets/MeshyBarCounter")
	_frames = 0

func _hide_path(root_node: Node, path: NodePath) -> void:
	var node: Node = root_node.get_node_or_null(path)
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
	var out: Variant = "res://screenshots/%s.png" % s["name"]
	var err: Image = get_root().get_viewport().get_texture().get_image().save_png(out)
	print("DIAG_SHOT_SAVED ", out, " err=", err)
	_shot_idx += 1
	if _shot_idx >= _shots.size():
		quit(0); return true
	_aim()
	return false
