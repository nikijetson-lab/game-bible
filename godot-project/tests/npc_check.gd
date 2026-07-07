extends SceneTree
var _cam: Camera3D; var _shots := [
	{scene="res://scenes/locations/greyford/TavernInterior.tscn", cam=Vector3(-3,1.7,-1), look=Vector3(-3,1,2), out="ervan_bar"},
	{scene="res://scenes/locations/greyford/TavernInterior.tscn", cam=Vector3(3,1.6,-2), look=Vector3(3.2,1,2.75), out="guard_table"},
	{scene="res://scenes/locations/greyford/PortTavernInterior.tscn", cam=Vector3(3,1.8,-2), look=Vector3(0,1.2,0), out="port_npcs"},
]
var _frames := 0; var _idx := 0; var _s: Node
func _init() -> void: call_deferred("_next")
func _next() -> void:
	if _s: _s.queue_free()
	var shot = _shots[_idx]
	var p: PackedScene = load(shot.scene); _s = p.instantiate(); root.add_child(_s)
	_hide(_s, "Player"); _hide_labels(_s)
	if not _cam: _cam = Camera3D.new(); root.add_child(_cam); _cam.make_current(); get_root().get_viewport().msaa_3d = Viewport.MSAA_4X; DirAccess.make_dir_recursive_absolute("res://screenshots")
	_cam.global_position = shot.cam; _cam.look_at(shot.look, Vector3.UP)
	_frames = 0
func _hide(n: Node, nm: String) -> void: var c := n.get_node_or_null(nm); if c is Node3D: (c as Node3D).visible = false
func _hide_labels(n: Node) -> void: if n is Label3D: (n as Label3D).visible = false; for ch in n.get_children(): _hide_labels(ch)
func _process(_d: float) -> bool:
	_frames += 1
	if _frames < 24: return false
	var o = _shots[_idx].out
	get_root().get_viewport().get_texture().get_image().save_png("res://screenshots/" + o + ".png")
	_idx += 1
	if _idx >= _shots.size(): print("OK"); quit(0); return true
	call_deferred("_next"); return false
