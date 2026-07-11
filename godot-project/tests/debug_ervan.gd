extends SceneTree
var _cam: Camera3D; var _frames: Variant = 0
func _init() -> void: call_deferred("_setup")
func _setup() -> void:
	var p: PackedScene = load("res://scenes/locations/greyford/TavernInterior.tscn")
	var s: Node = p.instantiate(); root.add_child(s)
	_hide(s, "Player"); _hide_labels(s)
	# Debug: list ALL children of Ervan NPC
	var npcs: Node = s.get_node("NPCs")
	for c in npcs.get_children():
		if str(c.get("npc_id")) in ["ervan","greyford_guard_letter"]:
			print("NPC: " + str(c.get("npc_id")) + " children:")
			for ch in c.get_children():
				print("  " + ch.name + " visible=" + str(ch.visible) + " class=" + ch.get_class())
	_cam = Camera3D.new(); root.add_child(_cam); _cam.make_current()
	_cam.global_position = Vector3(-3.5, 2.0, -2.5)
	_cam.look_at(Vector3(-3, 1.0, -0.5), Vector3.UP)
	get_root().get_viewport().msaa_3d = Viewport.MSAA_4X
	DirAccess.make_dir_recursive_absolute("res://screenshots")
func _hide(n: Node, nm: String) -> void:
	var c: Node = n.get_node_or_null(nm); if c is Node3D: (c as Node3D).visible = false
func _hide_labels(n: Node) -> void:
	if n is Label3D: (n as Label3D).visible = false
	for ch in n.get_children(): _hide_labels(ch)
func _process(_d: float) -> bool:
	_frames += 1
	if _frames < 28: return false
	get_root().get_viewport().get_texture().get_image().save_png("res://screenshots/debug_ervan.png")
	print("OK"); quit(0); return true
