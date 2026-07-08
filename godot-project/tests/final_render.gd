extends SceneTree
var _cam:Camera3D;var _f:=0;var _shots:=[]
func _init()->void:
	_shots=[{s:"res://scenes/locations/greyford/TavernInterior.tscn",c:Vector3(-5,2.2,-4.5),l:Vector3(-3.1,1.5,-3.35),o:"final_ervan"},
	{s:"res://scenes/locations/greyford/CraftsmenQuarter.tscn",c:Vector3(3,3.5,-4),l:Vector3(0,2,0),o:"final_crafts"},
	{s:"res://scenes/locations/greyford/PortTavernInterior.tscn",c:Vector3(4,3,-4),l:Vector3(0,1.5,0),o:"final_port"},
	{s:"res://scenes/locations/sonk_ferry/SonkFerry.tscn",c:Vector3(0,8,-40),l:Vector3(0,1,0),o:"final_sonk"},
	{s:"res://scenes/locations/valkorn/BlackArchive.tscn",c:Vector3(10,6,-12),l:Vector3(0,1.5,-8),o:"final_archive"}]
	call_deferred("_next")
var _s:Node;var _idx:=0
func _next()->void:
	if _s:_s.queue_free()
	var p=load(_shots[_idx].s);_s=p.instantiate();root.add_child(_s)
	var h=_s.get_node_or_null("Player");if h is Node3D:h.visible=false
	_lbl(_s)
	if not _cam:_cam=Camera3D.new();root.add_child(_cam);_cam.make_current();get_root().get_viewport().msaa_3d=Viewport.MSAA_4X;DirAccess.make_dir_recursive_absolute("res://screenshots")
	_cam.global_position=_shots[_idx].c;_cam.look_at(_shots[_idx].l,Vector3.UP)
	_f=0
func _lbl(n:Node)->void:if n is Label3D:n.visible=false;for ch in n.get_children():_lbl(ch)
func _process(_d:float)->bool:
	_f+=1
	if _f<24:return false
	var s=_shots[_idx];get_root().get_viewport().get_texture().get_image().save_png("res://screenshots/"+s.o+".png")
	print("SHOT:"+s.o)
	_idx+=1
	if _idx>=_shots.size():print("ALL DONE");quit();return true
	call_deferred("_next");return false
