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

# Системи
var quest_manager: Node
var reputation_manager: Node
var save_manager: Node

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
