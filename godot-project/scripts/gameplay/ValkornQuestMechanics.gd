extends Node3D
## ValkornQuestMechanics — man_from_swamp through keeper_of_first_seal (Episode 2)
##
## Зв'язано з QuestManager: кожна подія викликає complete_objective()
## або try_start_quest() для наступних квестів.

@export var quest_phase: String = "arrival"
@export var fipp_met: bool = false
@export var artifact_obtained: bool = false
@export var sebastian_revealed: bool = false
@export var first_seal_active: bool = false

func _ready() -> void:
	pass

func fipp_encounter() -> void:
	fipp_met = true
	Quests.complete_objective("valkorn_01_man_from_swamp", "fipp_market_encounter")

func meet_stetson() -> void:
	Quests.complete_objective("valkorn_01_man_from_swamp", "thread_stetson")

func meet_bres() -> void:
	Quests.complete_objective("valkorn_01_man_from_swamp", "thread_bres")

func meet_tessa(tone: String = "open") -> void:
	Quests.complete_objective("valkorn_01_man_from_swamp", "thread_tessa")

# Ep2 finale trigger
func reveal_sebastian() -> void:
	sebastian_revealed = true
	GameManager.set_flag("sebastian_revealed")
	Quests.complete_objective("valkorn_05_keeper_of_first_seal", "witness_reveal")

func iliya_recognizes() -> void:
	Quests.complete_objective("valkorn_05_keeper_of_first_seal", "iliya_recognition")

func iliya_accuses() -> void:
	Quests.complete_objective("valkorn_05_keeper_of_first_seal", "iliya_accuses")

func resolve_keeper(resolution: String) -> void:
	Quests.resolve_quest("valkorn_05_keeper_of_first_seal", resolution)

