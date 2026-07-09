extends Node
## Reputation Manager - Система репутації з фракціями
## Автор: nikijetson-lab

class_name ReputationManager

# Сигнали
signal reputation_changed(faction: String, old_value: int, new_value: int)
signal reputation_threshold_reached(faction: String, threshold: String)

# Межі репутації
const REP_MIN: int = -40
const REP_MAX: int = 40

# Пороги ставлення
enum Threshold {
	HATED = -30,      # Ненависть
	HOSTILE = -15,    # Ворожість
	NEUTRAL = 0,      # Нейтралітет
	FRIENDLY = 15,    # Дружність
	REVERED = 30      # Шанування
}

# Фракції (відповідають game-bible лору)
var factions: Dictionary = {
	"greyford": 0,        # Адміністрація Грейфорда
	"knives": 0,          # Орден Семи Кинджалів
	"keepers": 0,         # Хранителі/Ключники
	"muri": 0,            # Мурі (болотний народ)
	"lightbearers": 0     # Вартові (Орден Ліхтарів)
}

func _ready() -> void:
	print("ReputationManager initialized")

func modify_reputation(faction: String, amount: int) -> void:
	"""Змінити репутацію з фракцією"""
	if not factions.has(faction):
		push_error("Unknown faction: " + faction)
		return
	
	var old_value: int = factions[faction]
	var new_value: int = clamp(old_value + amount, REP_MIN, REP_MAX)
	
	if old_value == new_value:
		return  # Немає змін (досягли межі)
	
	factions[faction] = new_value
	reputation_changed.emit(faction, old_value, new_value)
	
	print("Reputation changed: %s [%d -> %d] (%+d)" % [faction, old_value, new_value, amount])
	
	# Перевірити зміну порогу
	check_threshold_change(faction, old_value, new_value)

func check_threshold_change(faction: String, old_value: int, new_value: int) -> void:
	"""Перевірити, чи змінився поріг ставлення"""
	var old_threshold = get_threshold_name(old_value)
	var new_threshold = get_threshold_name(new_value)
	
	if old_threshold != new_threshold:
		reputation_threshold_reached.emit(faction, new_threshold)
		print("Threshold reached: %s is now %s" % [faction, new_threshold])

func get_reputation(faction: String) -> int:
	"""Отримати поточну репутацію з фракцією"""
	return factions.get(faction, 0)

func get_threshold_name(rep_value: int) -> String:
	"""Отримати назву порогу за значенням репутації"""
	if rep_value >= Threshold.REVERED:
		return "Revered"
	elif rep_value >= Threshold.FRIENDLY:
		return "Friendly"
	elif rep_value > Threshold.HOSTILE:
		return "Neutral"
	elif rep_value > Threshold.HATED:
		return "Hostile"
	else:
		return "Hated"

func get_faction_attitude(faction: String) -> String:
	"""Отримати ставлення фракції до гравця"""
	var rep = get_reputation(faction)
	return get_threshold_name(rep)

func is_friendly(faction: String) -> bool:
	"""Чи дружня фракція?"""
	return get_reputation(faction) >= Threshold.FRIENDLY

func is_hostile(faction: String) -> bool:
	"""Чи ворожа фракція?"""
	return get_reputation(faction) <= Threshold.HOSTILE

func get_all_reputations() -> Dictionary:
	"""Отримати всі репутації (для UI)"""
	return factions.duplicate()

# Збереження/завантаження
func save_data() -> Dictionary:
	"""Зберегти дані репутації"""
	return factions.duplicate()

func load_data(data: Dictionary) -> void:
	"""Завантажити дані репутації"""
	for faction in data:
		if factions.has(faction):
			factions[faction] = clamp(int(data[faction]), REP_MIN, REP_MAX)

# Приклад використання в квесті:
# ReputationManager.modify_reputation("greyford", 5)  # +5 до Грейфорда
# ReputationManager.modify_reputation("knives", -10)  # -10 до Ордену Кинджалів
