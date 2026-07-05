extends Node3D
## ValkornQuestMechanics — man_from_swamp through keeper_of_first_seal (Episode 2)

@export var quest_phase: String = "arrival"
@export var fipp_met: bool = false
@export var artifact_obtained: bool = false
@export var sebastian_revealed: bool = false
@export var first_seal_active: bool = false

func _ready() -> void:
	pass

func fipp_encounter() -> void:
	fipp_met = true

func obtain_artifact() -> void:
	artifact_obtained = true

func reveal_sebastian() -> void:
	sebastian_revealed = true

func activate_first_seal() -> void:
	first_seal_active = true
