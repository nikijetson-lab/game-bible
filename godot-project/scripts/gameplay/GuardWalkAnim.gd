extends Node3D
## Stops auto-playing GLB walk animation. Guard stands still until movement is triggered.
## In editor: manually rotate LeftArm bone to bring it down to match RightArm.

func _ready() -> void:
	call_deferred("_apply")

func _apply() -> void:
	var parent_node: Node = get_parent()
	if parent_node == null:
		return
	_stop_anim(parent_node)

func _stop_anim(node: Node) -> void:
	for child in node.get_children():
		if child is AnimationPlayer:
			(child as AnimationPlayer).stop()
		_stop_anim(child)
