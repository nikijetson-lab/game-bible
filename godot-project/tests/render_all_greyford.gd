extends SceneTree
var _cam: Camera3D; var _frames: Variant = 0; var _scenes := [
	"res://scenes/locations/greyford/TavernInterior.tscn",
	"res://scenes/locations/greyford/CraftsmenQuarter.tscn", 
	"res://scenes/locations/greyford/PortTavernInterior.tscn",
	"res://scenes/locations/greyford/GreyfordGate.tscn",
	"res://scenes/locations/greyford/AlteyaHiddenRoom.tscn",
]; var _idx: Variant = 0; var _s: Node
func _init() -> void: call_deferred("_next")
func _next() -> void:
	if _s: _s.queue_free()
	var p: PackedScene = load(_scenes[_idx]); _s = p.instantiate(); root.add_child(_s)
	_hide(_s, "Player"); _hide_labels(_s)
	if not _cam: _cam = Camera3D.new(); _cam.fov = 70.0; root.add_child(_cam); _cam.make_current(); get_root().get_viewport().msaa_3d = Viewport.MSAA_4X; DirAccess.make_dir_recursive_absolute("res://screenshots")
	var centers: Variant = [Vector3(0,1.6,1.5), Vector3(0,1.6,0), Vector3(3,1.6,0), Vector3(0,1.6,0), Vector3(0,1.6,-1.35)]
	_cam.global_position = centers[_idx] + Vector3(4, 2.5, -4)
	_cam.look_at(centers[_idx], Vector3.UP)
	_frames = 0
func _hide(n: Node, nm: String) -> void:
	var c: Node = n.get_node_or_null(nm); if c is Node3D: (c as Node3D).visible = false
func _hide_labels(n: Node) -> void:
	if n is Label3D: (n as Label3D).visible = false
	for ch in n.get_children(): _hide_labels(ch)
var _names: Variant = ["tavern","crafts","port","gate","alteya"]
func _process(_d: float) -> bool:
	_frames += 1
	if _frames < 22: return false
	get_root().get_viewport().get_texture().get_image().save_png("res://screenshots/test_" + _names[_idx] + ".png")
	_idx += 1
	if _idx >= _scenes.size(): print("ALL DONE"); quit(0); return true
	call_deferred("_next"); return false
