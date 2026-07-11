extends Node
## TimerManager — глобальні таймери квестів (Rein, Kelm, disturbance, tribunal).
##
## Відстежує ігрові дні, лічильники подій, і автоматично
## надсилає сигнали коли таймери спливають або пороги досягнуто.
class_name TimerManager

# Сигнали для квестових механік
signal day_passed(day: int)
signal rein_timer_expired
signal kelm_timer_expired
signal disturbance_threshold_reached(level: int)
signal tribunal_pressure_changed(pressure: float)

# ---- Rein Timer (hazemoor_02_ashes_under_chapel) ----
var rein_timer_active: bool = false
var rein_day: int = 0
var rein_max_days: int = 3          # день 4 = auto doctrinal_trial
var rein_auto_outcome: String = "G"  # auto G when timer expires

# ---- Kelm Timer (sonk_ferry_03_ferry_oath) ----
var kelm_timer_active: bool = false
var kelm_day: int = 0
var kelm_max_days: int = 4           # день 5 = auto G
var kelm_auto_outcome: String = "G"

# ---- Disturbance Counter (ashes_under_chapel) ----
var disturbance_active: bool = false
var disturbance_level: int = 0
var disturbance_max: int = 5
var disturbance_thresholds: Dictionary = {
	0: "quiet",
	3: "roots_grow_cold",
	4: "reflections_dont_match",
	5: "manifestation"
}

# ---- Tribunal Pressure (sonk_ferry_04_quota_knife) ----
var tribunal_pressure: float = 0.0

# ---- General game day ----
var current_day: int = 1

# ---- Quest integration ----
var _qm: Node

func _ready() -> void:
	_qm = get_node_or_null("/root/Quests")

# --- API ---

func start_rein_timer() -> void:
	rein_timer_active = true
	rein_day = 1
	print("TimerManager: Rein timer started (3 days)")

func start_kelm_timer() -> void:
	kelm_timer_active = true
	kelm_day = 1
	print("TimerManager: Kelm timer started (4 days)")

func start_disturbance_counter() -> void:
	disturbance_active = true
	disturbance_level = 0
	print("TimerManager: Disturbance counter started")

func add_disturbance(amount: int = 1) -> void:
	if not disturbance_active:
		return
	disturbance_level = min(disturbance_max, disturbance_level + amount)
	print("TimerManager: Disturbance = ", disturbance_level)
	# Check thresholds
	for level in disturbance_thresholds:
		if disturbance_level >= int(level):
			disturbance_threshold_reached.emit(int(level))

func advance_day() -> void:
	"""Перейти до наступного ігрового дня. Викликається з rest/sleep механіки."""
	current_day += 1
	day_passed.emit(current_day)

	# Rein timer
	if rein_timer_active:
		rein_day += 1
		if rein_day > rein_max_days:
			rein_timer_expired.emit()
			print("TimerManager: REIN TIMER EXPIRED — auto-outcome ", rein_auto_outcome)
			_auto_resolve_quest("hazemoor_02_ashes_under_chapel", rein_auto_outcome)

	# Kelm timer
	if kelm_timer_active:
		kelm_day += 1
		if kelm_day > kelm_max_days:
			kelm_timer_expired.emit()
			print("TimerManager: KELM TIMER EXPIRED — auto-outcome ", kelm_auto_outcome)
			_auto_resolve_quest("sonk_ferry_03_ferry_oath", kelm_auto_outcome)

	# Disturbance auto-increment (inactive = penalty)
	if disturbance_active:
		add_disturbance(1)

func add_tribunal_pressure(amount: float) -> void:
	tribunal_pressure += amount
	tribunal_pressure_changed.emit(tribunal_pressure)
	print("TimerManager: Tribunal pressure = ", tribunal_pressure)

# Player position formula (sonk_ferry_04)
func calculate_player_position(counter_evidence: int, faction_support: float, doctrine_bonus: float) -> float:
	return (counter_evidence * 2.0) + faction_support + doctrine_bonus - tribunal_pressure

func _auto_resolve_quest(quest_id: String, outcome: String) -> void:
	if _qm and _qm.has_method("resolve_quest"):
		if _qm.active_quests.has(quest_id):
			_qm.resolve_quest(quest_id, outcome)

func save_data() -> Dictionary:
	return {
		"current_day": current_day,
		"rein_timer_active": rein_timer_active,
		"rein_day": rein_day,
		"kelm_timer_active": kelm_timer_active,
		"kelm_day": kelm_day,
		"disturbance_level": disturbance_level,
		"tribunal_pressure": tribunal_pressure
	}

func load_data(data: Dictionary) -> void:
	current_day = data.get("current_day", 1)
	rein_timer_active = data.get("rein_timer_active", false)
	rein_day = data.get("rein_day", 0)
	kelm_timer_active = data.get("kelm_timer_active", false)
	kelm_day = data.get("kelm_day", 0)
	disturbance_level = data.get("disturbance_level", 0)
	tribunal_pressure = data.get("tribunal_pressure", 0.0)
