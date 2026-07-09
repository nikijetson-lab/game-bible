extends Node3D
## Freezes the auto-playing GLB walk animation on a chosen standing frame.
## Guard stands still (idle) instead of walking in place.
## Chosen frame: t=0.0 s (verified via render + vision A/B, 2026-07-09 —
## most upright / least stride-like of the walking clip).

const FREEZE_TIME := 0.0

func _ready() -> void:
	call_deferred("_apply")

func _apply() -> void:
	_freeze_anim(self)

func _freeze_anim(node: Node) -> void:
	for child in node.get_children():
		if child is AnimationPlayer:
			var player := child as AnimationPlayer
			var anims := player.get_animation_list()
			if anims.size() > 0:
				var anim_name := StringName(anims[0])
				player.play(anim_name)
				player.seek(FREEZE_TIME, true)
				player.pause()
			else:
				player.stop()
		_freeze_anim(child)
