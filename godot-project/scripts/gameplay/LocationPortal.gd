extends Area3D
class_name LocationPortal
## Interactable portal that moves the player from one Greyford location scene to
## another (or to a route placeholder). Uses the same interact() contract as NPCs
## so the existing player_controller interaction flow works unchanged.

@export var destination_scene: String = ""
@export var destination_location: String = ""
@export var prompt: String = "Перейти"
## Прихований вхід (напр. просторова завіса Алтеї): портал існує, але не є
## очевидним і не обов'язковий для проходження. Стає доступним лише після того,
## як гравець розпізнав відповідний слід (required_flag).
@export var is_hidden: bool = false
@export var optional: bool = false
@export var required_flag: String = ""

func _ready() -> void:
	add_to_group("interactable")
	if is_hidden:
		add_to_group("hidden_interactable")

func get_interaction_prompt() -> String:
	return prompt

func can_interact(_actor: Node) -> bool:
	if is_hidden and required_flag != "":
		var gm := get_node_or_null("/root/GameManager")
		if gm != null and gm.has_method("has_flag"):
			return gm.has_flag(required_flag)
	return true

func interact(_actor: Node) -> Dictionary:
	var result := {
		"type": "location_portal",
		"destination_scene": destination_scene,
		"destination_location": destination_location,
		"is_hidden": is_hidden,
		"optional": optional,
	}
	if destination_scene != "" and ResourceLoader.exists(destination_scene):
		var tree := get_tree()
		if tree != null:
			tree.change_scene_to_file(destination_scene)
			result["changed"] = true
	return result
