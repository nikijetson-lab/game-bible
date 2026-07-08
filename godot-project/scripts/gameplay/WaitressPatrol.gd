extends Area3D
# WaitressPatrol — офіціантка ходить між столами і баром

@export var waypoints: Array[Vector3] = [
	Vector3(-3.1, 0.6, -3.35), # бар Ервана
	Vector3(-2.0, 0.6, 0.5),   # лівий стіл
	Vector3(0, 0.6, 2.0),      # центральний стіл
	Vector3(3.2, 0.6, 2.75),   # правий стіл
]
@export var wait_time := 3.0
@export var speed := 1.2

var _idx := 0
var _timer := 0.0
var _model: Node3D

func _ready() -> void:
	for ch in get_children():
		if ch.name == "Body":
			ch.visible = true  # показуємо капсулу-заглушку
		if ch.name == "Model" or ch.name.begins_with("Meshy") or ch.name.begins_with("meshy"):
			_model = ch as Node3D
	if not _model:
		# нема моделі — використовуємо Body як видиму фігуру
		for ch in get_children():
			if ch.name == "Body":
				_model = ch as Node3D
				break
	global_position = waypoints[0]

func _process(delta: float) -> void:
	if not _model:
		return
	var target := waypoints[_idx]
	var dir := target - global_position
	dir.y = 0
	if dir.length() < 0.3:
		_timer += delta
		if _timer >= wait_time:
			_timer = 0.0
			_idx = (_idx + 1) % waypoints.size()
	else:
		_timer = 0.0
		var move := dir.normalized() * speed * delta
		global_position += move
		if dir.length() > 0.1:
			_model.look_at(global_position + dir, Vector3.UP, true)
