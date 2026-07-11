extends Node3D
# RiggedIdleLoop — програє першу доступну анімацію rigged GLB у циклі як «живий» idle.
# Використання: причепити до Meshy* Node3D, що є інстансом rigged GLB (skins=1).
# Не чіпає позицію/трансформ вузла — лише знаходить AnimationPlayer і запускає кліп.

@export var preferred: String = ""   # напр. "idle"; якщо порожньо — бере перший кліп
@export var loop_speed: float = 1.0

var _ap: AnimationPlayer = null

func _ready() -> void:
	call_deferred("_setup_animation")

func _setup_animation() -> void:
	_ap = _find_animation_player(self)
	if _ap == null:
		return
	var clip: String = _pick_clip()
	if clip.is_empty():
		return
	if _ap.has_animation(clip):
		var anim: Animation = _ap.get_animation(clip)
		if anim != null:
			anim.loop_mode = Animation.LOOP_LINEAR
	_ap.play(clip, -1, loop_speed)

func _find_animation_player(root: Node) -> AnimationPlayer:
	if root is AnimationPlayer:
		return root as AnimationPlayer
	for child: Node in root.get_children():
		var found: AnimationPlayer = _find_animation_player(child)
		if found != null:
			return found
	return null

func _pick_clip() -> String:
	if _ap == null:
		return ""
	if not preferred.is_empty():
		var needle: String = preferred.to_lower()
		for animation_name: StringName in _ap.get_animation_list():
			var candidate: String = String(animation_name)
			if candidate.to_lower().contains(needle):
				return candidate
	var list: PackedStringArray = _ap.get_animation_list()
	for animation_name: StringName in list:
		var c: String = String(animation_name)
		if c != "RESET":
			return c
	return ""
