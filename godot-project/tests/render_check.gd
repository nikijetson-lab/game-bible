extends SceneTree
var _cam: Camera3D; var _frames := 0; var _idx := 0
var _shots := [
	{scene="res://scenes/locations/greyford/GreyfordStreet.tscn", cam=Vector3(0,8,-10), look=Vector3(0,1,0), out="street"},
	{scene="res://scenes/locations/greyford/CraftsmenQuarter.tscn", cam=Vector3(3,4,-5), look=Vector3(0,2,0), out="crafts"},
	{scene="res://scenes/locations/greyford/PortTavernInterior.tscn", cam=Vector3(3,4,-5), look=Vector3(0,1.5,0), out="port"},
	{scene="res://scenes/locations/tykhy_shelist/TykhyShelist.tscn", cam=Vector3(10,6,-25), look=Vector3(10,2,-20), out="tykhy"},
]
func _init() -> void: call_deferred("_setup")
func _aim() -> void:
	var s = _shots[_idx]
	if _scene: _scene.queue_free()
	var p: PackedScene = load(s.scene)
	_scene = p.instantiate(); root.add_child(_scene)
	_hide(_scene, "Player"); _hide_labels(_scene)
	if not _cam:
		_cam = Camera3D.new(); _cam.fov = 68.0; root.add_child(_cam); _cam.make_current()
		get_root().get_viewport().msaa_3d = Viewport.MSAA_4X
		DirAccess.make_dir_recursive_absolute("res://screenshots")
	_cam.global_position = s.cam; _cam.look_at(s.look, Vector3.UP)
	_frames = 0
var _scene: Node
func _hide(n: Node, nm: String) -> void:
	var c := n.get_node_or_null(nm); if c is Node3D: (c as Node3D).visible = false
func _hide_labels(n: Node) -> void:
	if n is Label3D: (n as Label3D).visible = false
	for ch in n.get_children(): _hide_labels(ch)
func _process(_d: float) -> bool:
	_frames += 1
	if _frames < 24: return false
	var s = _shots[_idx]
	var err := get_root().get_viewport().get_texture().get_image().save_png("res://screenshots/check_%s.png" % s.out)
	print("SHOT %s err=%d" % [s.out, err])
	_idx += 1
	if _idx >= _shots.size(): quit(0); return true
	call_deferred("_aim")
	return false
