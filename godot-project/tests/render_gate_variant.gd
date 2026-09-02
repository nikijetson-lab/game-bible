extends SceneTree

var frame := 0
var mode := "base"

func _init() -> void:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("mode="):
			mode = arg.trim_prefix("mode=")
	call_deferred("_setup")

func _setup() -> void:
	var packed: PackedScene = load("res://scenes/locations/greyford/GreyfordGate.tscn")
	var scene := packed.instantiate()
	root.add_child(scene)
	var player := scene.get_node_or_null("Player") as Node3D
	if player:
		player.visible = false
	for n in scene.find_children("*", "Label3D", true, false):
		(n as Label3D).visible = false
	var hide_path := {
		"no_sergeant": "NPCs/GateSergeant",
		"no_background": "NPCs/BackgroundGuard",
		"no_art": "GateArtAssembly",
	}.get(mode, "") as String
	if hide_path != "":
		var hidden := scene.get_node_or_null(hide_path) as Node3D
		if hidden:
			hidden.visible = false
	var camera := Camera3D.new()
	camera.fov = 62.0
	camera.near = 0.12
	root.add_child(camera)
	camera.global_position = Vector3(0, 2.9, 5.2)
	camera.look_at(Vector3(0, 2.6, -2.6), Vector3.UP)
	camera.make_current()
	DirAccess.make_dir_recursive_absolute("res://screenshots/diagnostics")

func _process(_delta: float) -> bool:
	frame += 1
	if frame < 96:
		return false
	get_root().get_viewport().get_texture().get_image().save_png("res://screenshots/diagnostics/fresh_%s.png" % mode)
	print("FRESH_SHOT: ", mode)
	quit()
	return true
