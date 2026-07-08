extends SceneTree
var _cam: Camera3D; var _frames := 0
func _init() -> void: call_deferred("_setup")
func _setup() -> void:
	var p: PackedScene = load("res://scenes/locations/greyford/GreyfordGate.tscn")
	var s := p.instantiate(); root.add_child(s); _hide(s, "Player"); _hide_labels(s)
	_cam = Camera3D.new(); root.add_child(_cam); _cam.make_current()
	_cam.global_position = Vector3(0, 2.5, -5)
	_cam.look_at(Vector3(-1.85, 1.5, -2.55), Vector3.UP)
	get_root().get_viewport().msaa_3d = Viewport.MSAA_4X
	DirAccess.make_dir_recursive_absolute("res://screenshots")
func _hide(n: Node, nm: String) -> void: var c := n.get_node_or_null(nm); if c is Node3D: (c as Node3D).visible = false
func _hide_labels(n: Node) -> void: if n is Label3D: (n as Label3D).visible = false; for ch in n.get_children(): _hide_labels(ch)
func _process(_d: float) -> bool:
	_frames += 1
	if _frames < 28: return false
	var img := get_root().get_viewport().get_texture().get_image()
	if img: img.save_png("res://screenshots/gate_final.png"); print("SAVED")
	else: print("NO IMAGE")
	quit(); return true
