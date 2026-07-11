extends Node
## Quest Manager — Система керування квестами
##
## Завантажує всі квести з data/quests/*.json, відстежує активні/завершені,
## перевіряє передумови, розблоковує наступні квести через leads_to,
## і сповіщає UI через сигнали.
class_name QuestManager

# Сигнали
signal quest_started(quest_id: String)
signal quest_updated(quest_id: String)
signal quest_completed(quest_id: String, resolution: String)
signal objective_completed(quest_id: String, objective_id: String)
signal quest_available(quest_id: String)

# Кеш усіх квестів із JSON
var _quest_db: Dictionary = {}        # quest_id -> повний JSON Dictionary
var active_quests: Dictionary = {}    # quest_id -> Quest
var completed_quests: Array[String] = []
var world_flags: Dictionary = {}      # flag_name -> value (для resolution_choice тощо)
var completed_objectives: Dictionary = {}  # quest_id -> Array[String] виконаних objective id

# --- Завантаження з диска ---

func load_all_quests(quest_dir: String = "res://data/quests") -> void:
	"""Завантажити всі quest JSON із папки (викликати при старті гри)."""
	var dir := DirAccess.open(quest_dir)
	if dir == null:
		push_error("QuestManager: cannot open quest directory: " + quest_dir)
		return
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".json") and not file_name.begins_with("_"):
			var path := quest_dir + "/" + file_name
			if FileAccess.file_exists(path):
				var file := FileAccess.open(path, FileAccess.READ)
				var text := file.get_as_text()
				file.close()
				var json := JSON.new()
				if json.parse(text) == OK:
					var data = json.data
					var qid = data.get("id", "")
					if qid != "":
						_quest_db[qid] = data
		file_name = dir.get_next()
	dir.list_dir_end()
	print("QuestManager: loaded ", _quest_db.size(), " quests from ", quest_dir)

# --- Публічний API ---

func try_start_quest(quest_id: String) -> bool:
	"""Спробувати запустити квест. Повертає true якщо запущено."""
	if quest_id in active_quests or quest_id in completed_quests:
		return false
	if not _quest_db.has(quest_id):
		push_error("QuestManager: unknown quest id: " + quest_id)
		return false
	if not _check_prerequisites(quest_id):
		return false
	_start_quest_internal(quest_id)
	return true

func complete_objective(quest_id: String, objective_id: String) -> void:
	"""Позначити objective як виконаний. Перевіряє completion_conditions."""
	if not active_quests.has(quest_id):
		return
	if not completed_objectives.has(quest_id):
		completed_objectives[quest_id] = []
	if objective_id in completed_objectives[quest_id]:
		return
	completed_objectives[quest_id].append(objective_id)
	objective_completed.emit(quest_id, objective_id)
	quest_updated.emit(quest_id)
	_check_quest_completion(quest_id)

func resolve_quest(quest_id: String, resolution: String) -> void:
	"""Завершити квест із вибором resolution (A/B/V/G)."""
	if not active_quests.has(quest_id):
		return
	var data := _quest_db.get(quest_id, {})
	# Встановити флаги з resolution_choice
	var rc := data.get("resolution_choice", {})
	for opt in rc.get("options", []):
		if opt.get("id", "") == resolution or opt.get("resolution", "") == resolution:
			var sf := opt.get("set_flag", "")
			if sf != "":
				world_flags[sf] = true
			var sv := opt.get("set_variable", "")
			if sv != "":
				world_flags[sv] = opt.get("value", "")
			break
	complete_quest(quest_id, resolution)

func complete_quest(quest_id: String, resolution: String = "") -> void:
	"""Завершити квест без вибору (якщо немає resolution_choice)."""
	if not active_quests.has(quest_id):
		return
	# Зібрати флаги з sets_flags objectives
	var data := _quest_db.get(quest_id, {})
	for obj in data.get("objectives", []):
		for key in ["sets_flags", "set_flags"]:
			var flags = obj.get(key, [])
			if flags is String:
				world_flags[flags] = true
			elif flags is Array:
				for f in flags:
					world_flags[f] = true

	completed_quests.append(quest_id)
	active_quests.erase(quest_id)
	completed_objectives.erase(quest_id)
	quest_completed.emit(quest_id, resolution)
	print("Quest completed: ", quest_id, " resolution=", resolution)

	# Розблокувати наступні квести через leads_to
	var leads = _get_leads_to(data)
	for next_id in leads:
		if next_id in _quest_db:
			quest_available.emit(next_id)
			print("Quest available: ", next_id)

func get_quest_data(quest_id: String) -> Dictionary:
	return _quest_db.get(quest_id, {})

func get_active_quests() -> Array:
	var result: Array = []
	for q in active_quests.values():
		result.append(q)
	return result

func get_quest(quest_id: String) -> Quest:
	return active_quests.get(quest_id, null)

func is_quest_available(quest_id: String) -> bool:
	"""Чи доступний квест для запуску (пройдені передумови, ще не пройдений)."""
	if quest_id in completed_quests or quest_id in active_quests:
		return false
	return _check_prerequisites(quest_id)

func has_flag(flag_name: String) -> bool:
	return world_flags.get(flag_name, false) == true

func get_flag(flag_name: String):
	return world_flags.get(flag_name, null)

# --- Внутрішні ---

func _start_quest_internal(quest_id: String) -> void:
	var data := _quest_db[quest_id]
	var quest := Quest.new(data)
	active_quests[quest_id] = quest
	completed_objectives[quest_id] = []
	quest_started.emit(quest_id)
	print("Quest started: ", quest_id)

func _check_prerequisites(quest_id: String) -> bool:
	var data := _quest_db.get(quest_id, {})
	var pr := data.get("prerequisites", {})
	if not pr is Dictionary:
		return true
	# Перевірка quests_completed
	var qc: Array = pr.get("quests_completed", [])
	for qid in qc:
		if not qid in completed_quests:
			return false
	# Перевірка flag
	var flag: String = pr.get("flag", "")
	if flag != "" and not has_flag(flag):
		return false
	return true

func _check_quest_completion(quest_id: String) -> void:
	var data := _quest_db.get(quest_id, {})
	var cc := data.get("completion_conditions", {})
	var required: Array = cc.get("required_objectives", [])
	var done := completed_objectives.get(quest_id, [])
	for obj_id in required:
		if not obj_id in done:
			return  # ще не все виконано
	# Перевірка resolution_choice — якщо є, чекаємо resolve_quest()
	var rc := data.get("resolution_choice")
	if rc is Dictionary and rc.has("options"):
		return  # чекаємо явного виклику resolve_quest()
	complete_quest(quest_id)

func _get_leads_to(data: Dictionary) -> Array:
	var lt = data.get("leads_to")
	if lt is String:
		return [lt]
	if lt is Array:
		return lt
	return data.get("unlocks", [])

# --- Внутрішній клас Quest (для UI сумісності) ---

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

	class Objective:
		var id: String
		var description: String
		var type: String
		var target: String
		var is_completed: bool = false

		func _init(data: Dictionary):
			id = data.get("id", "")
			description = data.get("description", "")
			type = data.get("type", "talk")
			target = data.get("target", "")

# --- Збереження/завантаження ---
func save_data() -> Dictionary:
	return {
		"active_quests": active_quests.keys(),
		"completed_quests": completed_quests,
		"world_flags": world_flags,
		"completed_objectives": completed_objectives
	}

func load_data(save: Dictionary) -> void:
	completed_quests.clear()
	world_flags.clear()
	active_quests.clear()
	completed_objectives.clear()
	for qid in save.get("completed_quests", []):
		completed_quests.append(qid)
	world_flags = save.get("world_flags", {})
	# Рестартувати активні квести зі збереження
	for qid in save.get("active_quests", []):
		if _quest_db.has(qid):
			_start_quest_internal(qid)
	completed_objectives = save.get("completed_objectives", {})
