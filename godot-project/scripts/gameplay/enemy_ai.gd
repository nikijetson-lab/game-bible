extends CharacterBody3D
## Enemy AI - Базовий AI для ворогів
## State machine: Idle → Chase → Attack → Death

# AI States
enum State {
	IDLE,
	PATROL,
	CHASE,
	ATTACK,
	FLEE,
	DEAD
}

# Parameters
@export var max_health: float = 50.0
@export var move_speed: float = 3.5
@export var chase_speed: float = 5.0
@export var attack_range: float = 2.0
@export var detection_range: float = 10.0
@export var attack_damage: float = 15.0
@export var attack_cooldown: float = 1.5

# References
@onready var health_component: HealthComponent = $HealthComponent
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

# State
var current_state: State = State.IDLE
var target: Node3D = null
var attack_timer: float = 0.0

# Gravity
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	# Setup health component
	if health_component:
		health_component.max_health = max_health
		health_component.current_health = max_health
		health_component.died.connect(_on_died)

func _physics_process(delta: float) -> void:
	if current_state == State.DEAD:
		return
	
	# Гравітація
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# AI Logic
	match current_state:
		State.IDLE:
			_state_idle(delta)
		State.PATROL:
			_state_patrol(delta)
		State.CHASE:
			_state_chase(delta)
		State.ATTACK:
			_state_attack(delta)
		State.FLEE:
			_state_flee(delta)
	
	# Cooldown атаки
	if attack_timer > 0:
		attack_timer -= delta
	
	move_and_slide()

# State: Idle
func _state_idle(delta: float) -> void:
	"""Стоїмо на місці, шукаємо гравця"""
	velocity.x = 0
	velocity.z = 0
	
	# Шукати гравця
	detect_player()

# State: Patrol (TODO: later)
func _state_patrol(delta: float) -> void:
	"""Патрулювання"""
	pass

# State: Chase
func _state_chase(delta: float) -> void:
	"""Переслідування гравця"""
	if not target:
		current_state = State.IDLE
		return
	
	var distance = global_position.distance_to(target.global_position)
	
	# Якщо досить близько — атакуємо
	if distance <= attack_range:
		current_state = State.ATTACK
		return
	
	# Якщо занадто далеко — втрачаємо
	if distance > detection_range * 1.5:
		target = null
		current_state = State.IDLE
		return
	
	# Рухатись до гравця
	navigation_agent.target_position = target.global_position
	var next_path_position = navigation_agent.get_next_path_position()
	var direction = (next_path_position - global_position).normalized()
	
	velocity.x = direction.x * chase_speed
	velocity.z = direction.z * chase_speed
	
	# Повертаємось до цілі
	look_at(Vector3(target.global_position.x, global_position.y, target.global_position.z), Vector3.UP)

# State: Attack
func _state_attack(delta: float) -> void:
	"""Атака гравця"""
	if not target:
		current_state = State.IDLE
		return
	
	var distance = global_position.distance_to(target.global_position)
	
	# Якщо гравець вийшов за межі атаки — переслідуємо
	if distance > attack_range + 0.5:
		current_state = State.CHASE
		return
	
	# Зупинити рух
	velocity.x = 0
	velocity.z = 0
	
	# Дивимось на гравця
	look_at(Vector3(target.global_position.x, global_position.y, target.global_position.z), Vector3.UP)
	
	# Атакувати якщо cooldown закінчився
	if attack_timer <= 0:
		perform_attack()
		attack_timer = attack_cooldown

# State: Flee
func _state_flee(delta: float) -> void:
	"""Втікати (низьке здоров'я)"""
	if not target:
		current_state = State.IDLE
		return
	
	# Тікати в протилежний бік від гравця
	var direction = (global_position - target.global_position).normalized()
	velocity.x = direction.x * move_speed
	velocity.z = direction.z * move_speed

# Виявлення гравця
func detect_player() -> void:
	"""Шукати гравця в радіусі"""
	# Простий пошук — можна замінити на Area3D або RayCast
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var distance = global_position.distance_to(player.global_position)
		if distance <= detection_range:
			target = player
			current_state = State.CHASE
			print("%s detected player!" % name)

# Атака
func perform_attack() -> void:
	"""Виконати атаку"""
	if not target or not target.has_node("HealthComponent"):
		return
	
	print("%s attacks %s for %d damage!" % [name, target.name, attack_damage])
	
	var target_health = target.get_node("HealthComponent")
	if CombatManager:
		CombatManager.deal_damage(self, target_health.get_parent(), attack_damage, CombatManager.DamageType.PHYSICAL)
	else:
		target_health.take_damage(attack_damage, "physical")

# Смерть
func _on_died() -> void:
	"""Обробити смерть"""
	current_state = State.DEAD
	velocity = Vector3.ZERO
	
	# Відключити колізію
	collision_layer = 0
	collision_mask = 0
	
	print("%s died" % name)
	
	# Анімація смерті (TODO)
	# await get_tree().create_timer(2.0).timeout
	# queue_free()

# Отримати урон (викликається HealthComponent)
func take_damage(amount: float, damage_type: String) -> void:
	"""Передати урон у HealthComponent"""
	if health_component:
		health_component.take_damage(amount, damage_type)
		
		# Якщо здоров'я низьке — втікати
		if health_component.get_health_percent() < 0.3 and current_state != State.FLEE:
			current_state = State.FLEE
			print("%s is fleeing!" % name)
