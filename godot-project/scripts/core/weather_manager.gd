extends Node
## Weather Manager - Система погоди
## Керує дощем, туманом, вітром, атмосферними ефектами
## Автор: nikijetson-lab

class_name WeatherManager

# Сигнали
signal weather_changed(old_weather: String, new_weather: String)
signal weather_intensity_changed(intensity: float)

# Типи погоди
enum WeatherType {
	CLEAR,          # Ясно
	OVERCAST,       # Хмарно
	LIGHT_RAIN,     # Легкий дощ
	HEAVY_RAIN,     # Сильний дощ
	FOG,            # Туман
	STORM,          # Гроза
	SNOW            # Сніг (для зимових локацій)
}

# Поточний стан
var current_weather: WeatherType = WeatherType.OVERCAST
var weather_intensity: float = 0.5  # 0.0 to 1.0
var transition_duration: float = 5.0  # Тривалість переходу між погодами

# Вузли ефектів (підключаються в редакторі)
var rain_particles: GPUParticles3D
var fog_environment: WorldEnvironment
var wind_audio: AudioStreamPlayer

# Transition
var is_transitioning: bool = false
var transition_timer: float = 0.0
var target_weather: WeatherType
var target_intensity: float

func _ready() -> void:
	print("WeatherManager initialized")
	apply_weather_immediate(current_weather, weather_intensity)

func _process(delta: float) -> void:
	if is_transitioning:
		process_transition(delta)

# Встановити погоду миттєво
func set_weather_immediate(weather: WeatherType, intensity: float = 0.5) -> void:
	"""Миттєво змінити погоду без переходу"""
	apply_weather_immediate(weather, intensity)

# Встановити погоду з плавним переходом
func set_weather(weather: WeatherType, intensity: float = 0.5, duration: float = 5.0) -> void:
	"""Плавно змінити погоду"""
	if weather == current_weather and intensity == weather_intensity:
		return
	
	target_weather = weather
	target_intensity = intensity
	transition_duration = duration
	transition_timer = 0.0
	is_transitioning = true
	
	print("Weather transitioning to %s (intensity: %.2f) over %.1fs" % [
		WeatherType.keys()[weather],
		intensity,
		duration
	])

func process_transition(delta: float) -> void:
	"""Обробити плавний перехід погоди"""
	transition_timer += delta
	var t = clamp(transition_timer / transition_duration, 0.0, 1.0)
	
	# Інтерполяція інтенсивності
	var current_intensity = lerp(weather_intensity, target_intensity, t)
	
	# Застосувати проміжний стан
	if t >= 0.5 and current_weather != target_weather:
		current_weather = target_weather
		weather_changed.emit(WeatherType.keys()[current_weather], WeatherType.keys()[target_weather])
	
	apply_weather_values(current_weather, current_intensity)
	
	# Завершити перехід
	if t >= 1.0:
		weather_intensity = target_intensity
		is_transitioning = false
		print("Weather transition complete: %s" % WeatherType.keys()[current_weather])

func apply_weather_immediate(weather: WeatherType, intensity: float) -> void:
	"""Застосувати погоду миттєво"""
	var old_weather = WeatherType.keys()[current_weather]
	current_weather = weather
	weather_intensity = intensity
	
	apply_weather_values(weather, intensity)
	weather_changed.emit(old_weather, WeatherType.keys()[weather])

func apply_weather_values(weather: WeatherType, intensity: float) -> void:
	"""Застосувати параметри погоди до ефектів"""
	match weather:
		WeatherType.CLEAR:
			apply_clear(intensity)
		WeatherType.OVERCAST:
			apply_overcast(intensity)
		WeatherType.LIGHT_RAIN:
			apply_light_rain(intensity)
		WeatherType.HEAVY_RAIN:
			apply_heavy_rain(intensity)
		WeatherType.FOG:
			apply_fog(intensity)
		WeatherType.STORM:
			apply_storm(intensity)
		WeatherType.SNOW:
			apply_snow(intensity)

# Погодні стани
func apply_clear(intensity: float) -> void:
	"""Ясна погода"""
	set_rain_amount(0.0)
	set_fog_density(0.0)
	set_wind_strength(0.1 * intensity)
	set_ambient_light(1.0)

func apply_overcast(intensity: float) -> void:
	"""Хмарна погода (стандарт для Hazemoor)"""
	set_rain_amount(0.0)
	set_fog_density(0.3 * intensity)
	set_wind_strength(0.3 * intensity)
	set_ambient_light(0.7 - (0.2 * intensity))

func apply_light_rain(intensity: float) -> void:
	"""Легкий дощ"""
	set_rain_amount(0.4 * intensity)
	set_fog_density(0.4 * intensity)
	set_wind_strength(0.4 * intensity)
	set_ambient_light(0.6)

func apply_heavy_rain(intensity: float) -> void:
	"""Сильний дощ"""
	set_rain_amount(1.0 * intensity)
	set_fog_density(0.6 * intensity)
	set_wind_strength(0.7 * intensity)
	set_ambient_light(0.4)

func apply_fog(intensity: float) -> void:
	"""Густий туман (болотний)"""
	set_rain_amount(0.0)
	set_fog_density(0.9 * intensity)
	set_wind_strength(0.2 * intensity)
	set_ambient_light(0.5 - (0.3 * intensity))

func apply_storm(intensity: float) -> void:
	"""Гроза"""
	set_rain_amount(1.0)
	set_fog_density(0.5 * intensity)
	set_wind_strength(1.0 * intensity)
	set_ambient_light(0.3)
	# TODO: Lightning flashes

func apply_snow(intensity: float) -> void:
	"""Сніг"""
	set_rain_amount(0.0)  # Використати окремі snow particles
	set_fog_density(0.5 * intensity)
	set_wind_strength(0.6 * intensity)
	set_ambient_light(0.8)

# Налаштування ефектів
func set_rain_amount(amount: float) -> void:
	"""Встановити кількість дощу (0.0 to 1.0)"""
	if rain_particles:
		rain_particles.amount_ratio = amount
		rain_particles.emitting = amount > 0.0

func set_fog_density(density: float) -> void:
	"""Встановити густину туману (0.0 to 1.0)"""
	if fog_environment and fog_environment.environment:
		var env = fog_environment.environment
		# Volumetric Fog
		if env.volumetric_fog_enabled:
			env.volumetric_fog_density = lerp(0.001, 0.05, density)
			env.volumetric_fog_gi_inject = lerp(0.5, 1.0, density)

func set_wind_strength(strength: float) -> void:
	"""Встановити силу вітру (0.0 to 1.0)"""
	if wind_audio:
		wind_audio.volume_db = lerp(-40.0, -10.0, strength)
	
	# TODO: Affect foliage wind shader

func set_ambient_light(brightness: float) -> void:
	"""Встановити яскравість навколишнього світла (0.0 to 1.0)"""
	if fog_environment and fog_environment.environment:
		var env = fog_environment.environment
		# Змінити ambient light energy
		# env.ambient_light_energy = brightness

# Preset погоди для різних локацій
func apply_location_weather(location_name: String) -> void:
	"""Застосувати типову погоду для локації"""
	match location_name:
		"greyford":
			set_weather(WeatherType.OVERCAST, 0.6, 3.0)
		
		"hazemoor_swamp":
			set_weather(WeatherType.FOG, 0.8, 5.0)
		
		"valkorn":
			set_weather(WeatherType.LIGHT_RAIN, 0.4, 3.0)
		
		"sunken_abbey":
			set_weather(WeatherType.FOG, 1.0, 2.0)
		
		"moura_clearing":
			set_weather(WeatherType.FOG, 0.9, 4.0)
		
		_:
			set_weather(WeatherType.OVERCAST, 0.5, 3.0)

# Random погода (для dynamic world)
func set_random_weather() -> void:
	"""Випадкова погода (для живого світу)"""
	var random_weather = randi() % WeatherType.size()
	var random_intensity = randf_range(0.3, 0.9)
	set_weather(random_weather, random_intensity, randf_range(5.0, 10.0))

# Підключити ефекти (викликати з головної сцени)
func connect_effects(rain: GPUParticles3D, fog_env: WorldEnvironment, wind: AudioStreamPlayer) -> void:
	"""Підключити вузли ефектів"""
	rain_particles = rain
	fog_environment = fog_env
	wind_audio = wind
	print("Weather effects connected")
