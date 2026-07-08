extends SceneTree

var _cam: Camera3D
var _frames: int = 0
var _ready_done := false

func _ready() -> void:
	var p: PackedScene = load("res://scenes/locations/greyford/TavernInterior.tscn")
	var s := p.instantiate()
	root.add_child(s)
	var h := s.get_node_or_null("Player")
	if h is Node3D:
		h.visible = false
	_lbl(s)
	_cam = Camera3D.new()
	root.add_child(_cam)
	_cam.make_current()
	_cam.global_position = Vector3(-5, 2.2, -4.5)
	_cam.look_at(Vector3(-3.1, 1.5, -3.35), Vector3.UP)
	get_root().get_viewport().msaa_3d = Viewport.MSAA_4X
	DirAccess.make_dir_recursive_absolute("res://screenshots")
	_ready_done = true

func _lbl(n: Node) -> void:
	if n is Label3D:
		n.visible = false
	for ch in n.get_children():
		_lbl(ch)

func _process(_d: float) -> bool:
	if not _ready_done:
		return false
	_frames += 1
	if _frames < 24:
		return false
	var img := get_root().get_viewport().get_texture().get_image()
	if img:
		img.save_png("res://screenshots/final_ervan.png")
		print("SAVED")
	quit()
	return true
