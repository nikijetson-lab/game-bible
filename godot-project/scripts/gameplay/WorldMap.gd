extends Control
class_name WorldMap
## WorldMap UI — мапа світу з клікабельними регіонами.
## Відкривається клавішею M. Поверх ручної мапи — маркери локацій.

const MAP_MANAGER_PATH := "/root/MapManager"

@onready var map_texture: TextureRect = $MapBackground
@onready var region_buttons: Control = $RegionButtons
@onready var info_panel: Panel = $InfoPanel
@onready var info_name: Label = $InfoPanel/Name
@onready var info_desc: Label = $InfoPanel/Description
@onready var travel_button: Button = $InfoPanel/TravelButton
@onready var close_button: Button = $CloseButton

var map_manager: Node
var selected_region: String = ""
var region_markers: Dictionary = {}

# Debug: показувати всі регіони (true для тестування)
var debug_show_all: bool = true

func _ready() -> void:
	map_manager = get_node_or_null(MAP_MANAGER_PATH)

	info_panel.visible = false
	travel_button.visible = false
	travel_button.pressed.connect(_on_travel_pressed)
	close_button.pressed.connect(_on_close_pressed)

	if map_manager != null:
		map_manager.region_discovered.connect(_on_region_discovered)
		map_manager.region_entered.connect(_on_region_entered)

	# Чекаємо один кадр щоб текстура точно завантажилась
	await get_tree().process_frame
	_create_region_markers()
	_refresh_visibility()
	visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("open_map"):
		if visible:
			_close()
		else:
			_open()

func _open() -> void:
	visible = true
	_refresh_visibility()
	info_panel.visible = false
	selected_region = ""

func _close() -> void:
	visible = false
	info_panel.visible = false
	selected_region = ""

func _create_region_markers() -> void:
	"""Створює маркери-кнопки для регіонів"""
	var regions: Dictionary = {}
	if map_manager != null:
		regions = map_manager.world_data.get("regions", {})
	else:
		# Fallback: завантажуємо JSON напряму
		regions = _load_regions_direct()

	if regions.is_empty():
		push_error("WorldMap: no region data")
		return

	var icon_map := _get_icon_map()
	var map_size := map_texture.size
	if map_size.x < 10:
		map_size = Vector2(1408, 768)  # fallback to actual texture size

	for region_id in regions:
		var data: Dictionary = regions[region_id]
		var pos: Dictionary = data.get("map_position", {"x": 0.5, "y": 0.5})
		var icon_text: String = icon_map.get(data.get("icon", "castle"), "📍")
		var name: String = data.get("name", region_id)

		var btn := Button.new()
		btn.name = "Marker_" + region_id
		btn.text = icon_text
		btn.custom_minimum_size = Vector2(44, 44)
		btn.flat = true
		btn.tooltip_text = name

		# Позиція у відсотках від розміру TextureRect
		# TextureRect має відступи 40px з кожного боку
		var tex_rect := map_texture.get_rect()
		var tex_pos := Vector2(
			pos.x * tex_rect.size.x + tex_rect.position.x - 22,
			pos.y * tex_rect.size.y + tex_rect.position.y - 22
		)
		btn.position = tex_pos

		btn.pressed.connect(_on_region_clicked.bind(region_id))
		region_buttons.add_child(btn)
		region_markers[region_id] = btn

func _load_regions_direct() -> Dictionary:
	var file := FileAccess.open("res://data/world_map.json", FileAccess.READ)
	if file == null:
		return {}
	var text := file.get_as_text()
	file.close()
	var json := JSON.new()
	if json.parse(text) == OK:
		return json.data.get("regions", {})
	return {}

func _get_icon_map() -> Dictionary:
	if map_manager != null:
		return map_manager.world_data.get("icons", {})
	return {
		"castle": "🏰", "village": "🏘️", "swamp": "🌿",
		"stilt_village": "🏚️", "ruins": "💀", "chapel": "⛪",
		"magic_circle": "❓", "capital": "🏛️", "monastery": "📿"
	}

func _refresh_visibility() -> void:
	for region_id in region_markers:
		var btn: Button = region_markers[region_id]
		var discovered := true
		if map_manager != null and not debug_show_all:
			discovered = map_manager.is_region_discovered(region_id)
		btn.visible = discovered

		# Підсвітка поточного регіону
		if map_manager != null and region_id == map_manager.current_region:
			btn.modulate = Color(0.3, 1.0, 0.3, 1.0)  # Зелений
		elif discovered:
			btn.modulate = Color(1.0, 0.9, 0.5, 1.0)  # Золотистий
		else:
			btn.modulate = Color(1, 1, 1, 0.15)  # Майже невидимий

func _on_region_clicked(region_id: String) -> void:
	selected_region = region_id
	_update_info_panel()

func _update_info_panel() -> void:
	if selected_region == "":
		info_panel.visible = false
		travel_button.visible = false
		return

	var regions: Dictionary = {}
	if map_manager != null:
		regions = map_manager.world_data.get("regions", {})
	else:
		regions = _load_regions_direct()

	var data: Dictionary = regions.get(selected_region, {})
	info_name.text = data.get("name", selected_region)
	info_desc.text = data.get("description", "")

	# Кнопка подорожі
	var current := "greyford"
	if map_manager != null:
		current = map_manager.current_region

	if selected_region == current:
		travel_button.visible = false
	else:
		var conn := _get_connection(current, selected_region)
		if conn.is_empty():
			travel_button.visible = false
		else:
			var mins: int = conn.get("travel_time_minutes", 60)
			travel_button.text = "Подорож (%d хв)" % mins
			travel_button.tooltip_text = conn.get("description", "")
			travel_button.visible = true

	info_panel.visible = true

func _get_connection(from_id: String, to_id: String) -> Dictionary:
	var conns: Array = []
	if map_manager != null:
		conns = map_manager.world_data.get("connections", [])
	for c in conns:
		if c.get("from", "") == from_id and c.get("to", "") == to_id:
			return c
	return {}

func _on_travel_pressed() -> void:
	if selected_region == "":
		return
	if map_manager != null:
		map_manager.travel_to_region(selected_region)
	_close()

func _on_close_pressed() -> void:
	_close()

func _on_region_discovered(_region_id: String) -> void:
	_refresh_visibility()

func _on_region_entered(_region_id: String) -> void:
	_refresh_visibility()
