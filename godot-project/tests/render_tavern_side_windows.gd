extends SceneTree

var _shots := [
	{"name": "left_wall_two_windows", "pos": Vector3(-3.25, 1.95, 0.15), "look": Vector3(-8.06, 1.90, 0.15)},
	{"name": "right_wall_one_window", "pos": Vector3(1.4, 1.95, 4.55), "look": Vector3(8.06, 1.75, 1.35)},
]
var _idx := 0
var _cam: Camera3D
var _frames := 0
var _scene: Node

func _init() -> void:
	call_deferred("_setup")

func _setup() -> void:
	var packed: PackedScene = load("res://scenes/locations/greyford/TavernInterior.tscn")
	if packed == null:
		push_error("TavernInterior missing")
		quit(1)
		return
	_scene = packed.instantiate()
	root.add_child(_scene)
	_hide(_scene, "Player"); _hide(_scene, "NPCs"); _hide(_scene, "BackgroundPatrons"); _hide(_scene, "MeshyAssets")
	_hide_labels(_scene)
	_cam = Camera3D.new()
	_cam.fov = 58.0
	root.add_child(_cam)
	_cam.make_current()
	get_root().get_viewport().msaa_3d = Viewport.MSAA_4X
	DirAccess.make_dir_recursive_absolute("res://screenshots")
	_aim()

func _aim() -> void:
	var s = _shots[_idx]
	_cam.global_position = s["pos"]
	_cam.look_at(s["look"], Vector3.UP)
	_frames = 0

func _hide(root_node: Node, path: NodePath) -> void:
	var n := root_node.get_node_or_null(path)
	if n: _hide_tree(n)

func _hide_tree(n: Node) -> void:
	if n is Node3D: (n as Node3D).visible = false
	for c in n.get_children(): _hide_tree(c)

func _hide_labels(n: Node) -> void:
	if n is Label3D: (n as Label3D).visible = false
	for c in n.get_children(): _hide_labels(c)

func _process(_delta: float) -> bool:
	_frames += 1
	if _frames < 18:
		return false
	var s = _shots[_idx]
	var out := "res://screenshots/tavern_side_%s.png" % s["name"]
	get_root().get_viewport().get_texture().get_image().save_png(out)
	print("SIDE_WINDOW_SHOT_SAVED ", out)
	_idx += 1
	if _idx >= _shots.size():
		quit(0)
	else:
		_aim()
	return false
