extends SceneTree

var scene: Node3D
var camera: Camera3D
var frame := 0
var stage := 0
var variants := [
	{"name": "gate_base", "hide": ""},
	{"name": "gate_no_npcs", "hide": "NPCs"},
	{"name": "gate_no_art", "hide": "GateArtAssembly"},
	{"name": "gate_no_arch", "hide": "Architecture"},
]

func _init() -> void:
	call_deferred("_setup")

func _setup() -> void:
	var packed: PackedScene = load("res://scenes/locations/greyford/GreyfordGate.tscn")
	scene = packed.instantiate()
	root.add_child(scene)
	var player := scene.get_node_or_null("Player") as Node3D
	if player:
		player.visible = false
	for n in scene.find_children("*", "Label3D", true, false):
		(n as Label3D).visible = false
	camera = Camera3D.new()
	camera.fov = 62.0
	camera.near = 0.12
	root.add_child(camera)
	camera.global_position = Vector3(0, 2.9, 5.2)
	camera.look_at(Vector3(0, 2.6, -2.6), Vector3.UP)
	camera.make_current()
	DirAccess.make_dir_recursive_absolute("res://screenshots/diagnostics")
	_apply_variant()

func _apply_variant() -> void:
	for path in ["NPCs", "GateArtAssembly", "Architecture"]:
		var n := scene.get_node_or_null(path) as Node3D
		if n:
			n.visible = true
	var hide_path: String = variants[stage]["hide"]
	if hide_path != "":
		var hidden := scene.get_node_or_null(hide_path) as Node3D
		if hidden:
			hidden.visible = false
	frame = 0

func _process(_delta: float) -> bool:
	frame += 1
	if frame < 24:
		return false
	var output: String = variants[stage]["name"]
	get_root().get_viewport().get_texture().get_image().save_png("res://screenshots/diagnostics/%s.png" % output)
	print("DIAG_SHOT: ", output)
	stage += 1
	if stage >= variants.size():
		print("DIAG_DONE")
		quit()
		return true
	_apply_variant()
	return false
