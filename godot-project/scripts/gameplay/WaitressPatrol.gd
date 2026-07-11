extends Area3D
# WaitressPatrol — офіціантка ходить між столами і баром

@export var waypoints: Array[Vector3] = [
	Vector3(-3.1, 0.6, -3.35), # бар Ервана
	Vector3(-2.0, 0.6, 0.5),   # лівий стіл
	Vector3(0.0, 0.6, 2.0),    # центральний стіл
	Vector3(3.2, 0.6, 2.75),   # правий стіл
]
@export var wait_time: float = 3.0
@export var speed: float = 1.2

var _idx: int = 0
var _timer: float = 0.0
var _model: Node3D = null
var _animation_player: AnimationPlayer = null
var _current_animation_role: String = ""

func _ready() -> void:
	for ch: Node in get_children():
		if ch.name == "Body":
			(ch as Node3D).visible = false
		if ch.name == "Model" or ch.name.begins_with("Meshy") or ch.name.begins_with("meshy"):
			_model = ch as Node3D
	call_deferred("_setup_animation")

func _setup_animation() -> void:
	if _model != null:
		_animation_player = _find_animation_player(_model)
	_play_animation_role("idle")
	global_position = waypoints[0]

func _process(delta: float) -> void:
	if _model == null or waypoints.is_empty():
		return
	var target: Vector3 = waypoints[_idx]
	var dir: Vector3 = target - global_position
	dir.y = 0.0
	var dist: float = dir.length()
	if dist < 0.3:
		_play_animation_role("idle")
		_timer += delta
		if _timer >= wait_time:
			_timer = 0.0
			_idx = (_idx + 1) % waypoints.size()
	else:
		_play_animation_role("walk")
		_timer = 0.0
		var move: Vector3 = dir.normalized() * speed * delta
		global_position += move
		if dist > 0.1:
			_model.look_at(global_position + dir, Vector3.UP, true)

func _find_animation_player(root: Node) -> AnimationPlayer:
	if root is AnimationPlayer:
		return root as AnimationPlayer
	for child: Node in root.get_children():
		var found: AnimationPlayer = _find_animation_player(child)
		if found != null:
			return found
	return null

func _play_animation_role(role: String) -> void:
	if _animation_player == null or _current_animation_role == role:
		return
	var animation_name: String = _resolve_animation_name(role)
	if animation_name.is_empty():
		return
	_animation_player.play(animation_name)
	_current_animation_role = role

func _resolve_animation_name(role: String) -> String:
	if _animation_player == null:
		return ""
	if _animation_player.has_animation(role):
		return role
	var needle: String = role.to_lower()
	for animation_name: StringName in _animation_player.get_animation_list():
		var candidate: String = String(animation_name)
		if candidate.to_lower().contains(needle):
			return candidate
	return ""
