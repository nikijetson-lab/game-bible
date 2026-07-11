extends SceneTree

func _init() -> void:
	print("SMOKE TEST START")
	var scenes_to_test: Variant = [
		"res://scenes/locations/greyford/TavernInterior.tscn",
		"res://scenes/locations/hazemoor/SwampPath.tscn",
		"res://scenes/locations/sonk_ferry/SonkFerry.tscn",
		"res://scenes/locations/deep_bog/DeepBog.tscn",
		"res://scenes/locations/valkorn/PortQuarter.tscn",
		"res://scenes/locations/tykhy_shelist/ForbiddenGlade.tscn",
	]
	var ok: Variant = 0
	var fail: Variant = 0
	for path in scenes_to_test:
		var packed: Resource = load(path)
		if packed:
			var inst: Node = packed.instantiate()
			if inst:
				print("OK: " + path)
				inst.free()
				ok += 1
			else:
				printerr("INSTANTIATE FAIL: " + path)
				fail += 1
		else:
			printerr("LOAD FAIL: " + path)
			fail += 1
	print("SMOKE RESULT: " + str(ok) + " OK, " + str(fail) + " FAIL")
	quit(0 if fail == 0 else 1)
