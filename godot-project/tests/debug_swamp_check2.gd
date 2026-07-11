extends SceneTree

var _frames: Variant = 0
var _scene: Node3D

func _init() -> void:
	call_deferred("_setup")

func _setup() -> void:
	var packed: PackedScene = load("res://scenes/locations/hazemoor/SwampPath.tscn")
	_scene = packed.instantiate()
	root.add_child(_scene)
	print("SCENE_ADDED")

func _process(_delta: float) -> bool:
	_frames += 1
	if _frames < 10:
		return false
	var art: Node = _scene.get_node_or_null("SwampArtAssembly")
	print("ART_NODE: ", art)
	if art:
		print("ART_SCRIPT: ", art.get_script())
		print("ART_CHILDREN: ", art.get_child_count())
		for c in art.get_children():
			print(" - ", c.name)
	quit(0)
	return true
