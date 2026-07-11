extends SceneTree

var _shots: Variant = [
	# Close right-side angle: right-table lantern foreground, bar lantern and hanging lantern behind.
	{"name": "lanterns_bar_table", "pos": Vector3(7.0, 1.62, 3.45), "look": Vector3(4.6, 1.18, 0.75)},
	# Right-wall stair shot: steps run away/upward; bright tread edges face the camera.
	{"name": "stairs_up", "pos": Vector3(7.45, 2.05, -0.15), "look": Vector3(5.25, 1.20, -3.55)},
	# Rear-wall shot: two diamond windows on the left, one separate on the right.
	{"name": "three_windows", "pos": Vector3(-0.55, 2.18, 2.25), "look": Vector3(-1.85, 2.04, -6.16)},
]
var _idx: Variant = 0
var _cam: Camera3D
var _frames: Variant = 0
var _scene: Node

func _init() -> void:
	call_deferred("_setup")

func _setup() -> void:
	var packed: PackedScene = load("res://scenes/locations/greyford/TavernInterior.tscn")
	_scene = packed.instantiate()
	root.add_child(_scene)
	_hide(_scene, "Player"); _hide(_scene, "NPCs"); _hide(_scene, "BackgroundPatrons"); _hide(_scene, "MeshyAssets")
	_hide_labels(_scene)
	_cam = Camera3D.new()
	_cam.fov = 62.0
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
	var n: Node = root_node.get_node_or_null(path)
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
	var out: Variant = "res://screenshots/tavern_detail_%s.png" % s["name"]
	get_root().get_viewport().get_texture().get_image().save_png(out)
	print("DETAIL_SHOT_SAVED ", out)
	_idx += 1
	if _idx >= _shots.size():
		quit(0)
		return true
	_aim()
	return false
