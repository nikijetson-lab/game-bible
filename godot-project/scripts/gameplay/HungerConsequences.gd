extends RefCounted
## HungerConsequences — applies faction shifts and world changes
## after player chooses a resolution in "Голод знизу" (ep1-04).

const RESOLUTION_MATRIX: Dictionary = {
	"A": {
		"set_flag": "hunger_outcome_public_exposure",
		"faction_shifts": {
			"fortress_admin": -30,
			"keepers_st_vey": 15,
			"muri_ferrymen": 10,
			"smugglers_predatory": 10,
			"smugglers_survival": -5,
		},
	},
	"B": {
		"set_flag": "hunger_outcome_controlled_containment",
		"faction_shifts": {
			"fortress_admin": 25,
			"keepers_st_vey_strict": 10,
			"keepers_st_vey_merciful": -10,
			"muri_ferrymen": -5,
			"smugglers_predatory": -15,
			"smugglers_survival": 5,
		},
	},
	"C": {
		"set_flag": "hunger_outcome_local_deal",
		"faction_shifts": {
			"fortress_admin": -20,
			"keepers_st_vey_merciful": 10,
			"keepers_st_vey_strict": -15,
			"muri_ferrymen": 25,
			"smugglers_survival": 20,
			"smugglers_predatory": 10,
		},
	},
	"D": {
		"set_flag": "hunger_outcome_ritual_mercy",
		"faction_shifts": {
			"fortress_admin": -35,
			"keepers_st_vey_merciful": 30,
			"keepers_st_vey_strict": 15,
			"muri_ferrymen_spiritual": 15,
			"muri_ferrymen_hungry": -20,
			"smugglers": -10,
		},
	},
}

## Apply consequences for a given resolution key ("A", "B", "C", or "D").
static func apply(resolution_key: String) -> void:
	if not RESOLUTION_MATRIX.has(resolution_key):
		push_error("HungerConsequences: unknown resolution key: " + resolution_key)
		return

	var data: Dictionary = RESOLUTION_MATRIX[resolution_key]

	# Set global flag
	GameManager.set_flag(data["set_flag"])
	print("Hunger outcome: ", data["set_flag"])

	# Apply faction reputation shifts
	if GameManager.has_method("apply_faction_shifts"):
		GameManager.apply_faction_shifts(data["faction_shifts"])
	elif GameManager.reputation_manager:
		for faction: String in data["faction_shifts"]:
			var delta: int = data["faction_shifts"][faction]
			GameManager.reputation_manager.modify_reputation(faction, delta)
			print("  Reputation %s %+d" % [faction, delta])

	print("HungerConsequences applied: ", resolution_key)
