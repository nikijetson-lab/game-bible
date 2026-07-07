extends SceneTree

var _cam: Camera3D
var _frames := 0
var _shot_idx := 0

var _shots := [
	# Normal view (MeshyAssets visible, NPCs hidden)
	{"name": "diag_a_normal", "hide_meshy": false},
	# Without MeshyAssets
	{"name": "diag_b_no_meshy", "hide_meshy": true},
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
	_cam.fov = 72.0
	root.add_child(_cam)
	_cam.make_current()
	_cam.global_position = Vector3(0.0, 1.55, -2.0)
	_cam.look_at(Vector3(0.0, 1.4, 6.0), Vector3.UP)
	get_root().get_viewport().msaa_3d = Viewport.MSAA_4X
	DirAccess.make_dir_recursive_absolute("res://screenshots")

	# Store scene ref for toggling
	_scene = scene
	_aim()

var _scene: Node

func _aim() -> void:
	var s = _shots[_shot_idx]
	if s["hide_meshy"]:
		_hide_path(_scene, "MeshyAssets")
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
	var out := "res://screenshots/%s.png" % s["name"]
	var err := get_root().get_viewport().get_texture().get_image().save_png(out)
	print("DIAG_SHOT_SAVED ", out, " err=", err)
	_shot_idx += 1
	if _shot_idx >= _shots.size():
		quit(0); return true
	_aim()
	return false
