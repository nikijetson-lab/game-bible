extends SceneTree
var _cam: Camera3D; var _frames: Variant = 0
func _init() -> void: call_deferred("_setup")
func _setup() -> void:
	var p: PackedScene = load("res://scenes/locations/sonk_ferry/FloodedChapel.tscn")
	var s: Node = p.instantiate(); root.add_child(s)
	_cam = Camera3D.new(); _cam.fov = 70.0; root.add_child(_cam); _cam.make_current()
	_cam.global_position = Vector3(4, 2, -3)
	_cam.look_at(Vector3(0, 2.5, 0), Vector3.UP)
	get_root().get_viewport().msaa_3d = Viewport.MSAA_4X
	DirAccess.make_dir_recursive_absolute("res://screenshots")
func _process(_d: float) -> bool:
	_frames += 1
	if _frames < 24: return false
	get_root().get_viewport().get_texture().get_image().save_png("res://screenshots/chapel.png")
	print("OK"); quit(0); return true
