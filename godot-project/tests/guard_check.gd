extends SceneTree
var _cam: Camera3D; var _frames: Variant = 0
func _init() -> void: call_deferred("_setup")
func _setup() -> void:
	var p:PackedScene=load("res://scenes/locations/greyford/TavernInterior.tscn")
	var s: Node = p.instantiate(); root.add_child(s); var h:=s.get_node_or_null("Player"); if h is Node3D: h.visible=false
	_lbl(s)
	_cam=Camera3D.new(); root.add_child(_cam); _cam.make_current()
	_cam.global_position=Vector3(1.5,1.6,3.5)
	_cam.look_at(Vector3(3.2,1.2,2.75),Vector3.UP)
	get_root().get_viewport().msaa_3d=Viewport.MSAA_4X
	DirAccess.make_dir_recursive_absolute("res://screenshots")
func _lbl(n:Node)->void: if n is Label3D: n.visible=false; for ch in n.get_children(): _lbl(ch)
func _process(_d:float)->bool:
	_frames+=1
	if _frames<24:return false
	get_root().get_viewport().get_texture().get_image().save_png("res://screenshots/guard_check.png")
	print("OK"); quit(); return true
