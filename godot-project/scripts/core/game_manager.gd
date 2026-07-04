extends Node
## Game Manager - Singleton для управління грою
## Автор: nikijetson-lab
## Дата: 26.06.2026

signal game_paused
signal game_resumed
signal scene_changed(scene_path: String)

# Стан гри
var is_paused: bool = false
var current_scene: String = ""

# Глобальні флаги світу (пам'ять про вибори гравця)
var game_flags: Dictionary = {}

# Доктрина Вартового: "" (без доктрини) | "lantern" | "judge" | "mediator" | "scout"
# Канон: design/hero-progression.md — Ліхтар, Суддя, Посередник, Слідопит
var player_doctrine: String = ""

# Системи
var quest_manager: Node
var reputation_manager: Node
var save_manager: Node

signal flag_set(flag_name: String)

func set_flag(flag_name: String) -> void:
	"""Встановити глобальний флаг світу"""
	if flag_name.is_empty():
		return
	game_flags[flag_name] = true
	flag_set.emit(flag_name)
	print("Flag set: ", flag_name)

func has_flag(flag_name: String) -> bool:
	"""Перевірити глобальний флаг світу"""
	return game_flags.get(flag_name, false)

func set_doctrine(doctrine: String) -> void:
	"""Встановити доктрину Вартового (lantern/judge/mediator/scout)"""
	player_doctrine = doctrine
	print("Doctrine set: ", doctrine)

func _ready() -> void:
	# Ініціалізація при старті гри
	print("GameManager initialized")
	process_mode = Node.PROCESS_MODE_ALWAYS  # Працює навіть на паузі

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
