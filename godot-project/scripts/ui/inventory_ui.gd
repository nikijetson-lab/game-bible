extends Control
## InventoryPanel — UI для перегляду інвентаря (I key).
##
## Читає дані з InventoryManager (autoload "Inventory").
## Показує список предметів з кількістю.

func _ready() -> void:
	visible = false
	_build_ui()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_I:
		toggle()

func toggle() -> void:
	visible = not visible
	if visible: _refresh()

func _build_ui() -> void:
	var panel := PanelContainer.new()
	panel.size = Vector2(350, 350)
	panel.position = Vector2(20, 100)
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

	var title := Label.new(); title.text = "🎒 ІНВЕНТАР"
	title.add_theme_font_size_override("font_size", 20)
	title.add_theme_color_override("font_color", Color(0.9,0.7,0.3))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	_item_list = VBoxContainer.new()
	vbox.add_child(_item_list)

var _item_list: VBoxContainer

func _refresh() -> void:
	for c in _item_list.get_children(): c.queue_free()
	var inv := get_node_or_null("/root/Inventory")
	if not inv: return

	var items: Array = inv.get_items() if inv.has_method("get_items") else []
	if items.is_empty():
		_item_list.add_child(_make_label("(порожньо)", 13, Color(0.5,0.5,0.5)))
		return

	for item in items:
		var name: String = item.get("name", "?")
		var count: int = item.get("count", 1)
		var desc: String = item.get("description", "")
		var text := "%s ×%d" % [name, count]
		if not desc.is_empty(): text += " — " + desc
		_item_list.add_child(_make_label(text, 13, Color(0.7,1.0,0.7)))

func _make_label(text: String, size: int, color: Color) -> Label:
	var l := Label.new(); l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return l
