extends Node
## BoloWeaving — система маніпуляції еманаціями болота.
##
## Розблоковується вердиктом V_lantern в Ep3 (valkorn_05).
## Коштує stamina + завдає pain. Посилюється вердиктом B_reed.
## Заблокована назавжди вердиктом A_iron.
class_name BoloWeaving

# Стан
enum State { LOCKED, UNLOCKED, ENHANCED }  # A_iron=LOCKED, V=UNLOCKED, B_reed=ENHANCED
var state: State = State.LOCKED

# Ресурси
var stamina: float = 100.0
var max_stamina: float = 100.0
var stamina_regen: float = 5.0        # per second
var pain_level: float = 0.0           # 0-100, cumulative
var pain_threshold: float = 70.0      # Ilia begs to stop above this

# Вартість здібностей
var root_part_cost: float = 20.0       # stamina cost to part roots
var root_part_pain: float = 8.0        # pain inflicted
var fog_navigate_cost: float = 15.0
var fog_navigate_pain: float = 5.0
var mour_sense_cost: float = 10.0
var mour_sense_pain: float = 3.0
var seal_resonance_cost: float = 30.0  # late-game ability
var seal_resonance_pain: float = 12.0

# Бонуси від Enhanced стану
var enhanced_cost_mult: float = 0.5    # half cost when enhanced
var enhanced_pain_mult: float = 0.3

signal stamina_changed(current: float, max_stam: float)
signal pain_changed(level: float)
signal ilia_warns
signal ilia_begs_to_stop
signal ability_used(ability: String)

func _ready() -> void:
	print("BoloWeaving initialized — ", State.keys()[state])

func _process(delta: float) -> void:
	if state != State.LOCKED and stamina < max_stamina:
		stamina = min(max_stamina, stamina + stamina_regen * delta)
		stamina_changed.emit(stamina, max_stamina)

# --- Unlock / progression ---

func unlock() -> void:
	"""Розблокувати через вердикт V_lantern."""
	if state == State.LOCKED:
		state = State.UNLOCKED
		print("BoloWeaving UNLOCKED")

func enhance() -> void:
	"""Підсилити через вердикт B_reed."""
	if state == State.UNLOCKED:
		state = State.ENHANCED
		print("BoloWeaving ENHANCED — no penalties")

func lock_forever() -> void:
	"""Заблокувати назавжди через вердикт A_iron."""
	state = State.LOCKED
	stamina = 0.0
	print("BoloWeaving LOCKED FOREVER")

# --- Abilities ---

func part_roots() -> bool:
	"""Bolo-Weaving: розсунути чорне коріння. Повертає true якщо вдало."""
	if state == State.LOCKED:
		return false
	var cost := root_part_cost * (enhanced_cost_mult if state == State.ENHANCED else 1.0)
	var pain := root_part_pain * (enhanced_pain_mult if state == State.ENHANCED else 1.0)
	if stamina < cost:
		return false
	stamina -= cost
	_add_pain(pain)
	ability_used.emit("part_roots")
	print("BoloWeaving: roots parted (stamina -%.0f, pain +%.0f)" % [cost, pain])
	return true

func navigate_fog() -> bool:
	"""Знайти шлях у густому тумані."""
	if state == State.LOCKED:
		return false
	var cost := fog_navigate_cost * (enhanced_cost_mult if state == State.ENHANCED else 1.0)
	var pain := fog_navigate_pain * (enhanced_pain_mult if state == State.ENHANCED else 1.0)
	if stamina < cost:
		return false
	stamina -= cost
	_add_pain(pain)
	ability_used.emit("navigate_fog")
	return true

func sense_mour() -> bool:
	"""Відчути напрямок до Моура (пасивний радар)."""
	if state == State.LOCKED:
		return false
	var cost := mour_sense_cost * (enhanced_cost_mult if state == State.ENHANCED else 1.0)
	var pain := mour_sense_pain * (enhanced_pain_mult if state == State.ENHANCED else 1.0)
	if stamina < cost:
		return false
	stamina -= cost
	_add_pain(pain)
	ability_used.emit("sense_mour")
	return true

func seal_resonance() -> bool:
	"""Використати резонанс Печаток (late-game)."""
	if state != State.ENHANCED:
		return false
	var cost := seal_resonance_cost
	var pain := seal_resonance_pain
	if stamina < cost:
		return false
	stamina -= cost
	_add_pain(pain)
	ability_used.emit("seal_resonance")
	print("BoloWeaving: Seal resonance activated")
	return true

# --- Internal ---

func _add_pain(amount: float) -> void:
	pain_level = min(100.0, pain_level + amount)
	pain_changed.emit(pain_level)
	if pain_level > pain_threshold * 0.5 and not _warned_half:
		_warned_half = true
		ilia_warns.emit()
	if pain_level >= pain_threshold and not _begged:
		_begged = true
		ilia_begs_to_stop.emit()

var _warned_half: bool = false
var _begged: bool = false

func get_stamina_percent() -> float:
	return stamina / max_stamina if max_stamina > 0 else 0.0

func is_locked() -> bool:
	return state == State.LOCKED

func save_data() -> Dictionary:
	return {
		"state": state,
		"stamina": stamina,
		"pain_level": pain_level
	}

func load_data(data: Dictionary) -> void:
	state = data.get("state", State.LOCKED)
	stamina = data.get("stamina", max_stamina)
	pain_level = data.get("pain_level", 0.0)
