extends SceneTree
var _cam: Camera3D; var _frames := 0
func _init() -> void: call_deferred("_setup")
func _setup() -> void:
	var p: PackedScene = load("res://scenes/locations/greyford/CraftsmenQuarter.tscn")
	var s := p.instantiate(); root.add_child(s)
	_hide(s, "Player"); _hide_labels(s)
	_cam = Camera3D.new(); _cam.fov = 60.0; root.add_child(_cam); _cam.make_current()
	# Close-up of woodcarver at position (-2.05, 0.95, -1.3)
	_cam.global_position = Vector3(-1.5, 1.35, -0.5)
	_cam.look_at(Vector3(-2.05, 0.95, -1.3), Vector3.UP)
	get_root().get_viewport().msaa_3d = Viewport.MSAA_4X
	DirAccess.make_dir_recursive_absolute("res://screenshots")
func _hide(n: Node, nm: String) -> void:
	var c := n.get_node_or_null(nm); if c is Node3D: (c as Node3D).visible = false
func _hide_labels(n: Node) -> void:
	if n is Label3D: (n as Label3D).visible = false
	for ch in n.get_children(): _hide_labels(ch)
func _process(_d: float) -> bool:
	_frames += 1
	if _frames < 26: return false
	get_root().get_viewport().get_texture().get_image().save_png("res://screenshots/woodcarver_shop.png")
	print("OK"); quit(0); return true
