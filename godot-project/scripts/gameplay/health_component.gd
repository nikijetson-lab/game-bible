extends Node
## Health Component - Компонент здоров'я
## Прикріплюється до CharacterBody3D або іншої сутності
## Керує HP, регенерацією, смертю

class_name HealthComponent

# Сигнали
signal health_changed(old_value: float, new_value: float)
signal damage_taken(amount: float, damage_type: String)
signal healed(amount: float)
signal died

# Параметри
@export var max_health: float = 100.0
@export var current_health: float = 100.0
@export var defense: float = 0.0  # Захист (зменшує урон)
@export var regen_rate: float = 0.0  # HP/sec регенерація
@export var invulnerable: bool = false  # Безсмертний режим

# Резистанси (0.0 = нема, 1.0 = повний імунітет)
@export var resistances: Dictionary = {
	"physical": 0.0,
	"fire": 0.0,
	"cold": 0.0,
	"poison": 0.0,
	"magic": 0.0
}

# Status effects
var active_status_effects: Array[Dictionary] = []

func _ready() -> void:
	current_health = max_health

func _process(delta: float) -> void:
	# Регенерація
	if regen_rate > 0 and current_health < max_health:
		heal(regen_rate * delta)
	
	# Обробити статус-ефекти
	process_status_effects(delta)

func take_damage(amount: float, damage_type: String = "physical") -> void:
	"""Отримати урон"""
	if invulnerable or is_dead():
		return
	
	var old_health = current_health
	current_health = max(0.0, current_health - amount)
	
	damage_taken.emit(amount, damage_type)
	health_changed.emit(old_health, current_health)
	
	# Перевірити смерть
	if current_health <= 0:
		die()

func heal(amount: float) -> void:
	"""Вилікувати"""
	if is_dead():
		return
	
	var old_health = current_health
	current_health = min(max_health, current_health + amount)
	
	healed.emit(amount)
	health_changed.emit(old_health, current_health)

func die() -> void:
	"""Смерть"""
	died.emit()
	print("%s has died" % get_parent().name)

func is_dead() -> bool:
	"""Чи мертвий?"""
	return current_health <= 0

func get_health_percent() -> float:
	"""Відсоток здоров'я (0.0 to 1.0)"""
	return current_health / max_health

# Status Effects System
func add_status_effect(effect_name: String, duration: float, params: Dictionary = {}) -> void:
	"""Додати статус-ефект"""
	var effect = {
		"name": effect_name,
		"duration": duration,
		"elapsed": 0.0,
		"params": params
	}
	active_status_effects.append(effect)
	print("Status effect added: %s" % effect_name)

func process_status_effects(delta: float) -> void:
	"""Обробити всі активні статус-ефекти"""
	var effects_to_remove = []
	
	for i in range(active_status_effects.size()):
		var effect = active_status_effects[i]
		effect["elapsed"] += delta
		
		# Застосувати ефект
		apply_status_effect_tick(effect, delta)
		
		# Перевірити чи закінчився
		if effect["elapsed"] >= effect["duration"]:
			effects_to_remove.append(i)
	
	# Видалити завершені ефекти (в зворотному порядку)
	for i in range(effects_to_remove.size() - 1, -1, -1):
		var idx = effects_to_remove[i]
		print("Status effect ended: %s" % active_status_effects[idx]["name"])
		active_status_effects.remove_at(idx)

func apply_status_effect_tick(effect: Dictionary, delta: float) -> void:
	"""Застосувати один тік статус-ефекту"""
	match effect["name"]:
		"poison":
			# Отруєння — періодичний урон
			var damage_per_second = effect["params"].get("dps", 5.0)
			take_damage(damage_per_second * delta, "poison")
		
		"burn":
			# Горіння — урон + зменшення регена
			var damage_per_second = effect["params"].get("dps", 8.0)
			take_damage(damage_per_second * delta, "fire")
		
		"bleed":
			# Кровотеча — урон що зростає
			var base_dps = effect["params"].get("base_dps", 3.0)
			var multiplier = 1.0 + (effect["elapsed"] / effect["duration"])
			take_damage(base_dps * multiplier * delta, "physical")
		
		"regen":
			# Регенерація (позитивний ефект)
			var heal_per_second = effect["params"].get("hps", 10.0)
			heal(heal_per_second * delta)
		
		"stun":
			# Приголомшення — блокує рух (треба обробити в контролері)
			pass

func has_status_effect(effect_name: String) -> bool:
	"""Чи активний цей статус-ефект?"""
	for effect in active_status_effects:
		if effect["name"] == effect_name:
			return true
	return false

func remove_status_effect(effect_name: String) -> void:
	"""Видалити статус-ефект достроково"""
	for i in range(active_status_effects.size() - 1, -1, -1):
		if active_status_effects[i]["name"] == effect_name:
			active_status_effects.remove_at(i)
			print("Status effect removed: %s" % effect_name)
