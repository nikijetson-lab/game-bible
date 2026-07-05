extends Node3D
## MadRiverMechanics — black churning river, chain ferry blocked by Muri, crossing event

@export var ferry_repaired: bool = false
@export var muri_attacks: int = 0
@export var max_muri_attacks: int = 3

var _player_on_ferry: bool = false
var _crossing: bool = false

func _ready() -> void:
	pass

## Called when player approaches the ferry dock
func approach_ferry() -> void:
	_show_event("river_01", "Річка не просто тече. Вона дихає. Чорна вода вирує проти течії — щось під поверхнею не хоче, щоб ти переправився.")

## Called when player attempts to cross
func attempt_cross() -> void:
	if not ferry_repaired:
		_show_text("Ланцюг розірваний. Пором не рухається. Потрібно полагодити.")
		return
	_crossing = true
	_show_event("river_02", "Пором здригається. Ланцюг стогне. З глибини — глухий удар. Потім ще один. Мурі б'ють у дно.")
	_trigger_muri_attack()

## Repair the chain ferry (called by player action)
func repair_ferry() -> void:
	ferry_repaired = true
	_show_text("Ланцюг закріплено. Пором готовий до переправи.")

func _trigger_muri_attack() -> void:
	muri_attacks += 1
	_show_text("З-під чорної води — удар. Пором нахиляється. Тримайся.")
	if muri_attacks >= max_muri_attacks:
		_crossing_complete()
	else:
		# More attacks coming
		await get_tree().create_timer(2.0).timeout
		if _crossing:
			_trigger_muri_attack()

func _crossing_complete() -> void:
	_crossing = false
	_show_text("Пором врізається в берег. Ти на іншому боці. Мурі затихли.")

func _show_event(id: String, text: String) -> void:
	_emit(id, text)

func _show_text(text: String) -> void:
	_emit("", text)

func _emit(id: String, text: String) -> void:
	if Events.has_signal("show_dialogue_line"):
		Events.emit_signal("show_dialogue_line", text, "river")
