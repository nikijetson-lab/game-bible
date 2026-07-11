extends Node3D
## FerryQuestMechanics — hunger_from_below + salt_in_book + ferry_oath + quota_knife
##
## Зв'язано з QuestManager: методи викликають complete_objective()
## та resolve_quest() для кожного квесту Sonk Ferry.

@export var quest_id: String = "hunger_from_below"
@export var nera_trust: int = 0
@export var grain_found: bool = false
@export var saboteur_revealed: bool = false

func _ready() -> void:
	match quest_id:
		"hunger": _setup_hunger()
		"salt": _setup_salt()
		"ferry_oath": _setup_ferry_oath()
		"quota": _setup_quota()

func _setup_hunger() -> void:
	pass

func _setup_salt() -> void:
	pass

func _setup_ferry_oath() -> void:
	pass

func _setup_quota() -> void:
	pass

# --- hunger_from_below ---
func meet_nera() -> void:
	nera_trust += 1
	Quests.complete_objective("sonk_ferry_01_hunger_from_below", "meet_nera")

func meet_voss() -> void:
	Quests.complete_objective("sonk_ferry_01_hunger_from_below", "meet_voss")

func inspect_board() -> void:
	Quests.complete_objective("sonk_ferry_01_hunger_from_below", "notice_board")

func find_convoy_books() -> void:
	Quests.complete_objective("sonk_ferry_01_hunger_from_below", "convoy_books")

func find_drag_marks() -> void:
	Quests.complete_objective("sonk_ferry_01_hunger_from_below", "drag_marks")

func enter_flooded_chamber() -> void:
	Quests.complete_objective("sonk_ferry_01_hunger_from_below", "enter_flooded_chamber")

func defeat_reed_wraiths() -> void:
	Quests.complete_objective("sonk_ferry_01_hunger_from_below", "defeat_reed_wraiths")

func resolve_hunger(outcome: String) -> void:
	Quests.resolve_quest("sonk_ferry_01_hunger_from_below", outcome)

# --- ferry_oath ---
func find_body() -> void:
	Quests.complete_objective("sonk_ferry_03_ferry_oath", "find_body")

func open_rift_choice(choice: String) -> void:
	Quests.complete_objective("sonk_ferry_03_ferry_oath", "open_rift_choice")

func night_council_start() -> void:
	Quests.complete_objective("sonk_ferry_03_ferry_oath", "night_council")

func resolve_ferry_oath(outcome: String) -> void:
	Quests.resolve_quest("sonk_ferry_03_ferry_oath", outcome)

# --- quota_knife ---
func enter_kelm_office() -> void:
	Quests.complete_objective("sonk_ferry_04_quota_knife", "enter_kelm_office")

func quota_first_choice(choice: String) -> void:
	Quests.complete_objective("sonk_ferry_04_quota_knife", "first_choice_quota")

func tribunal_start() -> void:
	Quests.complete_objective("sonk_ferry_04_quota_knife", "tribunal")

func resolve_quota(outcome: String) -> void:
	Quests.resolve_quest("sonk_ferry_04_quota_knife", outcome)
