extends Node3D
## FerryQuestMechanics — hunger_from_below + salt_in_book + ferry_oath + quota_knife

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
	pass  # Grain convoy, Nera, Voss, Karos — NPC dialogues already exist

func _setup_salt() -> void:
	pass  # Fake seals, Brin Oss, Gara Paik, Tovan Rid — dialogues exist

func _setup_ferry_oath() -> void:
	pass  # Ferryman body, Tovan vs Nera, Kelm watch — dialogues exist

func _setup_quota() -> void:
	pass  # Kelm audit, sign or fight — dialogue exists

## Shared events
func nera_trusts() -> void:
	nera_trust += 1

func discover_grain_diversion() -> void:
	grain_found = true

func reveal_saboteur() -> void:
	saboteur_revealed = true
