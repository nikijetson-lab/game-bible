extends SceneTree

var _frames := 0
var _scene: Node3D

func _init() -> void:
	call_deferred("_setup")

func _setup() -> void:
	var packed: PackedScene = load("res://scenes/locations/greyford/CraftsmenQuarter.tscn")
	_scene = packed.instantiate()
	root.add_child(_scene)
	print("SCENE_ADDED")

func _process(_delta: float) -> bool:
	_frames += 1
	if _frames < 10:
		return false
	var art := _scene.get_node_or_null("CraftsmenArtAssembly")
	print("ART_NODE: ", art)
	if art:
		print("ART_SCRIPT: ", art.get_script())
		print("ART_CHILDREN: ", art.get_child_count())
	quit(0)
	return true
