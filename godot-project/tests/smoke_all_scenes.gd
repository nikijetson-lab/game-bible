extends SceneTree

## smoke_all_scenes — trustworthy scene gate.
## Runs AFTER autoloads register (deferred), so Quests/GameManager/etc. exist
## when scenes instantiate. Any script compile error in an instanced scene is a FAIL.

var _scenes: Array = [
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
	# Defer to the first idle frame so autoload singletons are registered.
	call_deferred("_run")

func _run() -> void:
	var ok: int = 0
	var fail: int = 0
	for path in _scenes:
		var p: PackedScene = load(path)
		if p == null:
			push_error("FAIL LOAD: " + str(path))
			print("FAIL LOAD: " + str(path))
			fail += 1
			continue
		var inst: Node = p.instantiate()
		if inst == null:
			push_error("FAIL INST: " + str(path))
			print("FAIL INST: " + str(path))
			fail += 1
			continue
		# Add to tree so _ready() runs and any runtime script error surfaces.
		get_root().add_child(inst)
		print("OK: " + str(path))
		inst.queue_free()
		ok += 1
	print("SMOKE: " + str(ok) + " OK, " + str(fail) + " FAIL")
	quit(0 if fail == 0 else 1)
