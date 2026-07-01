extends Node
## Audio Manager - Система управління аудіо
## Керує музикою, SFX, ambience, crossfades
## Автор: nikijetson-lab

class_name AudioManager

# Audio buses
const BUS_MASTER = "Master"
const BUS_MUSIC = "Music"
const BUS_SFX = "SFX"
const BUS_AMBIENCE = "Ambience"
const BUS_VOICE = "Voice"

# Players
var music_player: AudioStreamPlayer
var music_fade_player: AudioStreamPlayer  # Для crossfade
var ambience_players: Array[AudioStreamPlayer] = []
var sfx_players: Array[AudioStreamPlayer3D] = []

# Стан
var current_music_track: String = ""
var current_location_ambience: Dictionary = {}
var is_crossfading: bool = false

# Settings
var master_volume: float = 0.8
var music_volume: float = 0.7
var sfx_volume: float = 0.9
var ambience_volume: float = 0.8
var voice_volume: float = 1.0

func _ready() -> void:
	setup_audio_buses()
	create_audio_players()
	load_audio_settings()
	print("AudioManager initialized")

func setup_audio_buses() -> void:
	"""Налаштувати audio buses"""
	# Buses створюються в Project Settings > Audio
	# Тут тільки встановлюємо volume
	set_bus_volume(BUS_MASTER, linear_to_db(master_volume))
	set_bus_volume(BUS_MUSIC, linear_to_db(music_volume))
	set_bus_volume(BUS_SFX, linear_to_db(sfx_volume))
	set_bus_volume(BUS_AMBIENCE, linear_to_db(ambience_volume))
	set_bus_volume(BUS_VOICE, linear_to_db(voice_volume))

func create_audio_players() -> void:
	"""Створити audio players"""
	# Music players
	music_player = AudioStreamPlayer.new()
	music_player.bus = BUS_MUSIC
	add_child(music_player)
	
	music_fade_player = AudioStreamPlayer.new()
	music_fade_player.bus = BUS_MUSIC
	add_child(music_fade_player)
	
	# Ambience players pool (5 одночасних ambience loops)
	for i in range(5):
		var player = AudioStreamPlayer.new()
		player.bus = BUS_AMBIENCE
		add_child(player)
		ambience_players.append(player)

# Music
func play_music(track_path: String, volume_db: float = -20.0, crossfade_duration: float = 3.0) -> void:
	"""Програти музику з crossfade"""
	if current_music_track == track_path and music_player.playing:
		return  # Вже грає
	
	var stream = load(track_path)
	if not stream:
		push_error("Music track not found: " + track_path)
		return
	
	if music_player.playing and crossfade_duration > 0:
		# Crossfade
		crossfade_music(stream, volume_db, crossfade_duration)
	else:
		# Instant
		music_player.stream = stream
		music_player.volume_db = volume_db
		music_player.play()
	
	current_music_track = track_path
	print("Playing music: %s" % track_path)

func crossfade_music(new_stream: AudioStream, volume_db: float, duration: float) -> void:
	"""Crossfade між двома треками"""
	if is_crossfading:
		return
	
	is_crossfading = true
	
	# Новий трек починається на fade player
	music_fade_player.stream = new_stream
	music_fade_player.volume_db = volume_db - 40  # Починаємо тихо
	music_fade_player.play()
	
	# Tween для fade out старого та fade in нового
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(music_player, "volume_db", volume_db - 40, duration)
	tween.tween_property(music_fade_player, "volume_db", volume_db, duration)
	
	await tween.finished
	
	# Swap players
	music_player.stop()
	var temp_stream = music_fade_player.stream
	music_player.stream = temp_stream
	music_player.volume_db = volume_db
	music_player.play(music_fade_player.get_playback_position())
	music_fade_player.stop()
	
	is_crossfading = false

func stop_music(fade_duration: float = 2.0) -> void:
	"""Зупинити музику"""
	if fade_duration > 0:
		var tween = create_tween()
		tween.tween_property(music_player, "volume_db", -80, fade_duration)
		await tween.finished
	
	music_player.stop()
	current_music_track = ""

# Ambience
func play_location_ambience(location_id: String) -> void:
	"""Програти ambience для локації"""
	# TODO: Завантажити з ambience_database.json
	var ambience_file = load("res://data/audio/ambience_database.json")
	if not ambience_file:
		push_warning("Ambience database not found")
		return
	
	var data = JSON.parse_string(ambience_file.text) if ambience_file is Resource else {}
	
	# Знайти локацію
	for location in data.get("locations", []):
		if location["id"] == location_id:
			load_location_ambience(location)
			return
	
	push_warning("Location ambience not found: " + location_id)

func load_location_ambience(location_data: Dictionary) -> void:
	"""Завантажити ambience з даних локації"""
	# Зупинити поточний ambience
	stop_all_ambience()
	
	# Запустити loops
	var ambient_loops = location_data.get("ambient_loops", [])
	for i in range(min(ambient_loops.size(), ambience_players.size())):
		var loop_data = ambient_loops[i]
		var player = ambience_players[i]
		
		var stream = load(loop_data["sound"])
		if stream:
			player.stream = stream
			player.volume_db = loop_data.get("volume_db", -20)
			player.play()
	
	# Запустити музику локації
	var music_data = location_data.get("music", {})
	if music_data.has("track"):
		play_music(
			music_data["track"],
			music_data.get("volume_db", -20),
			music_data.get("crossfade_duration", 3.0)
		)
	
	current_location_ambience = location_data
	print("Location ambience loaded: %s" % location_data["name"])

func stop_all_ambience() -> void:
	"""Зупинити всі ambience loops"""
	for player in ambience_players:
		player.stop()

# SFX
func play_sfx(sound_path: String, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void:
	"""Програти звуковий ефект (2D)"""
	var stream = load(sound_path)
	if not stream:
		push_warning("SFX not found: " + sound_path)
		return
	
	# Знайти вільний player або створити новий
	var player = AudioStreamPlayer.new()
	player.bus = BUS_SFX
	player.stream = stream
	player.volume_db = volume_db
	player.pitch_scale = pitch_scale
	add_child(player)
	
	player.play()
	
	# Видалити після закінчення
	await player.finished
	player.queue_free()

func play_sfx_3d(sound_path: String, position: Vector3, volume_db: float = 0.0, max_distance: float = 50.0) -> void:
	"""Програти 3D звук у світі"""
	var stream = load(sound_path)
	if not stream:
		push_warning("SFX not found: " + sound_path)
		return
	
	var player = AudioStreamPlayer3D.new()
	player.bus = BUS_SFX
	player.stream = stream
	player.volume_db = volume_db
	player.max_distance = max_distance
	player.unit_size = 10.0
	player.attenuation_model = AudioStreamPlayer3D.ATTENUATION_INVERSE_DISTANCE
	
	# Додати до сцени
	get_tree().root.add_child(player)
	player.global_position = position
	player.play()
	
	# Видалити після закінчення
	await player.finished
	player.queue_free()

# Volume control
func set_bus_volume(bus_name: String, volume_db: float) -> void:
	"""Встановити гучність bus"""
	var bus_idx = AudioServer.get_bus_index(bus_name)
	if bus_idx >= 0:
		AudioServer.set_bus_volume_db(bus_idx, volume_db)

func set_master_volume(volume: float) -> void:
	"""Встановити головну гучність (0.0 to 1.0)"""
	master_volume = clamp(volume, 0.0, 1.0)
	set_bus_volume(BUS_MASTER, linear_to_db(master_volume))

func set_music_volume(volume: float) -> void:
	music_volume = clamp(volume, 0.0, 1.0)
	set_bus_volume(BUS_MUSIC, linear_to_db(music_volume))

func set_sfx_volume(volume: float) -> void:
	sfx_volume = clamp(volume, 0.0, 1.0)
	set_bus_volume(BUS_SFX, linear_to_db(sfx_volume))

func set_ambience_volume(volume: float) -> void:
	ambience_volume = clamp(volume, 0.0, 1.0)
	set_bus_volume(BUS_AMBIENCE, linear_to_db(ambience_volume))

func set_voice_volume(volume: float) -> void:
	voice_volume = clamp(volume, 0.0, 1.0)
	set_bus_volume(BUS_VOICE, linear_to_db(voice_volume))

# Save/Load settings
func save_audio_settings() -> void:
	"""Зберегти налаштування звуку"""
	var settings = {
		"master_volume": master_volume,
		"music_volume": music_volume,
		"sfx_volume": sfx_volume,
		"ambience_volume": ambience_volume,
		"voice_volume": voice_volume
	}
	# TODO: Save to file

func load_audio_settings() -> void:
	"""Завантажити налаштування звуку"""
	# TODO: Load from file
	pass
