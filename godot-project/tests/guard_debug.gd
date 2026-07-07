extends SceneTree
var _cam: Camera3D; var _frames := 0
func _init() -> void: call_deferred("_setup")
func _setup() -> void:
	var p: PackedScene = load("res://scenes/locations/greyford/TavernInterior.tscn")
	var s := p.instantiate(); root.add_child(s)
	var h := s.get_node_or_null("Player"); if h is Node3D: h.visible = false
	_lbl(s)
	# Hide Ervan NPC entirely
	var ervan := s.get_node_or_null("NPCs/Ervan"); if ervan: ervan.visible = false
	# Print guard model children to debug
	var guard := s.get_node_or_null("NPCs/GreyfordGuard")
	if guard:
		var model := guard.get_node_or_null("MeshyGuardModel")
		if model:
			print("Guard model global pos: " + str(model.global_position))
			for ch in model.get_children():
				print("  " + ch.name + " class=" + ch.get_class() + " pos=" + str(ch.global_position if ch is Node3D else "N/A"))
	_cam = Camera3D.new(); root.add_child(_cam); _cam.make_current()
	_cam.global_position = Vector3(3.2, 1.5, 4.0)
	_cam.look_at(Vector3(3.2, 1.0, 2.75), Vector3.UP)
	get_root().get_viewport().msaa_3d = Viewport.MSAA_4X
	DirAccess.make_dir_recursive_absolute("res://screenshots")
func _lbl(n: Node) -> void: if n is Label3D: n.visible = false; for ch in n.get_children(): _lbl(ch)
func _process(_d: float) -> bool:
	_frames += 1
	if _frames < 26: return false
	var img := get_root().get_viewport().get_texture().get_image()
	if img: img.save_png("res://screenshots/guard_debug.png"); print("OK")
	quit(); return true
