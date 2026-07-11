extends Node
## Game Manager — Singleton для управління грою
##
## Відповідає за: зміну сцен, глобальні флаги, доктрину,
## ініціалізацію QuestManager при старті, та авто-перехід
## після завершення квестів.
signal game_paused
signal game_resumed
signal scene_changed(scene_path: String)

# Стан гри
var is_paused: bool = false
var current_scene: String = ""

# Глобальні флаги світу (пам'ять про вибори гравця)
var game_flags: Dictionary = {}

# Доктрина Вартового: "" (без доктрини) | "lantern" | "judge" | "mediator" | "scout"
var player_doctrine: String = ""

# Реєстр сцен — ліниво створюється при першому зверненні
var _scene_registry = null

signal flag_set(flag_name: String)

func set_flag(flag_name: String) -> void:
	if flag_name.is_empty():
		return
	game_flags[flag_name] = true
	flag_set.emit(flag_name)
	print("Flag set: ", flag_name)

func has_flag(flag_name: String) -> bool:
	return game_flags.get(flag_name, false)

func set_doctrine(doctrine: String) -> void:
	player_doctrine = doctrine
	print("Doctrine set: ", doctrine)

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	print("GameManager initialized")

	# Завантажити всі квести в QuestManager
	var qm := _quest_manager()
	if qm and qm.has_method("load_all_quests"):
		qm.load_all_quests("res://data/quests")
		# Підписатись на завершення квестів — авто-перехід
		if qm.has_signal("quest_completed"):
			qm.quest_completed.connect(_on_quest_completed)
		if qm.has_signal("quest_available"):
			qm.quest_available.connect(_on_quest_available)

	# Завантажити першу сцену гри
	_try_start_opening_quest()

func _quest_manager():
	return get_node_or_null("/root/Quests")

func _scene_reg():
	if _scene_registry == null:
		var sr := load("res://scripts/core/scene_registry.gd").new()
		sr.name = "SceneRegistry"
		add_child(sr)
		_scene_registry = sr
	return _scene_registry

func _try_start_opening_quest() -> void:
	var qm := _quest_manager()
	if qm and qm.has_method("try_start_quest"):
		qm.try_start_quest("greyford_01_missing_recipient")

func _on_quest_completed(quest_id: String, _resolution: String) -> void:
	# Авто-перехід до наступної локації за leads_to
	var sr = _scene_reg()
	var route := sr.route_after_quest(quest_id)
	if not route.is_empty() and route != current_scene:
		print("GameManager: auto-travel after quest ", quest_id, " → ", route)
		change_scene(route)

func _on_quest_available(quest_id: String) -> void:
	# Спробувати авто-запустити наступний квест
	var qm := _quest_manager()
	if qm:
		qm.try_start_quest(quest_id)

func travel_to_location(location_id: String) -> void:
	"""Перейти до сцени за логічною назвою локації (з квесту)."""
	var sr := _scene_reg()
	var path := sr.scene_for(location_id)
	if path.is_empty():
		push_error("GameManager: unknown location: " + location_id)
		return
	change_scene(path)

func is_at_location(location_id: String) -> bool:
	"""Чи поточна сцена відповідає локації."""
	var sr := _scene_reg()
	var path := sr.scene_for(location_id)
	return current_scene == path

func pause_game() -> void:
	"""Поставити гру на паузу"""
	if is_paused:
		return
	
	is_paused = true
	get_tree().paused = true
	game_paused.emit()
	print("Game paused")

func resume_game() -> void:
	"""Зняти гру з паузи"""
	if not is_paused:
		return
	
	is_paused = false
	get_tree().paused = false
	game_resumed.emit()
	print("Game resumed")

func change_scene(scene_path: String) -> void:
	"""Змінити сцену"""
	var result = get_tree().change_scene_to_file(scene_path)
	if result == OK:
		current_scene = scene_path
		scene_changed.emit(scene_path)
		print("Scene changed to: ", scene_path)
	else:
		push_error("Failed to change scene to: " + scene_path)

func quit_game() -> void:
	"""Вийти з гри"""
	print("Quitting game...")
	get_tree().quit()
