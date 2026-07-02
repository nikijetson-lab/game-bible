extends Area3D
class_name LocationPortal
## Interactable portal that moves the player from one Greyford location scene to
## another (or to a route placeholder). Uses the same interact() contract as NPCs
## so the existing player_controller interaction flow works unchanged.

@export var destination_scene: String = ""
@export var destination_location: String = ""
@export var prompt: String = "Перейти"

func _ready() -> void:
	add_to_group("interactable")

func get_interaction_prompt() -> String:
	return prompt

func can_interact(_actor: Node) -> bool:
	return true

func interact(_actor: Node) -> Dictionary:
	var result := {
		"type": "location_portal",
		"destination_scene": destination_scene,
		"destination_location": destination_location,
	}
	if destination_scene != "" and ResourceLoader.exists(destination_scene):
		var tree := get_tree()
		if tree != null:
			tree.change_scene_to_file(destination_scene)
			result["changed"] = true
	return result
