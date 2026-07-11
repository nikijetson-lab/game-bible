extends Node
## CutsceneManager — керує scripted-сценами.
##
## Підтримує: fade in/out, camera movement, dialogue overlay,
## spawn VFX, trigger quest events. Кожна катсцена — іменована
## послідовність кроків, яку можна викликати за ID.
class_name CutsceneManager

signal cutscene_started(cutscene_id: String)
signal cutscene_step(step: int, total: int)
signal cutscene_ended(cutscene_id: String)

var _is_playing: bool = false
var _current_id: String = ""
var _steps: Array = []
var _step_index: int = 0

# Катсцени зареєстровані за ID
const SCENES := {
	# --- Ep1 ---
	"fipp_market_encounter": {
		"title": "Блазень на площі",
		"location": "valkorn_market_square",
		"steps": [
			{"type": "fade_in", "duration": 1.0},
			{"type": "camera_focus", "target": "fipp", "duration": 1.5},
			{"type": "dialogue", "speaker": "Фіпп", "text": "А ось і наш гість із болота! Який сюрприз."},
			{"type": "camera_focus", "target": "player", "duration": 1.0},
			{"type": "dialogue", "speaker": "Фіпп", "text": "Ти пахнеш торфом і... чимось стародавнім. Мені це подобається."},
			{"type": "quest_trigger", "quest_flag": "fipp_met"},
			{"type": "fade_out", "duration": 1.0}
		]
	},
	# --- Ep1 finale ---
	"mour_manifestation": {
		"title": "Маніфестація Моура",
		"location": "forbidden_glade",
		"steps": [
			{"type": "fade_in", "duration": 2.0},
			{"type": "vfx", "effect": "swarm_insects", "target": "glade_center", "duration": 3.0},
			{"type": "dialogue", "speaker": "Моур", "text": "..."},
			{"type": "vfx", "effect": "void_eyes", "target": "mour_head", "duration": 2.0},
			{"type": "dialogue", "speaker": "Моур", "text": "Його зробили з мене. Я пішов. Вони забрали шматок. Тепер він знову мій."},
			{"type": "camera_focus", "target": "artifact", "duration": 2.0},
			{"type": "fade_out", "duration": 2.0}
		]
	},
	"mia_revelation": {
		"title": "Міа дізнається",
		"location": "forbidden_glade",
		"steps": [
			{"type": "dialogue", "speaker": "Міа", "text": "Я думала, що чую болото краще за інших, тому що вчилась."},
			{"type": "pause", "duration": 1.5},
			{"type": "dialogue", "speaker": "Міа", "text": "Але я чула його тому, що воно — я."},
			{"type": "vfx", "effect": "mour_light", "target": "mia", "duration": 3.0},
			{"type": "quest_trigger", "quest_flag": "mia_knows_truth"},
			{"type": "fade_out", "duration": 2.0}
		]
	},
	# --- Ep2 finale ---
	"sebastian_reveal": {
		"title": "Фіпп змиває грим",
		"location": "black_archive",
		"steps": [
			{"type": "fade_in", "duration": 1.5},
			{"type": "camera_focus", "target": "fipp", "duration": 2.0},
			{"type": "vfx", "effect": "wash_makeup", "target": "fipp", "duration": 2.5},
			{"type": "dialogue", "speaker": "Себастьян Марр", "text": "Двадцять років я носив цю маску. Двадцять років чекав."},
			{"type": "camera_focus", "target": "ilia", "duration": 1.5},
			{"type": "dialogue", "speaker": "Ілія", "text": "Дядьку... Тебе немає двадцять років. Я думала ти мертвий."},
			{"type": "vfx", "effect": "mour_stone_glow", "target": "player", "duration": 2.0},
			{"type": "dialogue", "speaker": "Себастьян", "text": "Орден збудував дерев'яні стіни проти припливу. Болото не вмирає. Порожній Сезон змиє Валькорн."},
			{"type": "quest_trigger", "quest_flag": "sebastian_revealed"},
			{"type": "fade_out", "duration": 1.5}
		]
	},
	# --- Ep3 ---
	"ep3_verdict_iron": {
		"title": "Вердикт Заліза",
		"location": "flooded_sanctuary_crypt",
		"steps": [
			{"type": "vfx", "effect": "seal_insert", "target": "altar", "duration": 3.0},
			{"type": "dialogue", "speaker": "Лілея", "text": "Ми вбили душу цього місця."},
			{"type": "vfx", "effect": "swamp_dying", "duration": 4.0},
			{"type": "dialogue", "speaker": "Міа", "text": "Ти... ти знищив нас. (тікає)"},
			{"type": "dialogue", "speaker": "Ілія", "text": "Ти вижив. Повертайся додому."},
			{"type": "fade_out", "duration": 3.0}
		]
	},
	"ep3_verdict_reed": {
		"title": "Вердикт Очерету",
		"location": "flooded_sanctuary_crypt",
		"steps": [
			{"type": "vfx", "effect": "seal_dissolve", "target": "bog", "duration": 3.0},
			{"type": "vfx", "effect": "hero_transform_bark", "target": "player", "duration": 3.0},
			{"type": "dialogue", "speaker": "Міа", "text": "Ти вибрав нас. (торкається обличчя)"},
			{"type": "dialogue", "speaker": "Лілея", "text": "Ти більше не людина. (тікає до Грейфорда)"},
			{"type": "dialogue", "speaker": "Ілія", "text": "Я не відчуваю твого тепла... прощавай."},
			{"type": "vfx", "effect": "ilia_fade", "duration": 3.0},
			{"type": "fade_out", "duration": 3.0}
		]
	},
	"ep3_verdict_balance": {
		"title": "Пакт Ключника",
		"location": "flooded_sanctuary_crypt",
		"steps": [
			{"type": "vfx", "effect": "lileya_carve_runes", "target": "player", "duration": 4.0},
			{"type": "dialogue", "speaker": "Лілея", "text": "Мої предки пишалися б тобою."},
			{"type": "dialogue", "speaker": "Міа", "text": "Ти вибрав нести цей біль."},
			{"type": "dialogue", "speaker": "Ілія", "text": "Я залишаюсь із тобою... крізь статику."},
			{"type": "fade_out", "duration": 2.0}
		]
	},
	# --- Ep4 ---
	"ep4_ending_iron": {
		"title": "Суха дорога",
		"location": "hazemoor_valkorn_border",
		"steps": [
			{"type": "dialogue", "speaker": "Ілія", "text": "Ми залишаємо це залізо... Твій обов'язок згасає."},
			{"type": "vfx", "effect": "dry_road_grey_sky", "duration": 3.0},
			{"type": "fade_out", "duration": 4.0},
			{"type": "credits"}
		]
	},
	"ep4_ending_reed": {
		"title": "Квітуче болото",
		"location": "hazemoor_valkorn_border",
		"steps": [
			{"type": "vfx", "effect": "blooming_bog", "duration": 4.0},
			{"type": "fade_out", "duration": 4.0},
			{"type": "credits"}
		]
	},
	"ep4_ending_balance": {
		"title": "Туманний світанок",
		"location": "hazemoor_valkorn_border",
		"steps": [
			{"type": "vfx", "effect": "foggy_dawn", "duration": 4.0},
			{"type": "fade_out", "duration": 4.0},
			{"type": "credits"}
		]
	}
}

# --- API ---

func play(cutscene_id: String) -> bool:
	"""Запустити катсцену за ID. Повертає false якщо сцена не знайдена або вже грає."""
	if _is_playing:
		push_warning("Cutscene already playing: " + _current_id)
		return false
	if not SCENES.has(cutscene_id):
		push_error("Cutscene not found: " + cutscene_id)
		return false

	_is_playing = true
	_current_id = cutscene_id
	var scene := SCENES[cutscene_id]
	_steps = scene["steps"]
	_step_index = 0

	cutscene_started.emit(cutscene_id)
	print("Cutscene started: ", scene.get("title", cutscene_id))
	_advance()
	return true

func skip() -> void:
	"""Пропустити поточну катсцену."""
	if _is_playing:
		_end()

func _advance() -> void:
	if _step_index >= _steps.size():
		_end()
		return

	cutscene_step.emit(_step_index + 1, _steps.size())
	var step: Dictionary = _steps[_step_index]

	match step.get("type", ""):
		"fade_in", "fade_out", "pause":
			var duration := step.get("duration", 1.0)
			await get_tree().create_timer(duration).timeout
		"dialogue":
			var duration := step.get("duration", step.get("text", "").length() * 0.05 + 1.5)
			await get_tree().create_timer(duration).timeout
		"camera_focus", "vfx":
			var duration := step.get("duration", 1.5)
			await get_tree().create_timer(duration).timeout
		"quest_trigger":
			var qm := get_node_or_null("/root/Quests")
			if qm:
				var flag := step.get("quest_flag", "")
				if not flag.is_empty():
					GameManager.set_flag(flag)
		"credits":
			await get_tree().create_timer(3.0).timeout

	_step_index += 1
	_advance()

func _end() -> void:
	_is_playing = false
	var cid := _current_id
	_current_id = ""
	_steps.clear()
	cutscene_ended.emit(cid)
	print("Cutscene ended: ", cid)

func is_playing() -> bool:
	return _is_playing

func get_scene_list() -> Array:
	return SCENES.keys()
