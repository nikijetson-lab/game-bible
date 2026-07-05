extends Area3D
## RootWebObstacle — blocks path, requires bolo weaving or alternate route

@export var requires_bolo: bool = true

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		var mechanics := get_tree().get_first_node_in_group("bog_mechanics")
		if mechanics and mechanics.has_method("enter_root_web"):
			mechanics.enter_root_web()
		if requires_bolo and mechanics and mechanics.has_method("bolo_weave"):
			# Player must use bolo weaving to pass
			pass
