extends SceneTree

var _cam: Camera3D
var _frames: Variant = 0
var _shot: Variant = 0

func _init() -> void:
	call_deferred("_setup")

func _setup() -> void:
	var packed: PackedScene = load("res://scenes/locations/greyford/TavernInterior.tscn")
	var scene: Node = packed.instantiate()
	root.add_child(scene)
	var pl: Node = scene.get_node_or_null("Player")
	if pl is Node3D: (pl as Node3D).visible = false
	_cam = Camera3D.new()
	_cam.fov = 60.0
	root.add_child(_cam)
	_cam.make_current()
	get_root().get_viewport().msaa_3d = Viewport.MSAA_4X
	DirAccess.make_dir_recursive_absolute("res://screenshots")
	_aim_waitress()

func _aim_waitress() -> void:
	# офіціантка стартує біля бару waypoint[0] = (-3.1, 0.6, -3.35), під час руху йде до столів
	_cam.global_position = Vector3(1.6, 2.1, 0.2)
	_cam.look_at(Vector3(-2.0, 1.0, -1.4), Vector3.UP)

func _aim_merchant() -> void:
	# торговець MerchantPatron ~ (5.95, 0.18, 1.42)
	_cam.global_position = Vector3(2.4, 1.9, 2.6)
	_cam.look_at(Vector3(5.95, 0.9, 1.42), Vector3.UP)

func _process(_delta: float) -> bool:
	_frames += 1
	# дати анімаціям програтись, щоб пози були в русі, а не в bind-pose
	if _shot == 0 and _frames >= 90:
		get_root().get_viewport().get_texture().get_image().save_png("res://screenshots/tavern_anim_waitress.png")
		print("SAVED res://screenshots/tavern_anim_waitress.png")
		_shot = 1
		_aim_merchant()
		return false
	if _shot == 1 and _frames >= 120:
		get_root().get_viewport().get_texture().get_image().save_png("res://screenshots/tavern_anim_merchant.png")
		print("SAVED res://screenshots/tavern_anim_merchant.png")
		quit(0)
		return true
	return false
