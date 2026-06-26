extends Node3D
## Fog Controller - Динамічний туман для болотних локацій
## Створює рухомі хвилі туману, зони небезпеки, атмосферу Хейзмуру
## Автор: nikijetson-lab

class_name FogController

# Параметри туману
@export var fog_density: float = 0.5  # 0.0 to 1.0
@export var fog_speed: float = 0.2
@export var fog_wave_amplitude: float = 0.1
@export var fog_color: Color = Color(0.6, 0.65, 0.7, 1.0)  # Сіро-блакитний

# Небезпечні зони
@export var enable_danger_zones: bool = true
@export var danger_zone_color: Color = Color(0.4, 0.5, 0.3, 1.0)  # Зеленуватий

# Вузли
@onready var environment: WorldEnvironment = $WorldEnvironment
@onready var fog_zones: Node3D = $FogZones

# Внутрішній стан
var time_elapsed: float = 0.0
var base_fog_density: float = 0.5
var active_danger_zones: Array[Area3D] = []

func _ready() -> void:
	setup_volumetric_fog()
	setup_danger_zones()
	print("FogController initialized")

func _process(delta: float) -> void:
	time_elapsed += delta
	
	# Анімувати туман
	animate_fog_waves(delta)
	
	# Перевірити гравця в небезпечних зонах
	if enable_danger_zones:
		check_danger_zones()

func setup_volumetric_fog() -> void:
	"""Налаштувати volumetric fog"""
	if not environment or not environment.environment:
		push_error("WorldEnvironment not found!")
		return
	
	var env = environment.environment
	
	# Увімкнути volumetric fog
	env.volumetric_fog_enabled = true
	env.volumetric_fog_density = fog_density * 0.05
	env.volumetric_fog_albedo = fog_color
	env.volumetric_fog_emission_energy = 0.0
	env.volumetric_fog_gi_inject = 0.8
	env.volumetric_fog_anisotropy = 0.6
	env.volumetric_fog_length = 128.0
	env.volumetric_fog_detail_spread = 2.0
	
	# Ambient fog
	env.fog_enabled = true
	env.fog_light_color = fog_color
	env.fog_light_energy = 0.5
	env.fog_sun_scatter = 0.3
	env.fog_density = 0.01
	env.fog_aerial_perspective = 0.5
	
	print("Volumetric fog configured")

func animate_fog_waves(delta: float) -> void:
	"""Створити рухомі хвилі туману"""
	if not environment or not environment.environment:
		return
	
	var env = environment.environment
	
	# Синусоїдальні хвилі густини
	var wave = sin(time_elapsed * fog_speed * PI) * fog_wave_amplitude
	var current_density = base_fog_density + wave
	
	env.volumetric_fog_density = clamp(current_density * 0.05, 0.001, 0.1)

func set_fog_density(density: float) -> void:
	"""Встановити базову густину туману"""
	fog_density = clamp(density, 0.0, 1.0)
	base_fog_density = fog_density
	
	if environment and environment.environment:
		environment.environment.volumetric_fog_density = fog_density * 0.05

func set_fog_color(color: Color) -> void:
	"""Змінити колір туману"""
	fog_color = color
	
	if environment and environment.environment:
		environment.environment.volumetric_fog_albedo = color
		environment.environment.fog_light_color = color

# Небезпечні зони
func setup_danger_zones() -> void:
	"""Налаштувати зони де туман шкідливий"""
	if not fog_zones:
		return
	
	for child in fog_zones.get_children():
		if child is Area3D:
			var zone = child as Area3D
			zone.body_entered.connect(_on_danger_zone_entered.bind(zone))
			zone.body_exited.connect(_on_danger_zone_exited.bind(zone))
			active_danger_zones.append(zone)
	
	print("Danger zones setup: %d zones" % active_danger_zones.size())

func _on_danger_zone_entered(body: Node3D, zone: Area3D) -> void:
	"""Гравець увійшов у небезпечну зону"""
	if body.is_in_group("player"):
		print("Player entered danger zone: %s" % zone.name)
		# TODO: Застосувати DOT урон або ефекти
		apply_zone_effect(body, zone, true)

func _on_danger_zone_exited(body: Node3D, zone: Area3D) -> void:
	"""Гравець вийшов з небезпечної зони"""
	if body.is_in_group("player"):
		print("Player exited danger zone: %s" % zone.name)
		apply_zone_effect(body, zone, false)

func apply_zone_effect(player: Node3D, zone: Area3D, entering: bool) -> void:
	"""Застосувати ефект небезпечної зони"""
	if not player.has_node("HealthComponent"):
		return
	
	var health = player.get_node("HealthComponent")
	
	if entering:
		# Додати статус-ефект "Toxic Fog"
		health.add_status_effect("poison", 999.0, {"dps": 3.0})
		
		# Візуальний ефект (зеленуватий туман)
		tint_fog_in_zone(zone, danger_zone_color)
	else:
		# Видалити ефект
		health.remove_status_effect("poison")
		
		# Повернути нормальний колір
		tint_fog_in_zone(zone, fog_color)

func tint_fog_in_zone(zone: Area3D, color: Color) -> void:
	"""Підфарбувати туман у зоні (візуально)"""
	# TODO: Локальний fog override через FogVolume node
	pass

func check_danger_zones() -> void:
	"""Перевірити всі активні небезпечні зони"""
	# Cleanup або додаткова логіка
	pass

# Preset тумани для локацій
func apply_swamp_fog() -> void:
	"""Густий болотний туман (Хейзмур)"""
	set_fog_density(0.8)
	set_fog_color(Color(0.5, 0.55, 0.5, 1.0))  # Зеленувато-сірий
	fog_speed = 0.1

func apply_abbey_fog() -> void:
	"""Містичний туман (Затоплена Обитель)"""
	set_fog_density(0.95)
	set_fog_color(Color(0.4, 0.45, 0.55, 1.0))  # Темно-синій
	fog_speed = 0.05  # Дуже повільний

func apply_clearing_fog() -> void:
	"""Туман на Галявині Моура"""
	set_fog_density(0.7)
	set_fog_color(Color(0.9, 0.95, 1.0, 1.0))  # Білуватий
	fog_speed = 0.3

func apply_light_fog() -> void:
	"""Легкий туман (Грейфорд околиці)"""
	set_fog_density(0.3)
	set_fog_color(Color(0.7, 0.75, 0.8, 1.0))  # Світло-сірий
	fog_speed = 0.4

# Спеціальні ефекти
func create_fog_pulse(origin: Vector3, radius: float, duration: float) -> void:
	"""Створити імпульс туману (магічний ефект)"""
	# TODO: Temporary FogVolume at origin
	print("Fog pulse at %s, radius %.1f" % [origin, radius])

func clear_fog_area(origin: Vector3, radius: float, duration: float) -> void:
	"""Очистити область від туману (світло ліхтаря)"""
	# TODO: Negative fog influence
	print("Clearing fog at %s, radius %.1f" % [origin, radius])
