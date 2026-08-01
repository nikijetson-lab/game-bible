extends SceneTree

var _scene: Node
var _cam: Camera3D
var _frame: int = 0

func _init() -> void:
	call_deferred("_setup")

func _setup() -> void:
	var packed: PackedScene = load("res://scenes/locations/tykhy_shelist/TykhyShelist.tscn")
	_scene = packed.instantiate()
	root.add_child(_scene)

	var player = _scene.get_node_or_null("Player")
	if player: player.visible = false

	_cam = Camera3D.new()
	_cam.current = true
	# Isometric overview angle
	_cam.position = Vector3(20, 12, 20)
	_cam.look_at(Vector3(0, 2.5, 0))

	root.add_child(_cam)

func _process(_delta: float) -> bool:
	_frame += 1
	if _frame < 35:
		return false
	var img: Image = get_root().get_viewport().get_texture().get_image()
	if img == null or img.is_empty():
		printerr("NO_IMAGE")
		quit(1)
		return true
	img.save_png("user://tykhy_overview.png")
	print("SHOT_SAVED")
	quit(0)
	return true
