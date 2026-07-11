extends Node3D
## TykhyShelestMechanics — threads: Rufin, Kaen, Mia, hero status
##
## Зв'язано з QuestManager: методи викликають complete_objective()
## для відповідних квестових цілей.

@export var rufin_found: bool = false
@export var mia_truth_known: bool = false
@export var mia_decision_made: bool = false
@export var kaen_met: bool = false

func _ready() -> void:
	pass

func find_rufin() -> void:
	rufin_found = true
	GameManager.set_flag("hero_found_rufin")
	Quests.complete_objective("tykhy_shelest_01", "find_rufin")

func meet_kaen() -> void:
	kaen_met = true
	Quests.complete_objective("tykhy_shelest_01", "meet_kaen")

func learn_truth_from_kaen() -> void:
	GameManager.set_flag("hero_told_mia_truth")
	Quests.complete_objective("tykhy_shelest_01", "learn_truth")

func mia_finds_records() -> void:
	GameManager.set_flag("mia_found_records")
	Quests.complete_objective("tykhy_shelest_01", "mia_records")

func mia_decides() -> void:
	mia_decision_made = true
	GameManager.set_flag("mia_decided_to_join")
	# trigger_mia_talk → mia_decision → route_to_sonk_ferry
	Quests.complete_objective("tykhy_shelest_01", "trigger_mia_talk")
	await get_tree().create_timer(1.0).timeout
	Quests.complete_objective("tykhy_shelest_01", "mia_decision")
