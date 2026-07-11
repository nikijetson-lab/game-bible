extends SceneTree

var _scenes: Variant = [
	"res://scenes/locations/greyford/TavernInterior.tscn",
	"res://scenes/locations/greyford/RufinRoom.tscn",
	"res://scenes/locations/greyford/CraftsmenQuarter.tscn",
	"res://scenes/locations/greyford/PortTavernInterior.tscn",
	"res://scenes/locations/greyford/GreyfordGate.tscn",
	"res://scenes/locations/greyford/AlteyaHiddenRoom.tscn",
	"res://scenes/locations/greyford/GreyfordStreet.tscn",
	"res://scenes/locations/sonk_ferry/SonkFerry.tscn",
	"res://scenes/locations/tykhy_shelist/TykhyShelist.tscn",
]

func _init() -> void:
	var ok: Variant = 0
	var fail: Variant = 0
	for path in _scenes:
		var p: PackedScene = load(path)
		if p == null:
			push_error("FAIL LOAD: " + path)
			fail += 1
		else:
			var inst: Node = p.instantiate()
			if inst == null:
				push_error("FAIL INST: " + path)
				fail += 1
			else:
				print("OK: " + path)
				inst.queue_free()
				ok += 1
	print("SMOKE: " + str(ok) + " OK, " + str(fail) + " FAIL")
	quit(0 if fail == 0 else 1)
