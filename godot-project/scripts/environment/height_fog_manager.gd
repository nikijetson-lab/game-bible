class_name HeightFogManager
extends Node

## Singleton/autoload: керує висотною густиною туману.
## Не змінює WeatherManager, FogController чи існуючі core/ сценарії.
## Сам сканує активну сцену на FogVolume і регулює густину за висотою камери.

@export var base_density := 0.35
@export var falloff := 0.22
@export var albedo = Color(0.28, 0.31, 0.27)

var _volumes = []
var _shader: Shader = null
var _material_template: ShaderMaterial = null
var _weather = null
var _processing = false


func _ready() -> void:
	_setup()


func _process(delta: float) -> void:
	if not _processing:
		return
	_update_from_camera()


func exit_tree() -> void:
	_processing = false
	_volumes.clear()


func _setup() -> void:
	if _shader == null:
		_shader = preload("res://shaders/height_fog.gdshader")
		_material_template = ShaderMaterial.new()
		_material_template.shader = _shader
		_material_template.set_shader_parameter("fog_density", base_density)
		_material_template.set_shader_parameter("height_falloff", falloff)
		_material_template.set_shader_parameter("fog_albedo", albedo)

	if not _processing:
		_processing = true
		_scan_volumes()
		_try_link_weather()


func _on_scene_changed() -> void:
	_scan_volumes()


func _scan_volumes() -> void:
	_volumes.clear()
	var root = get_tree().current_scene
	if root == null:
		return
	_collect(root)


func _collect(node: Node) -> void:
	if node is FogVolume:
		if node.material == null:
			node.material = _material_template.duplicate()
		_volumes.append(node)
	for child in node.get_children():
		_collect(child)


func _update_from_camera() -> void:
	var camera = _find_camera()
	if camera == null:
		return
	var height = camera.global_position.y
	var density = base_density * exp(-falloff * height)
	density = clamp(density, 0.0, 1.0)
	for vol in _volumes:
		if vol.material is ShaderMaterial:
			vol.material.set_shader_parameter("fog_density", density)


func _find_camera() -> Camera3D:
	var viewport = get_viewport()
	return viewport.get_camera_3d() if viewport else null


func _try_link_weather() -> void:
	var weather = get_node_or_null("/root/WeatherManager")
	if weather == null:
		return
	if weather.has_signal("weather_changed"):
		weather.weather_changed.connect(_on_weather_changed)
		_weather = weather


func _on_weather_changed(old_weather: String, new_weather: String) -> void:
	if _weather == null:
		return
	var intensity = 0.5
	if _weather.has_method("get_weather_intensity"):
		intensity = _weather.weather_intensity
	_apply_preset_for(intensity, new_weather)


func _apply_preset_for(intensity: float, weather_name: String) -> void:
	var preset = _preset_for(weather_name, intensity)
	set_preset(preset["density"], preset["falloff"], preset["albedo"])


func _preset_for(weather_name: String, intensity: float) -> Dictionary:
	match weather_name:
		"FOG":
			return {"density": 0.55 * intensity, "falloff": 0.18, "albedo": Color(0.28, 0.31, 0.27)}
		"OVERCAST":
			return {"density": 0.28 * intensity, "falloff": 0.22, "albedo": Color(0.34, 0.37, 0.35)}
		"HEAVY_RAIN":
			return {"density": 0.42 * intensity, "falloff": 0.20, "albedo": Color(0.22, 0.24, 0.22)}
		"STORM":
			return {"density": 0.42 * intensity, "falloff": 0.20, "albedo": Color(0.22, 0.24, 0.22)}
		"CLEAR":
			return {"density": 0.15 * intensity, "falloff": 0.25, "albedo": Color(0.48, 0.5, 0.48)}
		_:
			return {"density": 0.35 * intensity, "falloff": 0.22, "albedo": Color(0.28, 0.31, 0.27)}


func set_preset(density: float, falloff_value: float, albedo_value: Color) -> void:
	base_density = density
	falloff = falloff_value
	albedo = albedo_value
	if _material_template is ShaderMaterial:
		_material_template.set_shader_parameter("fog_albedo", albedo_value)


func get_current_density() -> float:
	return base_density
