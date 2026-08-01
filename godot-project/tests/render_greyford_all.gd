extends SceneTree
var _cam: Camera3D
var _frames: int = 0
var _shots: Array[Dictionary] = []
var _s: Node
var _idx: int = 0

func _init() -> void:
	seed(41001)
	# Camera positions are derived from the runtime visual-bounds census in
	# diagnose_greyford_visual_bounds.gd. Interior cameras stay inside the room
	# AABB but clear of boundary meshes; targets favor the real NPC/scene focus.
	_shots = [
		{"s": "res://scenes/locations/greyford/TavernInterior.tscn", "c": Vector3(-5,2.2,-4.5), "l": Vector3(-3.1,1.5,-3.35), "o": "gf_tavern"},
		{"s": "res://scenes/locations/greyford/CraftsmenQuarter.tscn", "c": Vector3(7.2,2.8,5.0), "l": Vector3(0.8,1.55,-1.35), "o": "gf_crafts"},
		{"s": "res://scenes/locations/greyford/PortTavernInterior.tscn", "c": Vector3(0,2.3,4.2), "l": Vector3(0,1.3,-1.5), "o": "gf_port"},
		{"s": "res://scenes/locations/greyford/GreyfordGate.tscn", "c": Vector3(0,2.9,5.2), "l": Vector3(0,2.6,-2.6), "o": "gf_gate"},
		{"s": "res://scenes/locations/greyford/AlteyaHiddenRoom.tscn", "c": Vector3(4.0,2.15,2.2), "l": Vector3(0,1.35,-1.35), "o": "gf_alteya"},
		{"s": "res://scenes/locations/greyford/RufinRoom.tscn", "c": Vector3(3.2,1.45,2.3), "l": Vector3(0,0.8,-0.7), "o": "gf_rufin"},
		{"s": "res://scenes/locations/greyford/GreyfordStreet.tscn", "c": Vector3(-5.4,3.0,-6.0), "l": Vector3(2.0,1.5,2.5), "o": "gf_street"}
	]
	call_deferred("_next")

func _next() -> void:
	if _s: _s.queue_free()
	var shot: Dictionary = _shots[_idx]
	var p = load(shot["s"])
	_s = p.instantiate()
	root.add_child(_s)
	var h: Node = _s.get_node_or_null("Player")
	if h is Node3D: h.visible = false
	_lbl(_s)
	if not _cam:
		_cam = Camera3D.new()
		_cam.fov = 62.0
		_cam.near = 0.12
		root.add_child(_cam)
		_cam.make_current()
		get_root().get_viewport().msaa_3d = Viewport.MSAA_4X
		DirAccess.make_dir_recursive_absolute("res://screenshots")
	_cam.global_position = shot["c"]
	_cam.look_at(shot["l"], Vector3.UP)
	_play_model_animations(_s)
	_frames = 0

func _play_model_animations(n: Node) -> void:
	if n is AnimationPlayer:
		var player := n as AnimationPlayer
		var candidates: PackedStringArray = player.get_animation_list()
		for preferred in ["Idle", "idle", "Walk", "walk"]:
			if candidates.has(preferred):
				player.play(preferred)
				return
		for animation_name in candidates:
			if animation_name != "RESET":
				player.play(animation_name)
				return
	for child in n.get_children():
		_play_model_animations(child)

func _lbl(n: Node) -> void:
	if n is Label3D: n.visible = false
	for ch in n.get_children(): _lbl(ch)

func _process(_d: float) -> bool:
	_frames += 1
	if _frames < 96: return false
	var shot: Dictionary = _shots[_idx]
	get_root().get_viewport().get_texture().get_image().save_png("res://screenshots/" + shot["o"] + ".png")
	print("SHOT: " + shot["o"])
	_idx += 1
	if _idx >= _shots.size():
		print("ALL DONE")
		quit()
		return true
	call_deferred("_next")
	return false
