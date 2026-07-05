extends Node3D
## FloodedAbbeyMechanics — black arches, Second Seal, hero weakens, final choice

@export var seal_activated: bool = false
@export var hero_weakened: bool = false

func _ready() -> void:
	pass

func enter_abbey() -> void:
	_show_event("abbey_01", "Ось вона. Обитель Ключників. Те, що лишилось.")

func approach_seal() -> void:
	if seal_activated: return
	_show_event("abbey_02", "Друга Печатка. Відчуваєш? Болотяна мідь. Гаряча, наче щойно з горна. Вона зрослася з плоттю землі.")
	hero_weakened = true
	await get_tree().create_timer(1.5).timeout
	_show_event("abbey_03", "Твоя шкіра... як вербова кора. Ти ледь дихаєш. Перша Печатка ледь тримає шепіт.")
	_trigger_ilia("ilia_abbey_01")

func activate_seal() -> void:
	seal_activated = true
	_show_event("abbey_04", "Це останній вибір. Доля Хейзмуру — тут. Не в моїх руках. У твоїх.")

func enter_gas_hazard() -> void:
	_trigger_ilia("ilia_abbey_02")

func _trigger_ilia(trigger_id: String) -> void:
	var path := "res://data/dialogues/deep_bog/flooded_abbey.json"
	if not FileAccess.file_exists(path): return
	var f := FileAccess.open(path, FileAccess.READ)
	var data := JSON.parse_string(f.get_as_text())
	if data == null: return
	for l in data.get("dialogues", {}).get("ilia_abbey", []):
		if l.get("trigger", "") == trigger_id:
			_emit(trigger_id, l.get("text", ""))
			return

func _show_event(id: String, text: String) -> void:
	_emit(id, text)

func _emit(id: String, text: String) -> void:
	if Events.has_signal("show_dialogue_line"):
		Events.emit_signal("show_dialogue_line", text, "abbey")
