extends Node
## Quest Manager - Система керування квестами
## Автор: nikijetson-lab

class_name QuestManager

# Сигнали
signal quest_started(quest_id: String)
signal quest_updated(quest_id: String)
signal quest_completed(quest_id: String)
signal objective_completed(quest_id: String, objective_id: String)

# Дані квестів
var active_quests: Dictionary = {}  # quest_id -> Quest
var completed_quests: Array[String] = []

# Клас Quest
class Quest:
	var id: String
	var title: String
	var description: String
	var objectives: Array[Objective] = []
	var rewards: Dictionary = {}
	var is_completed: bool = false
	
	func _init(data: Dictionary):
		id = data.get("id", "")
		title = data.get("title", "")
		description = data.get("description", "")
		
		# Парсинг цілей
		for obj_data in data.get("objectives", []):
			objectives.append(Objective.new(obj_data))

	class Objective:
		var id: String
		var description: String
		var type: String  # "talk", "collect", "go_to", "kill"
		var target: String
		var current_progress: int = 0
		var target_progress: int = 1
		var is_completed: bool = false
		
		func _init(data: Dictionary):
			id = data.get("id", "")
			description = data.get("description", "")
			type = data.get("type", "talk")
			target = data.get("target", "")
			target_progress = data.get("count", 1)

func start_quest(quest_data: Dictionary) -> void:
	"""Розпочати квест"""
	var quest = Quest.new(quest_data)
	
	if active_quests.has(quest.id):
		push_warning("Quest already active: " + quest.id)
		return
	
	active_quests[quest.id] = quest
	quest_started.emit(quest.id)
	print("Quest started: ", quest.title)

func update_objective(quest_id: String, objective_id: String, progress: int = 1) -> void:
	"""Оновити прогрес цілі квесту"""
	if not active_quests.has(quest_id):
		push_error("Quest not found: " + quest_id)
		return
	
	var quest: Quest = active_quests[quest_id]
	
	for objective in quest.objectives:
		if objective.id == objective_id:
			objective.current_progress += progress
			
			# Перевірити завершення цілі
			if objective.current_progress >= objective.target_progress:
				objective.is_completed = true
				objective_completed.emit(quest_id, objective_id)
				print("Objective completed: ", objective.description)
			
			quest_updated.emit(quest_id)
			
			# Перевірити завершення всього квесту
			check_quest_completion(quest_id)
			return
	
	push_error("Objective not found: " + objective_id)

func check_quest_completion(quest_id: String) -> void:
	"""Перевірити, чи всі цілі виконані"""
	var quest: Quest = active_quests[quest_id]
	
	for objective in quest.objectives:
		if not objective.is_completed:
			return  # Є ще невиконані цілі
	
	# Всі цілі виконані
	complete_quest(quest_id)

func complete_quest(quest_id: String) -> void:
	"""Завершити квест"""
	if not active_quests.has(quest_id):
		return
	
	var quest: Quest = active_quests[quest_id]
	quest.is_completed = true
	
	completed_quests.append(quest_id)
	active_quests.erase(quest_id)
	
	quest_completed.emit(quest_id)
	print("Quest completed: ", quest.title)
	
	# TODO: Видати нагороди
	give_rewards(quest.rewards)

func give_rewards(rewards: Dictionary) -> void:
	"""Видати нагороди за квест"""
	# TODO: Implement reward system
	if rewards.has("reputation"):
		print("Reputation rewards: ", rewards["reputation"])
	if rewards.has("items"):
		print("Item rewards: ", rewards["items"])

func get_active_quests() -> Array:
	"""Отримати список активних квестів"""
	return active_quests.values()

func get_quest(quest_id: String) -> Quest:
	"""Отримати конкретний квест"""
	return active_quests.get(quest_id, null)

# Збереження/завантаження
func save_data() -> Dictionary:
	"""Зберегти дані квестів"""
	return {
		"active_quests": active_quests.keys(),
		"completed_quests": completed_quests
	}

func load_data(data: Dictionary) -> void:
	"""Завантажити дані квестів"""
	completed_quests = data.get("completed_quests", [])
	# TODO: Reload active quests from quest database
