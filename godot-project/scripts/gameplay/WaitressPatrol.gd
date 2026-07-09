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

func _ready() -> void:
	for ch: Node in get_children():
		if ch.name == "Body":
			(ch as Node3D).visible = false
		if ch.name == "Model" or ch.name.begins_with("Meshy") or ch.name.begins_with("meshy"):
			_model = ch as Node3D
	global_position = waypoints[0]

func _process(delta: float) -> void:
	if _model == null or waypoints.is_empty():
		return
	var target: Vector3 = waypoints[_idx]
	var dir: Vector3 = target - global_position
	dir.y = 0.0
	var dist: float = dir.length()
	if dist < 0.3:
		_timer += delta
		if _timer >= wait_time:
			_timer = 0.0
			_idx = (_idx + 1) % waypoints.size()
	else:
		_timer = 0.0
		var move: Vector3 = dir.normalized() * speed * delta
		global_position += move
		if dist > 0.1:
			_model.look_at(global_position + dir, Vector3.UP, true)
