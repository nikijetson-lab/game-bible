extends SceneTree

var _shots := [
	{"name": "front_door_wall", "pos": Vector3(0.0, 1.55, 8.85), "look": Vector3(0.0, 1.38, 5.72)},
	{"name": "inside_four_walls", "pos": Vector3(1.15, 1.82, 4.85), "look": Vector3(-0.25, 1.35, -4.85)},
]
var _idx := 0
var _cam: Camera3D
var _root: Node

func _init() -> void:
	var packed := load("res://scenes/locations/greyford/TavernInterior.tscn")
	if packed == null:
		push_error("TavernInterior missing")
		quit(1)
		return
	_root = packed.instantiate()
	get_root().add_child(_root)
	for path in ["Player", "NPCs", "BackgroundPatrons", "MeshyAssets"]:
		var n := _root.get_node_or_null(path)
		if n is Node3D:
			(n as Node3D).visible = false
	var vp := get_root()
	vp.size = Vector2i(1280, 720)
	_cam = Camera3D.new()
	_cam.name = "RoomShellCamera"
	_cam.fov = 62.0
	_root.add_child(_cam)
	vp.get_viewport().camera_3d = _cam
	_render_next.call_deferred()

func _render_next() -> void:
	if _idx >= _shots.size():
		quit(0)
		return
	var shot: Dictionary = _shots[_idx]
	_cam.global_position = shot["pos"]
	_cam.look_at(shot["look"], Vector3.UP)
	await process_frame
	await process_frame
	await process_frame
	var img := get_root().get_texture().get_image()
	var path := "res://screenshots/tavern_shell_%s.png" % shot["name"]
	var err := img.save_png(path)
	if err != OK:
		push_error("Failed to save " + path + " err=" + str(err))
		quit(1)
		return
	print("SHELL_SHOT_SAVED " + path)
	_idx += 1
	_render_next.call_deferred()
