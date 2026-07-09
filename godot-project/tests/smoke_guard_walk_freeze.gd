extends SceneTree

const SCENE_PATH := "res://scenes/locations/greyford/TavernInterior.tscn"
const MODEL_PATH := "NPCs/GreyfordGuard/MeshyGuardModel"
const EXPECTED_SCRIPT := "res://scripts/gameplay/GuardWalkAnim.gd"
const EXPECTED_TIME := 0.0

var _scene: Node = null
var _frames: int = 0

func _init() -> void:
	call_deferred("_setup")

func _setup() -> void:
	var packed: PackedScene = load(SCENE_PATH)
	if packed == null:
		push_error("failed to load scene")
		quit(1)
		return
	_scene = packed.instantiate()
	if _scene == null:
		push_error("failed to instantiate scene")
		quit(1)
		return
	root.add_child(_scene)

func _process(_delta: float) -> bool:
	_frames += 1
	if _frames < 8:
		return false
	var model: Node = _scene.get_node_or_null(MODEL_PATH)
	if model == null:
		push_error("missing model node: " + MODEL_PATH)
		quit(1)
		return true
	var script_res: Script = model.get_script() as Script
	if script_res == null:
		push_error("model script is null")
		quit(1)
		return true
	var script_path: String = script_res.resource_path
	if script_path != EXPECTED_SCRIPT:
		push_error("wrong script: " + script_path)
		quit(1)
		return true
	var player: AnimationPlayer = _find_animation_player(model)
	if player == null:
		push_error("missing AnimationPlayer under model")
		quit(1)
		return true
	var pos: float = player.current_animation_position
	var playing: bool = player.is_playing()
	var anim_name: String = player.current_animation
	print("GUARD_FREEZE_SMOKE script=", script_path, " anim=", anim_name, " pos=", pos, " playing=", playing)
	if playing:
		push_error("AnimationPlayer still playing")
		quit(1)
		return true
	if abs(pos - EXPECTED_TIME) > 0.02:
		push_error("AnimationPlayer not at freeze time: " + str(pos))
		quit(1)
		return true
	print("GUARD_FREEZE_SMOKE_OK")
	quit(0)
	return true

func _find_animation_player(node: Node) -> AnimationPlayer:
	for child in node.get_children():
		if child is AnimationPlayer:
			return child as AnimationPlayer
		var nested: AnimationPlayer = _find_animation_player(child)
		if nested != null:
			return nested
	return null
