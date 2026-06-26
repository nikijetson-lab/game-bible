extends Node
## Combat Manager - Система бою
## Керує боєм, урон, ефекти, combo
## Автор: nikijetson-lab

class_name CombatManager

# Сигнали
signal damage_dealt(attacker: Node, target: Node, amount: float, damage_type: String)
signal entity_died(entity: Node)
signal combat_started(player: Node, enemy: Node)
signal combat_ended

# Типи урону
enum DamageType {
	PHYSICAL,     # Фізичний урон
	FIRE,         # Вогонь
	COLD,         # Холод
	POISON,       # Отруєння
	MAGIC         # Магічний
}

# Стан бою
var in_combat: bool = false
var active_combatants: Array = []

func _ready() -> void:
	print("CombatManager initialized")

# Основна функція нанесення урону
func deal_damage(attacker: Node, target: Node, base_damage: float, damage_type: int = DamageType.PHYSICAL) -> void:
	"""Нанести урон цілі з ураху

ванням захисту та резистів"""
	if not target or not target.has_method("take_damage"):
		push_error("Target cannot take damage")
		return
	
	# Отримати статистику цілі
	var defense: float = target.get("defense") if target.has("defense") else 0.0
	var resistances: Dictionary = target.get("resistances") if target.has("resistances") else {}
	
	# Розрахувати фінальний урон
	var final_damage: float = calculate_damage(base_damage, defense, damage_type, resistances)
	
	# Нанести урон
	target.take_damage(final_damage, damage_type)
	
	# Викликати сигнал
	damage_dealt.emit(attacker, target, final_damage, DamageType.keys()[damage_type])
	
	print("%s dealt %.1f %s damage to %s" % [
		attacker.name if attacker else "Unknown",
		final_damage,
		DamageType.keys()[damage_type],
		target.name
	])
	
	# Перевірити смерть
	if target.has_method("is_dead") and target.is_dead():
		on_entity_died(target)

func calculate_damage(base: float, defense: float, damage_type: int, resistances: Dictionary) -> float:
	"""Розрахувати фінальний урон з урахуванням захисту"""
	# Формула: урон = base * (1 - (defense / (defense + 100))) * (1 - resist)
	var damage_after_defense: float = base * (100.0 / (100.0 + defense))
	
	# Застосувати резист
	var resist: float = 0.0
	var damage_type_name = DamageType.keys()[damage_type].to_lower()
	if resistances.has(damage_type_name):
		resist = resistances[damage_type_name]
	
	var final_damage: float = damage_after_defense * (1.0 - resist)
	
	return max(1.0, final_damage)  # Мінімум 1 урон

# Критичний удар
func calculate_critical_hit(base_damage: float, crit_chance: float, crit_multiplier: float = 1.5) -> float:
	"""Перевірити крит і повернути урон"""
	if randf() < crit_chance:
		print("CRITICAL HIT!")
		return base_damage * crit_multiplier
	return base_damage

# Стан бою
func start_combat(player: Node, enemy: Node) -> void:
	"""Почати бій"""
	if in_combat:
		return
	
	in_combat = true
	active_combatants = [player, enemy]
	combat_started.emit(player, enemy)
	print("Combat started: %s vs %s" % [player.name, enemy.name])

func end_combat() -> void:
	"""Закінчити бій"""
	if not in_combat:
		return
	
	in_combat = false
	active_combatants.clear()
	combat_ended.emit()
	print("Combat ended")

func on_entity_died(entity: Node) -> void:
	"""Обробити смерть сутності"""
	entity_died.emit(entity)
	print("%s has died" % entity.name)
	
	# Видалити зі списку комбатантів
	if entity in active_combatants:
		active_combatants.erase(entity)
	
	# Якщо всі вороги мертві — закінчити бій
	if in_combat and should_end_combat():
		end_combat()

func should_end_combat() -> bool:
	"""Перевірити чи треба закінчити бій"""
	# Якщо залишився тільки гравець або менше 2 комбатантів
	return active_combatants.size() < 2

# Status Effects
func apply_status_effect(target: Node, effect_name: String, duration: float, params: Dictionary = {}) -> void:
	"""Застосувати статус-ефект"""
	if not target.has_method("add_status_effect"):
		push_warning("Target cannot receive status effects")
		return
	
	target.add_status_effect(effect_name, duration, params)
	print("%s received status: %s for %.1fs" % [target.name, effect_name, duration])

# Heal
func heal(target: Node, amount: float) -> void:
	"""Вилікувати ціль"""
	if not target.has_method("heal"):
		push_warning("Target cannot be healed")
		return
	
	target.heal(amount)
	print("%s healed for %.1f HP" % [target.name, amount])

# Combo System
var combo_count: int = 0
var combo_time_limit: float = 2.0
var combo_timer: float = 0.0

func register_hit() -> void:
	"""Зареєструвати удар для комбо"""
	combo_count += 1
	combo_timer = combo_time_limit
	print("Combo: x%d" % combo_count)

func get_combo_multiplier() -> float:
	"""Отримати множник урону від комбо"""
	return 1.0 + (combo_count * 0.1)  # +10% за кожен удар в комбо

func reset_combo() -> void:
	"""Скинути комбо"""
	if combo_count > 0:
		print("Combo lost!")
		combo_count = 0

func _process(delta: float) -> void:
	# Таймер комбо
	if combo_timer > 0:
		combo_timer -= delta
		if combo_timer <= 0:
			reset_combo()
