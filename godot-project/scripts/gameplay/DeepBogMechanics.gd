extends Node3D
## DeepBogMechanics — fog whispers, Ilia voice, sanity drain, Warden stakes, bolo weaving

@export var sanity: float = 100.0
@export var sanity_drain_rate: float = 2.0  # per second in deep fog
@export var whisper_interval: float = 8.0
@export var stakes_found: int = 0
@export var stakes_required: int = 5

var _whisper_timer: float = 0.0
var _whispers: Array[Dictionary] = []
var _ilia_lines: Array[Dictionary] = []
var _phase: String = "return_to_mist"  # return_to_mist → breakthrough → scarred_path
var _fog_density: float = 0.035
var _in_deep_fog: bool = true
var _bolo_used: bool = false

@onready var _env: WorldEnvironment = $WorldEnvironment
@onready var _ilia_audio: AudioStreamPlayer = $IliaVoice
@onready var _whisper_audio: AudioStreamPlayer = $FogWhispers

func _ready() -> void:
	_load_dialogues()
	_show_opening()

func _load_dialogues() -> void:
	var path: String = "res://data/dialogues/deep_bog/voice_from_fog.json"
	if not FileAccess.file_exists(path):
		return
	var f: FileAccess = FileAccess.open(path, FileAccess.READ)
	var data: Variant = JSON.parse_string(f.get_as_text())
	if data == null: return
	
	var d: Dictionary = data.get("dialogues", {})
	for w in d.get("fog_whispers", []):
		_whispers.append(w)
	for l in d.get("ilia_voice", []):
		_ilia_lines.append(l)

func _show_opening() -> void:
	_trigger_hero_thought("hero_01")  # Вхід у туман

func _process(delta: float) -> void:
	if _phase == "return_to_mist" and _in_deep_fog:
		sanity -= sanity_drain_rate * delta
		_whisper_timer += delta
		if _whisper_timer >= whisper_interval:
			_whisper_timer = 0.0
			_play_random_whisper()
		if sanity <= 30.0:
			_trigger_ilia("ilia_02")  # "Згадай своє ім'я"
		if sanity <= 0:
			sanity = 0
			_game_over_fog()

func _play_random_whisper() -> void:
	if _whispers.is_empty(): return
	var w: Dictionary = _whispers[randi() % _whispers.size()]
	_show_text(w.get("text", ""), "fog")

func _trigger_ilia(trigger_id: String) -> void:
	for l in _ilia_lines:
		if l.get("trigger", "") == trigger_id:
			_show_text(l.get("text", ""), "ilia")
			return

func _trigger_hero_thought(id: String) -> void:
	var path_h: String = "res://data/dialogues/deep_bog/voice_from_fog.json"
	if not FileAccess.file_exists(path_h): return
	var f_h: FileAccess = FileAccess.open(path_h, FileAccess.READ)
	var data_h: Variant = JSON.parse_string(f_h.get_as_text())
	if data_h == null: return
	for h in data_h.get("dialogues", {}).get("hero_internal", []):
		if h.get("trigger", "") == id:
			_show_text(h.get("text", ""), "hero")
			return

func _show_text(text: String, speaker: String) -> void:
	# Signal to UI layer — print fallback until Events autoload is wired
	print("[%s] %s" % [speaker, text])

func _game_over_fog() -> void:
	_show_text("Туман поглинає тебе. Ти більше не пам'ятаєш свого імені.", "system")

## Called when player finds a Warden stake
func find_stake() -> void:
	stakes_found += 1
	_trigger_ilia("ilia_03")
	if stakes_found >= stakes_required:
		_breakthrough()

func _breakthrough() -> void:
	_phase = "scarred_path"
	sanity = 100.0
	_in_deep_fog = false
	_trigger_ilia("ilia_04")  # "Печатка стримує їх"
	# Reduce fog density visually
	if _env and _env.environment:
		_env.environment.fog_density = 0.018
		_env.environment.volumetric_fog_density = 0.008

## Bolo Weaving — used at root web obstacles
func bolo_weave() -> void:
	if _bolo_used: return
	_bolo_used = true
	_trigger_ilia("ilia_05")  # "Ти рвеш себе"
	# Would trigger stamina drain + pain effect in full implementation

func enter_root_web() -> void:
	_trigger_hero_thought("hero_02")

func enter_peat_chasm() -> void:
	_trigger_hero_thought("hero_03")
