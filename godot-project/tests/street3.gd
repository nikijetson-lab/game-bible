extends SceneTree
var _cam: Camera3D; var _frames := 0
func _init() -> void: call_deferred("_setup")
func _setup() -> void:
	var p: PackedScene = load("res://scenes/locations/greyford/GreyfordStreet.tscn")
	var s := p.instantiate(); root.add_child(s)
	_cam = Camera3D.new(); root.add_child(_cam); _cam.make_current()
	_cam.global_position = Vector3(0, 1.6, 8)
	_cam.look_at(Vector3(0, 1.5, -8), Vector3.UP)
	get_root().get_viewport().msaa_3d = Viewport.MSAA_4X
	DirAccess.make_dir_recursive_absolute("res://screenshots")
func _process(_d: float) -> bool:
	_frames += 1
	if _frames < 28: return false
	var img := get_root().get_viewport().get_texture().get_image()
	if img: img.save_png("res://screenshots/greyford_street.png"); print("SAVED")
	quit(); return true
