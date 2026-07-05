extends Area3D
## WardenStake — interactable path marker in deep bog fog

@export var stake_index: int = 0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		var mechanics := get_tree().get_first_node_in_group("bog_mechanics")
		if mechanics and mechanics.has_method("find_stake"):
			mechanics.find_stake()
			queue_free()
