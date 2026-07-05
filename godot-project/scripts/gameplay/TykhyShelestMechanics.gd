extends Node3D
## TykhyShelestMechanics — threads: Rufin, Kaen, Mia, hero status

@export var rufin_found: bool = false
@export var mia_truth_known: bool = false
@export var mia_decision_made: bool = false
@export var kaen_met: bool = false

func _ready() -> void:
	pass

func find_rufin() -> void:
	rufin_found = true

func mia_learns_truth() -> void:
	mia_truth_known = true

func mia_decides() -> void:
	mia_decision_made = true
