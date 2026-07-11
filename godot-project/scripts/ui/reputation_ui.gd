extends Control
## ReputationPanel — UI репутації та фракцій (R key).
##
## Читає дані з ReputationManager. Показує всі фракції
## з поточним значенням репутації та кольоровим індикатором.

func _ready() -> void:
	visible = false
	_build_ui()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_R:
		toggle()

func toggle() -> void:
	visible = not visible
	if visible: _refresh()

func _build_ui() -> void:
	var panel := PanelContainer.new()
	panel.size = Vector2(380, 380)
	panel.position = Vector2(670, 100)
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

	var title := Label.new(); title.text = "⚖️ РЕПУТАЦІЯ"
	title.add_theme_font_size_override("font_size", 20)
	title.add_theme_color_override("font_color", Color(0.9,0.7,0.3))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	_faction_list = VBoxContainer.new()
	vbox.add_child(_faction_list)

var _faction_list: VBoxContainer

func _refresh() -> void:
	for c in _faction_list.get_children(): c.queue_free()
	var rep := get_node_or_null("/root/Reputation")
	if not rep: return

	var factions: Dictionary = rep.get_all_reputations() if rep.has_method("get_all_reputations") else {}
	if factions.is_empty():
		_faction_list.add_child(_label("(немає даних)", 13, Color(0.5,0.5,0.5)))
		return

	var sorted := []
	for fid in factions:
		sorted.append({"id": fid, "val": int(factions[fid])})
	sorted.sort_custom(func(a, b): return a.val > b.val)

	for entry in sorted:
		var fid: String = entry.id
		var val: int = entry.val
		var color := Color.GREEN if val > 0 else (Color.RED if val < 0 else Color.WHITE)
		var text := "%s  %+d" % [fid.replace("_", " "), val]
		_faction_list.add_child(_label(text, 13, color))

func _label(text: String, size: int, color: Color) -> Label:
	var l := Label.new(); l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return l
