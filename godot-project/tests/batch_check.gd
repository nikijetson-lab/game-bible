extends SceneTree
var _cam: Camera3D; var _frames: Variant = 0; var _shots := [
	{out:"ervan_full", cam:Vector3(-5,2.2,-4.5), look:Vector3(-3.1,1.5,-3.35)},
	{out:"guard", cam:Vector3(2,1.5,-1), look:Vector3(3.2,1.2,2.75)},
	{out:"gate_sgt", cam:Vector3(3,2.5,-4), look:Vector3(0,1.5,0)},
	{out:"alteya", cam:Vector3(2,1.5,0), look:Vector3(0,1.2,-1.35)},
]; var _idx: Variant = 0; var _s:Node
func _init() -> void: call_deferred("_next")
func _next() -> void:
	if _s: _s.queue_free()
	var paths: Variant = ["res://scenes/locations/greyford/TavernInterior.tscn","res://scenes/locations/greyford/TavernInterior.tscn","res://scenes/locations/greyford/GreyfordGate.tscn","res://scenes/locations/greyford/AlteyaHiddenRoom.tscn"]
	var p:PackedScene=load(paths[_idx]); _s=p.instantiate(); root.add_child(_s)
	var h: Node = _s.get_node_or_null("Player"); if h is Node3D: h.visible=false
	_lbl(_s)
	if not _cam: _cam=Camera3D.new(); root.add_child(_cam); _cam.make_current(); get_root().get_viewport().msaa_3d=Viewport.MSAA_4X; DirAccess.make_dir_recursive_absolute("res://screenshots")
	_cam.global_position=_shots[_idx].cam; _cam.look_at(_shots[_idx].look,Vector3.UP)
	_frames=0
func _lbl(n:Node)->void: if n is Label3D: n.visible=false; for ch in n.get_children(): _lbl(ch)
func _process(_d:float)->bool:
	_frames+=1
	if _frames<24:return false
	get_root().get_viewport().get_texture().get_image().save_png("res://screenshots/"+_shots[_idx].out+".png")
	_idx+=1
	if _idx>=_shots.size(): print("ALL OK"); quit(); return true
	call_deferred("_next"); return false
