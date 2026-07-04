extends Area3D
## SwampLessonTrigger — точка «моменту вибору» уроків болота (квест ep1-02).
## Кожен тригер = один епізод. Варіанти та їхні дельти беруться з експортованих
## масивів і мають ДОСЛІВНО відповідати тексту квесту ep1-02.
## Використовує той самий interact()-контракт, що NPC і портали.

@export var episode_id: String = ""
@export var episode_title: String = ""
@export var situation_text: String = ""
@export var option_texts: PackedStringArray = []
@export var option_deltas: PackedInt32Array = []
@export var aftermath_text: String = ""
@export var prompt: String = "Оцінити ситуацію"

var _consumed := false

func _ready() -> void:
	add_to_group("interactable")

func get_interaction_prompt() -> String:
	return prompt

func can_interact(_actor: Node) -> bool:
	return not _consumed

func interact(_actor: Node) -> void:
	if _consumed:
		return
	var ui := get_tree().get_first_node_in_group("swamp_lesson_ui")
	if ui != null and ui.has_method("show_lesson"):
		ui.show_lesson(self)
	else:
		# Fallback без UI: просто виводимо в консоль (headless/smoke).
		print("SWAMP_LESSON ", episode_id, ": ", situation_text)

func choose(option_index: int) -> void:
	"""Викликається UI після вибору гравця."""
	if _consumed:
		return
	if option_index < 0 or option_index >= option_deltas.size():
		return
	_consumed = true
	var delta := option_deltas[option_index]
	var track := get_node_or_null("/root/MiaTrust")
	if track != null and track.has_method("record_episode"):
		track.record_episode(episode_id, delta)
	if aftermath_text != "":
		print("MIA: ", aftermath_text)
