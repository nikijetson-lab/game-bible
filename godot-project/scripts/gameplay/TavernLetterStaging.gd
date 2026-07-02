extends Node
## TavernLetterStaging — постановка інтро-сцени в таверні Ервана.
##
## Стартовий стан:
##   * Ерван протирає стійку — рушник (WipingTowel) у руці, їздить по стійці.
##   * Лист НЕ у Ервана і не висить у повітрі — він у вартового.
## Коли вартовий підходить / починається діалог:
##   * той самий рушник закидається на плече (ShoulderTowel),
##   * лист передається Ервану (HeldLetter),
##   * далі Ерван опускає руки з листом і ставить питання.

class_name TavernLetterStaging

signal guard_reached_handoff
signal letter_handed_to_ervan
signal towel_moved_to_shoulder
signal ervan_lowered_letter(question: String)

@export var guard_path: NodePath
@export var guard_start_marker_path: NodePath
@export var guard_handoff_marker_path: NodePath
@export var guard_letter_path: NodePath
@export var ervan_letter_path: NodePath
@export var ervan_letter_closeup_marker_path: NodePath

# Рушник: той самий предмет у двох станах — у руці (протирання) і на плечі.
@export var wiping_towel_path: NodePath
@export var shoulder_towel_path: NodePath
@export var wipe_travel: float = 0.55
@export var wipe_period: float = 1.4

@export var approach_duration: float = 1.8
@export var lowered_question: String = "Хто приніс це письмо — і чому на ньому немає адресата?"

var handoff_complete: bool = false
var _wipe_tween: Tween = null

func _ready() -> void:
	reset_to_scene_start()

func reset_to_scene_start() -> void:
	"""Початковий кадр: Ерван протирає стійку, лист у вартового."""
	handoff_complete = false
	_set_visible(ervan_letter_path, false)
	_set_visible(guard_letter_path, true)

	# Рушник — у руці, на стійці; плечовий варіант прихований.
	_set_visible(shoulder_towel_path, false)
	_set_visible(wiping_towel_path, true)
	_start_wiping()

	var guard := get_node_or_null(guard_path) as Node3D
	var start := get_node_or_null(guard_start_marker_path) as Node3D
	if guard != null and start != null:
		guard.global_transform = start.global_transform

func _start_wiping() -> void:
	"""Цикл протирання: рушник їздить туди-сюди по стійці."""
	var towel := get_node_or_null(wiping_towel_path) as Node3D
	if towel == null:
		return
	if _wipe_tween != null and _wipe_tween.is_valid():
		_wipe_tween.kill()
	var base_x: float = towel.position.x
	_wipe_tween = create_tween().set_loops()
	_wipe_tween.tween_property(towel, "position:x", base_x + wipe_travel, wipe_period).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_wipe_tween.tween_property(towel, "position:x", base_x, wipe_period).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _stop_wiping() -> void:
	if _wipe_tween != null and _wipe_tween.is_valid():
		_wipe_tween.kill()
	_wipe_tween = null

func throw_towel_over_shoulder() -> void:
	"""Початок діалогу: рушник з руки летить на плече (той самий предмет)."""
	_stop_wiping()
	_set_visible(wiping_towel_path, false)
	_set_visible(shoulder_towel_path, true)
	towel_moved_to_shoulder.emit()

func play_guard_handoff() -> void:
	"""Вартовий підходить до Ервана; на початку діалогу рушник іде на плече."""
	throw_towel_over_shoulder()
	var guard := get_node_or_null(guard_path) as Node3D
	var handoff := get_node_or_null(guard_handoff_marker_path) as Node3D
	if guard == null or handoff == null:
		complete_letter_handoff()
		return

	var tween := create_tween()
	tween.tween_property(guard, "global_transform", handoff.global_transform, approach_duration)
	tween.finished.connect(func() -> void:
		guard_reached_handoff.emit()
		complete_letter_handoff()
	)

func complete_letter_handoff() -> void:
	"""Момент у діалозі, де кадр може показати Ервана з листом у руках."""
	handoff_complete = true
	throw_towel_over_shoulder()
	_set_visible(guard_letter_path, false)
	_set_visible(ervan_letter_path, true)
	letter_handed_to_ervan.emit()

func lower_ervan_letter_and_ask() -> Dictionary:
	"""Ерван опускає руки з листом і ставить питання."""
	if not handoff_complete:
		complete_letter_handoff()
	var letter := get_node_or_null(ervan_letter_path) as Node3D
	if letter != null:
		letter.transform.origin.y = 0.44
		letter.transform.origin.z = 0.46
	ervan_lowered_letter.emit(lowered_question)
	return {
		"speaker": "ervan",
		"dialogue_id": "letter_handoff_question",
		"text": lowered_question,
		"letter_visible_on_ervan": true,
	}

func get_closeup_marker() -> Node3D:
	return get_node_or_null(ervan_letter_closeup_marker_path) as Node3D

func _set_visible(path: NodePath, is_visible: bool) -> void:
	var node := get_node_or_null(path)
	if node is Node3D:
		(node as Node3D).visible = is_visible
