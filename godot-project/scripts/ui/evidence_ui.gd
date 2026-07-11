extends Control
## EvidencePanel — UI для перегляду зібраних доказів/ключів.
##
## Відкривається клавішею E. Показує завершені objectives
## типу "investigate", "inspect", "observe" з усіх активних квестів.
## Темна parchment-панель, як quest journal.

func _ready() -> void:
	visible = false
	_build_ui()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_E:
		toggle()

func toggle() -> void:
	visible = not visible
	if visible: _refresh()

func _build_ui() -> void:
	var panel := PanelContainer.new()
	panel.size = Vector2(400, 400)
	panel.position = Vector2(640, 20)
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.05, 0.05, 0.08, 0.92)
	style.set_corner_radius_all(8)
	style.border_color = Color(0.3, 0.25, 0.15)
	style.set_border_width_all(1)
	panel.add_theme_stylebox_override("panel", style)
	add_child(panel)

	var scroll := ScrollContainer.new()
	panel.add_child(scroll)
	var vbox := VBoxContainer.new()
	scroll.add_child(vbox)

	_title(vbox, "🔍 ДОКАЗИ ТА КЛЮЧІ")

	vbox.add_child(_label("", 18, Color(0.9,0.7,0.3)))
	_evidence_list = VBoxContainer.new()
	vbox.add_child(_evidence_list)

func _title(parent: Control, text: String) -> void:
	var l := Label.new(); l.text = text
	l.add_theme_font_size_override("font_size", 20)
	l.add_theme_color_override("font_color", Color(0.9,0.7,0.3))
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	parent.add_child(l)

func _label(text: String, size: int = 14, color := Color.WHITE) -> Label:
	var l := Label.new(); l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return l

var _evidence_list: VBoxContainer

func _refresh() -> void:
	for c in _evidence_list.get_children(): c.queue_free()
	var qm := get_node_or_null("/root/Quests")
	if not qm: return

	var total := 0
	for qid in qm.active_quests:
		var done := qm.completed_objectives.get(qid, [])
		var qdata: Dictionary = qm.get_quest_data(qid)
		for obj in qdata.get("objectives", []):
			var otype: String = obj.get("type", "")
			if otype in ["investigate", "inspect", "observe"] and obj.get("id", "") in done:
				var entry := _label("✓ " + obj.get("description", "?"), 13, Color(0.5, 1.0, 0.5))
				_evidence_list.add_child(entry)
				total += 1

	if total == 0:
		_evidence_list.add_child(_label("(ще немає доказів)", 13, Color(0.5,0.5,0.5)))
