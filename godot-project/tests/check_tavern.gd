extends SceneTree
var _cam: Camera3D; var _frames := 0
func _init() -> void: call_deferred("_setup")
func _setup() -> void:
	var p: PackedScene = load("res://scenes/locations/greyford/TavernInterior.tscn")
	var s := p.instantiate(); root.add_child(s)
	_hide(s, "Player"); _hide_labels(s)
	_cam = Camera3D.new(); root.add_child(_cam); _cam.make_current()
	_cam.global_position = Vector3(3, 1.8, -3)
	_cam.look_at(Vector3(0, 1.3, 2), Vector3.UP)
	get_root().get_viewport().msaa_3d = Viewport.MSAA_4X
	DirAccess.make_dir_recursive_absolute("res://screenshots")
	
	# Check if NPCs have GLB models properly attached
	var npcs := s.get_node_or_null("NPCs")
	if npcs:
		for c in npcs.get_children():
			var model := c.get_node_or_null("Model")
			if model:
				print("NPC " + str(c.get("npc_id")) + " has Model node, children=" + str(model.get_child_count()))
			else:
				print("NPC " + str(c.get("npc_id")) + " NO Model")

func _hide(n: Node, nm: String) -> void:
	var c := n.get_node_or_null(nm); if c is Node3D: (c as Node3D).visible = false
func _hide_labels(n: Node) -> void:
	if n is Label3D: (n as Label3D).visible = false
	for ch in n.get_children(): _hide_labels(ch)
func _process(_d: float) -> bool:
	_frames += 1
	if _frames < 30: return false
	get_root().get_viewport().get_texture().get_image().save_png("res://screenshots/tavern_fix.png")
	print("OK"); quit(0); return true
