extends Node
## Dialogue Manager - Система діалогів з NPC
## Підтримує: розгалуження, вибори, умови, наслідки
## Автор: nikijetson-lab

class_name DialogueManager

# Сигнали
signal dialogue_started(npc_id: String)
signal dialogue_line_changed(speaker: String, text: String)
signal dialogue_choices_presented(choices: Array)
signal dialogue_ended

# Поточний стан діалогу
var current_dialogue: Dictionary = {}
var current_node_id: String = ""
var is_dialogue_active: bool = false
var current_npc: String = ""

# Завантажені діалоги (з JSON файлів)
var dialogue_database: Dictionary = {}

func _ready() -> void:
	print("DialogueManager initialized")
	load_dialogues()

func load_dialogues() -> void:
	"""Завантажити всі діалоги з JSON файлів"""
	# TODO: Scan res://data/dialogues/ folder for .json files
	# Поки що заглушка
	print("Dialogues loaded from database")

func start_dialogue(npc_id: String, dialogue_id: String = "default") -> void:
	"""Почати діалог з NPC"""
	if is_dialogue_active:
		push_warning("Dialogue already active!")
		return
	
	# Завантажити діалог для цього NPC
	var dialogue_path = "res://data/dialogues/%s/%s.json" % [npc_id, dialogue_id]
	var dialogue_data = load_dialogue_file(dialogue_path)
	
	if dialogue_data.is_empty():
		push_error("Dialogue not found: " + dialogue_path)
		return
	
	current_dialogue = dialogue_data
	current_npc = npc_id
	current_node_id = dialogue_data.get("start_node", "node_0")
	is_dialogue_active = true
	
	dialogue_started.emit(npc_id)
	print("Dialogue started with: ", npc_id)
	
	# Показати першу репліку
	show_current_node()

func load_dialogue_file(path: String) -> Dictionary:
	"""Завантажити діалог з JSON файлу"""
	if not FileAccess.file_exists(path):
		return {}
	
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to open dialogue file: " + path)
		return {}
	
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(json_string)
	
	if error != OK:
		push_error("Failed to parse dialogue JSON: " + path)
		return {}
	
	return json.data

func show_current_node() -> void:
	"""Показати поточну ноду діалогу"""
	if not current_dialogue.has("nodes"):
		push_error("Dialogue has no nodes!")
		return
	
	var nodes: Dictionary = current_dialogue["nodes"]
	
	if not nodes.has(current_node_id):
		push_error("Node not found: " + current_node_id)
		end_dialogue()
		return
	
	var node: Dictionary = nodes[current_node_id]
	
	# Перевірити умови (якщо є)
	if node.has("condition") and not check_condition(node["condition"]):
		# Умова не виконана, пропустити на fallback
		if node.has("fallback_node"):
			current_node_id = node["fallback_node"]
			show_current_node()
		else:
			end_dialogue()
		return
	
	# Показати текст
	var speaker: String = node.get("speaker", current_npc)
	var text: String = node.get("text", "...")
	
	dialogue_line_changed.emit(speaker, text)
	
	# Перевірити, чи є варіанти вибору
	if node.has("choices") and node["choices"].size() > 0:
		dialogue_choices_presented.emit(node["choices"])
	else:
		# Автоматичний перехід до наступної ноди
		if node.has("next"):
			# Можна додати затримку або чекати на клік
			pass

func select_choice(choice_index: int) -> void:
	"""Гравець обрав варіант діалогу"""
	if not current_dialogue.has("nodes"):
		return
	
	var nodes: Dictionary = current_dialogue["nodes"]
	var node: Dictionary = nodes[current_node_id]
	
	if not node.has("choices"):
		push_error("Current node has no choices!")
		return
	
	var choices: Array = node["choices"]
	
	if choice_index < 0 or choice_index >= choices.size():
		push_error("Invalid choice index: " + str(choice_index))
		return
	
	var choice: Dictionary = choices[choice_index]
	
	# Виконати наслідки вибору
	if choice.has("consequences"):
		apply_consequences(choice["consequences"])
	
	# Перейти до наступної ноди
	if choice.has("next_node"):
		current_node_id = choice["next_node"]
		show_current_node()
	else:
		end_dialogue()

func continue_dialogue() -> void:
	"""Продовжити діалог (для нод без виборів)"""
	if not current_dialogue.has("nodes"):
		return
	
	var nodes: Dictionary = current_dialogue["nodes"]
	var node: Dictionary = nodes[current_node_id]
	
	if node.has("next"):
		current_node_id = node["next"]
		show_current_node()
	else:
		end_dialogue()

func end_dialogue() -> void:
	"""Завершити діалог"""
	is_dialogue_active = false
	current_dialogue = {}
	current_node_id = ""
	current_npc = ""
	
	dialogue_ended.emit()
	print("Dialogue ended")

func check_condition(condition: Dictionary) -> bool:
	"""Перевірити умову для показу ноди"""
	var type: String = condition.get("type", "")
	
	match type:
		"quest_active":
			var quest_id = condition.get("quest_id", "")
			return GameManager.quest_manager.get_quest(quest_id) != null
		
		"quest_completed":
			var quest_id = condition.get("quest_id", "")
			return quest_id in GameManager.quest_manager.completed_quests
		
		"reputation":
			var faction = condition.get("faction", "")
			var min_value = condition.get("min", -40)
			return GameManager.reputation_manager.get_reputation(faction) >= min_value
		
		"flag":
			var flag_name = condition.get("flag", "")
			# TODO: Global flags system
			return false
		
		_:
			push_warning("Unknown condition type: " + type)
			return true

func apply_consequences(consequences: Dictionary) -> void:
	"""Застосувати наслідки вибору"""
	# Зміна репутації
	if consequences.has("reputation"):
		for faction in consequences["reputation"]:
			var amount: int = consequences["reputation"][faction]
			GameManager.reputation_manager.modify_reputation(faction, amount)
			print("Reputation consequence: %s %+d" % [faction, amount])
	
	# Оновлення квесту
	if consequences.has("quest_update"):
		var quest_id = consequences["quest_update"]["quest_id"]
		var objective_id = consequences["quest_update"]["objective_id"]
		GameManager.quest_manager.update_objective(quest_id, objective_id)
		print("Quest updated: ", quest_id)
	
	# Старт квесту
	if consequences.has("quest_start"):
		var quest_data = consequences["quest_start"]
		GameManager.quest_manager.start_quest(quest_data)
		print("Quest started: ", quest_data.get("id", "?"))
	
	# Встановити глобальний флаг
	if consequences.has("set_flag"):
		var flag_name = consequences["set_flag"]
		# TODO: Global flags system
		print("Flag set: ", flag_name)

# Допоміжні функції для UI
func get_current_speaker() -> String:
	"""Отримати ім'я поточного мовця"""
	if not current_dialogue.has("nodes"):
		return ""
	
	var nodes: Dictionary = current_dialogue["nodes"]
	var node: Dictionary = nodes.get(current_node_id, {})
	
	return node.get("speaker", current_npc)

func get_current_text() -> String:
	"""Отримати поточний текст діалогу"""
	if not current_dialogue.has("nodes"):
		return ""
	
	var nodes: Dictionary = current_dialogue["nodes"]
	var node: Dictionary = nodes.get(current_node_id, {})
	
	return node.get("text", "")
