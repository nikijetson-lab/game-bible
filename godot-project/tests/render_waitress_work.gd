extends SceneTree

var _cam: Camera3D
var _frames: Variant = 0

func _init() -> void:
	call_deferred("_setup")

func _setup() -> void:
	var packed: PackedScene = load("res://scenes/locations/greyford/TavernInterior.tscn")
	var scene: Node = packed.instantiate()
	root.add_child(scene)
	# Приховати гравця, лишити NPC (офіціантку) видимими
	var pl: Node = scene.get_node_or_null("Player")
	if pl is Node3D: (pl as Node3D).visible = false
	_cam = Camera3D.new()
	_cam.fov = 60.0
	root.add_child(_cam)
	_cam.make_current()
	# Камера дивиться на бар/офіціантку (waypoint[0] = -3.1, 0.6, -3.35)
	_cam.global_position = Vector3(1.6, 2.0, 1.4)
	_cam.look_at(Vector3(-3.1, 1.0, -3.35), Vector3.UP)
	get_root().get_viewport().msaa_3d = Viewport.MSAA_4X
	DirAccess.make_dir_recursive_absolute("res://screenshots")

func _process(_delta: float) -> bool:
	_frames += 1
	if _frames < 28:
		return false
	var out: Variant = "res://screenshots/waitress_work.png"
	get_root().get_viewport().get_texture().get_image().save_png(out)
	print("SAVED ", out)
	quit(0)
	return true
