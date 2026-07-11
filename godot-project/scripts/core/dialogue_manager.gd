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
var _dialogue_files: Dictionary = {}  # npc_id -> file_path
var _npc_registry: Dictionary = {}    # npc_registry.json data

func _ready() -> void:
	print("DialogueManager initialized")
	_load_npc_registry()
	load_dialogues()

func _load_npc_registry() -> void:
	"""Завантажити NPC registry для крос-референсу quest→dialogue."""
	var path: Variant = "res://data/npcs/npc_registry.json"
	if not FileAccess.file_exists(path):
		push_warning("NPC registry not found: " + path)
		return
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	var text: String = file.get_as_text()
	file.close()
	var json: Variant = JSON.new()
	if json.parse(text) == OK:
		_npc_registry = json.data
		print("NPC registry loaded: ", _npc_registry.get("npc_dialogues", {}).size(), " NPCs")

func load_dialogues() -> void:
	"""Завантажити всі діалоги з data/dialogues/."""
	# Використовуємо NPC registry для списку папок
	var dialogues_map: Variant = _npc_registry.get("npc_dialogues", {})
	if dialogues_map.is_empty():
		# Fallback: скануємо диск
		_scan_dialogue_folders()
		return
	for npc_id in dialogues_map:
		var files: Array = dialogues_map[npc_id].get("files", [])
		if files.is_empty():
			continue
		# Завантажуємо перший файл як default
		var first_file: String = files[0]
		var path: Variant = "res://data/dialogues/%s/%s" % [npc_id, first_file]
		var data: Dictionary = load_dialogue_file(path)
		if not data.is_empty():
			dialogue_database[npc_id] = data
			_dialogue_files[npc_id] = path
	print("Dialogues loaded: ", dialogue_database.size(), " NPCs")

func _scan_dialogue_folders() -> void:
	"""Сканувати data/dialogues/ для пошуку папок NPC."""
	var dir: DirAccess = DirAccess.open("res://data/dialogues")
	if dir == null:
		return
	dir.list_dir_begin()
	var folder: String = dir.get_next()
	while folder != "":
		if dir.current_is_dir() and not folder.begins_with("_"):
			var sub: DirAccess = DirAccess.open("res://data/dialogues/" + folder)
			if sub:
				sub.list_dir_begin()
				var f: String = sub.get_next()
				while f != "":
					if f.ends_with(".json") and not sub.current_is_dir():
						var path: Variant = "res://data/dialogues/%s/%s" % [folder, f]
						dialogue_database[folder] = load_dialogue_file(path)
						_dialogue_files[folder] = path
						break
					f = sub.get_next()
		folder = dir.get_next()

func start_dialogue(npc_id: String, dialogue_id: String = "default") -> void:
	"""Почати діалог з NPC. npc_id — quest target або NPC ім'я."""
	if is_dialogue_active:
		push_warning("Dialogue already active!")
		return

	# Резолвити NPC alias (quest target -> dialogue folder)
	var resolved: String = _resolve_npc(npc_id)
	var path: String
	var data: Dictionary = {}

	if dialogue_id == "default":
		# Спершу шукаємо в завантаженій базі
		if resolved != "" and dialogue_database.has(resolved):
			data = dialogue_database[resolved]
			path = _dialogue_files.get(resolved, "")
		else:
			path = "res://data/dialogues/%s/%s.json" % [npc_id, dialogue_id]
			data = load_dialogue_file(path)
	else:
		path = "res://data/dialogues/%s/%s.json" % [resolved if resolved != "" else npc_id, dialogue_id]
		data = load_dialogue_file(path)

	if data.is_empty() and resolved != "" and resolved != npc_id:
		# Друга спроба з оригінальним ім'ям
		path = "res://data/dialogues/%s/%s.json" % [npc_id, dialogue_id]
		data = load_dialogue_file(path)
	
	if data.is_empty():
		push_error("Dialogue not found for NPC: " + npc_id)
		return

	current_dialogue = data
	current_npc = npc_id
	current_node_id = data.get("start_node", "node_0")
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
	"""Завершити діалог і авто-завершити quest objectives що таргетять цього NPC."""
	_auto_complete_npc_objectives(current_npc)
	is_dialogue_active = false
	current_dialogue = {}
	current_node_id = ""
	current_npc = ""
	
	dialogue_ended.emit()
	print("Dialogue ended")

func _resolve_npc(npc_id: String) -> String:
	"""Резолвити quest target або NPC ім'я до dialogue folder name."""
	var aliases: Dictionary = _npc_registry.get("npc_aliases", {})
	if aliases.has(npc_id):
		return aliases[npc_id]
	# Strip npc_ prefix and try
	if npc_id.begins_with("npc_"):
		var bare: String = npc_id.substr(4)
		if _npc_registry.get("npc_dialogues", {}).has(bare):
			return bare
	return npc_id

func _auto_complete_npc_objectives(npc_id: String) -> void:
	"""Авто-завершити quest objectives типу 'talk' що таргетять цього NPC."""
	var qm: Node = get_node_or_null("/root/Quests")
	if not qm or not qm.has_method("complete_objective"):
		return
	var targets: Array = _npc_registry.get("quest_targets", {}).get(npc_id, [])
	if targets.is_empty():
		# Спробувати резолвнуту версію
		var resolved: String = _resolve_npc(npc_id)
		if resolved != npc_id:
			targets = _npc_registry.get("quest_targets", {}).get(resolved, [])
	for t in targets:
		var quest_id: String = t.get("quest", "")
		var objective_id: String = t.get("objective", "")
		if not quest_id.is_empty() and not objective_id.is_empty():
			if qm.active_quests.has(quest_id):
				qm.complete_objective(quest_id, objective_id)
				print("Dialogue: auto-completed objective ", objective_id, " for quest ", quest_id)

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
			return GameManager.has_flag(flag_name)
		
		"not_flag":
			var flag_name = condition.get("flag", "")
			return not GameManager.has_flag(flag_name)
		
		"doctrine":
			# Доктрина Вартового: lantern/judge/mediator/scout
			var doctrine = condition.get("value", "")
			return GameManager.player_doctrine == doctrine
		
		"any_of":
			# Хоча б одна з вкладених умов
			var subconditions = condition.get("conditions", [])
			for sub in subconditions:
				if check_condition(sub):
					return true
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
		var qm: Node = get_node_or_null("/root/Quests")
		if qm and qm.has_method("complete_objective"):
			qm.complete_objective(quest_id, objective_id)
		print("Quest objective completed: ", objective_id)

	# Старт квесту
	if consequences.has("quest_start"):
		var quest_id = consequences["quest_start"]
		var qm2: Node = get_node_or_null("/root/Quests")
		if qm2 and qm2.has_method("try_start_quest"):
			qm2.try_start_quest(quest_id)
		print("Quest started: ", quest_id)
	
	# Встановити глобальний флаг (рядок або масив рядків)
	if consequences.has("set_flag"):
		var flag_value = consequences["set_flag"]
		if flag_value is Array:
			for f in flag_value:
				GameManager.set_flag(str(f))
		else:
			GameManager.set_flag(str(flag_value))

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


