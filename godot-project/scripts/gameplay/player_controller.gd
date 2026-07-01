extends CharacterBody3D
## Player Controller - Керування персонажем гравця
## Базовий рух, камера, інтеракції
## Автор: nikijetson-lab

# Параметри руху
@export var walk_speed: float = 3.0
@export var run_speed: float = 5.0
@export var sprint_speed: float = 7.0
@export var jump_velocity: float = 4.5
@export var acceleration: float = 10.0
@export var friction: float = 15.0

# Параметри камери
@export var mouse_sensitivity: float = 0.002
@export var camera_distance: float = 3.0

# Стан персонажа
var current_speed: float = walk_speed
var is_sprinting: bool = false
var current_interactable: Node = null

# Вузли
@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera: Camera3D = $CameraPivot/Camera3D
@onready var interaction_area: Area3D = $InteractionArea

# Гравітація
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	add_to_group("player")
	interaction_area.area_entered.connect(_on_interaction_area_entered)
	interaction_area.area_exited.connect(_on_interaction_area_exited)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	# Обробка миші для камери
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_camera(event.relative)

func _unhandled_input(event: InputEvent) -> void:
	# Відпустити/захопити курсор на ESC
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("interact"):
		try_interact()

func _physics_process(delta: float) -> void:
	handle_movement(delta)
	handle_sprint()
	
	# Застосувати гравітацію
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Стрибок
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	if Input.is_action_just_pressed("interact"):
		try_interact()
	
	move_and_slide()

func handle_movement(delta: float) -> void:
	"""Обробка руху WASD"""
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * current_speed, acceleration * delta)
		velocity.z = move_toward(velocity.z, direction.z * current_speed, acceleration * delta)
		var target_rotation = atan2(direction.x, direction.z)
		rotation.y = lerp_angle(rotation.y, target_rotation, 10 * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		velocity.z = move_toward(velocity.z, 0, friction * delta)

func handle_sprint() -> void:
	"""Обробка спринту"""
	if Input.is_action_pressed("sprint"):
		is_sprinting = true
		current_speed = sprint_speed
	else:
		is_sprinting = false
		current_speed = run_speed

func rotate_camera(mouse_delta: Vector2) -> void:
	"""Обертання камери"""
	rotate_y(-mouse_delta.x * mouse_sensitivity)
	camera_pivot.rotate_x(-mouse_delta.y * mouse_sensitivity)
	camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, -PI / 2 + 0.1, PI / 2 - 0.1)

func try_interact() -> Dictionary:
	"""Спробувати взаємодію з найближчим NPC/об'єктом."""
	if current_interactable == null:
		return {}
	if current_interactable.has_method("can_interact") and not current_interactable.can_interact(self):
		return {}
	if current_interactable.has_method("interact"):
		return current_interactable.interact(self)
	return {}

func _on_interaction_area_entered(area: Area3D) -> void:
	if area.is_in_group("interactable") or area.has_method("interact"):
		current_interactable = area
		if area.has_method("get_interaction_prompt"):
			print(area.get_interaction_prompt())

func _on_interaction_area_exited(area: Area3D) -> void:
	if area == current_interactable:
		current_interactable = null
