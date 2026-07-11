extends SceneTree
var _cam: Camera3D; var _frames: Variant = 0
func _init() -> void: call_deferred("_setup")
func _setup() -> void:
	var packed: PackedScene = load("res://scenes/locations/greyford/GreyfordStreet.tscn")
	var scene: Node = packed.instantiate(); root.add_child(scene)
	_hide_path(scene, "Player"); _hide_all_labels(scene)
	_cam = Camera3D.new(); _cam.fov = 70.0; root.add_child(_cam); _cam.make_current()
	_cam.global_position = Vector3(0, 3.5, -9.5)
	_cam.look_at(Vector3(0, 1.5, 0), Vector3.UP)
	get_root().get_viewport().msaa_3d = Viewport.MSAA_4X
	DirAccess.make_dir_recursive_absolute("res://screenshots")
func _hide_path(r: Node, p: NodePath) -> void:
	var n: Node = r.get_node_or_null(p)
	if n is Node3D: (n as Node3D).visible = false
func _hide_all_labels(n: Node) -> void:
	if n is Label3D: (n as Label3D).visible = false
	for c in n.get_children(): _hide_all_labels(c)
func _process(_d: float) -> bool:
	_frames += 1
	if _frames < 26: return false
	get_root().get_viewport().get_texture().get_image().save_png("res://screenshots/greyford_street.png")
	print("OK"); quit(0); return true
