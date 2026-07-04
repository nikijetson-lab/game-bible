extends SceneTree

# Renders one screenshot per dressed Greyford location for art self-check.
# Camera only — no lighting/environment changes.

const SHOTS := [
	{
		"scene": "res://scenes/locations/greyford/PortTavernInterior.tscn",
		"out": "res://screenshots/port_tavern_art_check.png",
		"cam_pos": Vector3(0.5, 1.75, 3.6),
		"cam_look": Vector3(-1.0, 1.0, -3.6)
	},
	{
		"scene": "res://scenes/locations/greyford/RufinRoom.tscn",
		"out": "res://screenshots/rufin_room_art_check.png",
		"cam_pos": Vector3(-1.9, 1.8, 2.2),
		"cam_look": Vector3(1.4, 0.7, -1.6)
	},
	{
		"scene": "res://scenes/locations/greyford/GreyfordGate.tscn",
		"out": "res://screenshots/greyford_gate_art_check.png",
		"cam_pos": Vector3(4.5, 2.6, 3.5),
		"cam_look": Vector3(-0.5, 2.0, -6.0)
	}
]

var _idx := -1
var _frames := 0
var _current: Node3D
var _cam: Camera3D

func _init() -> void:
	call_deferred("_next")

func _next() -> void:
	if _current:
		_current.queue_free()
		_current = null
	_idx += 1
	if _idx >= SHOTS.size():
		quit(0)
		return
	var shot: Dictionary = SHOTS[_idx]
	var packed: PackedScene = load(shot["scene"])
	if packed == null:
		push_error("LOC_SHOT: failed to load " + str(shot["scene"]))
		quit(1)
		return
	_current = packed.instantiate()
	root.add_child(_current)
	_hide_players_and_labels(_current)
	if _cam == null:
		_cam = Camera3D.new()
		_cam.fov = 70.0
		root.add_child(_cam)
	_cam.make_current()
	_cam.global_position = shot["cam_pos"]
	_cam.look_at(shot["cam_look"], Vector3.UP)
	get_root().get_viewport().msaa_3d = Viewport.MSAA_4X
	DirAccess.make_dir_recursive_absolute("res://screenshots")
	_frames = 0
	print("LOC_SHOT_READY ", shot["scene"])

func _hide_players_and_labels(node: Node) -> void:
	if node is Label3D:
		(node as Label3D).visible = false
	if node.name == "Player" and node is Node3D:
		(node as Node3D).visible = false
	for child in node.get_children():
		_hide_players_and_labels(child)

func _process(_delta: float) -> bool:
	_frames += 1
	if _frames < 26:
		return false
	var shot: Dictionary = SHOTS[_idx]
	var err := get_root().get_viewport().get_texture().get_image().save_png(shot["out"])
	print("LOC_SHOT_SAVED ", shot["out"], " err=", err)
	call_deferred("_next")
	_frames = -100000
	return false
