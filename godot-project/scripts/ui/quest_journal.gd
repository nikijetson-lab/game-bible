extends Control
## QuestJournal — UI для перегляду активних, доступних і завершених квестів.
##
## Підписується на сигнали QuestManager для авто-оновлення.
## Відкривається/закривається через toggle (клавіша J за замовчуванням).

@export var journal_key: Key = KEY_J

var _is_open: bool = false
var _qm: Node  # QuestManager
var _active_list: VBoxContainer
var _available_list: VBoxContainer
var _completed_list: VBoxContainer
var _panel: PanelContainer

func _ready() -> void:
	_qm = get_node_or_null("/root/Quests")
	_build_ui()
	_subscribe_signals()
	visible = false

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == journal_key:
		toggle()

func toggle() -> void:
	_is_open = not _is_open
	visible = _is_open
	if _is_open:
		_refresh()

func _build_ui() -> void:
	# Головний контейнер
	var panel: PanelContainer = PanelContainer.new()
	panel.name = "QuestPanel"
	panel.size = Vector2(600, 500)
	panel.position = Vector2(20, 20)
	# Темний напівпрозорий фон
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color(0.05, 0.05, 0.08, 0.92)
	style.set_corner_radius_all(8)
	style.set_border_width_all(1)
	style.border_color = Color(0.3, 0.25, 0.15, 1.0)
	panel.add_theme_stylebox_override("panel", style)
	add_child(panel)
	_panel = panel

	var scroll: ScrollContainer = ScrollContainer.new()
	scroll.name = "Scroll"
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	panel.add_child(scroll)

	var main_vbox: VBoxContainer = VBoxContainer.new()
	main_vbox.name = "MainVBox"
	scroll.add_child(main_vbox)

	# Заголовок
	var title: Variant = _make_label("📜 ЖУРНАЛ КВЕСТІВ", 24, Color(0.9, 0.7, 0.3))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	main_vbox.add_child(title)

	var sep1: HSeparator = HSeparator.new()
	main_vbox.add_child(sep1)

	# Активні квести
	main_vbox.add_child(_make_section_header("📍 АКТИВНІ"))
	_active_list = VBoxContainer.new()
	_active_list.name = "Active"
	main_vbox.add_child(_active_list)

	var sep2: HSeparator = HSeparator.new()
	main_vbox.add_child(sep2)

	# Доступні квести
	main_vbox.add_child(_make_section_header("🔓 ДОСТУПНІ"))
	_available_list = VBoxContainer.new()
	_available_list.name = "Available"
	main_vbox.add_child(_available_list)

	var sep3: HSeparator = HSeparator.new()
	main_vbox.add_child(sep3)

	# Завершені
	main_vbox.add_child(_make_section_header("✅ ЗАВЕРШЕНІ"))
	_completed_list = VBoxContainer.new()
	_completed_list.name = "Completed"
	main_vbox.add_child(_completed_list)

func _make_section_header(text: String) -> Label:
	return _make_label(text, 18, Color(0.85, 0.65, 0.3))

func _make_label(text: String, size: int = 14, color: Color = Color.WHITE) -> Label:
	var label: Label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return label

func _make_quest_entry(quest_id: String, objectives: Array, color: Color = Color.WHITE) -> VBoxContainer:
	var entry: VBoxContainer = VBoxContainer.new()
	entry.name = quest_id
	var qdata: Variant = _qm.get_quest_data(quest_id) if _qm else {}
	var title_text: Variant = qdata.get("title", quest_id)
	var loc: Variant = qdata.get("start_location", "?")

	var header: Variant = _make_label("▸ %s  [%s]" % [title_text, loc], 15, color)
	entry.add_child(header)

	for obj in objectives:
		var done_mark: Variant = "✓" if _qm and _qm.completed_objectives.get(quest_id, []).has(obj.get("id", "")) else "○"
		var desc: Variant = obj.get("description", "?")
		var obj_label: Variant = _make_label("   %s %s" % [done_mark, desc], 13, color.darkened(0.3))
		entry.add_child(obj_label)

	return entry

func _refresh() -> void:
	if not _qm:
		return
	# Очистити списки
	_clear_list(_active_list)
	_clear_list(_available_list)
	_clear_list(_completed_list)

	# Активні
	for qid in _qm.active_quests:
		var qdata: Dictionary = _qm.get_quest_data(qid)
		var objectives: Array = qdata.get("objectives", [])
		_active_list.add_child(_make_quest_entry(qid, objectives, Color(0.3, 1.0, 0.5)))

	# Доступні
	for qid in _qm._quest_db:
		if qid in _qm.active_quests or qid in _qm.completed_quests:
			continue
		if _qm.is_quest_available(qid):
			var qdata: Dictionary = _qm.get_quest_data(qid)
			var objectives: Array = qdata.get("objectives", [])
			_available_list.add_child(_make_quest_entry(qid, objectives, Color(0.7, 0.7, 1.0)))

	# Завершені
	for qid in _qm.completed_quests:
		var qdata: Dictionary = _qm.get_quest_data(qid)
		if qdata.is_empty():
			continue
		var entry: Variant = _make_label("▸ %s" % qdata.get("title", qid), 14, Color(0.5, 0.5, 0.5))
		_completed_list.add_child(entry)

func _clear_list(list: VBoxContainer) -> void:
	for child in list.get_children():
		child.queue_free()

func _subscribe_signals() -> void:
	if not _qm:
		return
	if _qm.has_signal("quest_started"):
		_qm.quest_started.connect(_on_quest_changed)
	if _qm.has_signal("quest_completed"):
		_qm.quest_completed.connect(_on_quest_changed)
	if _qm.has_signal("quest_updated"):
		_qm.quest_updated.connect(_on_quest_changed)

func _on_quest_changed(_qid: String = "") -> void:
	if _is_open:
		_refresh()


