extends Area3D
class_name InspectClue
## Interactable investigation clue. When examined it reports a canonical clue id
## back to the quest layer without hardcoding narrative spoilers in code.

@export var clue_id: String = ""
@export var quest_id: String = ""
@export_multiline var description: String = ""
@export var prompt: String = "Оглянути"

func _ready() -> void:
	add_to_group("interactable")

func get_interaction_prompt() -> String:
	return prompt

func can_interact(_actor: Node) -> bool:
	return true

func interact(_actor: Node) -> Dictionary:
	return {
		"type": "inspect_clue",
		"clue_id": clue_id,
		"quest_id": quest_id,
		"description": description,
	}
