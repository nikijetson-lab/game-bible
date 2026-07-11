extends SceneTree

var _checks: Variant = []

func _init() -> void:
	_test_scene("res://scenes/locations/greyford/GreyfordStreet.tscn")
	_test_scene("res://scenes/locations/greyford/TavernInterior.tscn")
	_test_scene("res://scenes/locations/greyford/RufinRoom.tscn")
	_test_scene("res://scenes/locations/greyford/CraftsmenQuarter.tscn")
	_test_scene("res://scenes/locations/greyford/PortTavernInterior.tscn")
	_test_scene("res://scenes/locations/greyford/GreyfordGate.tscn")
	_test_scene("res://scenes/locations/greyford/AlteyaHiddenRoom.tscn")
	call_deferred("_report")

func _test_scene(path: String) -> void:
	var p: PackedScene = load(path)
	if p == null: _checks.append("FAIL load: " + path); return
	var s: Node = p.instantiate()
	var portals_node: Node = s.get_node_or_null("Portals")
	if portals_node == null:
		_checks.append("WARN no Portals: " + path)
	else:
		var count: Variant = 0
		for c in portals_node.get_children():
			if c.has_method("interact") or c.get("destination_scene") != null:
				var dest: String = c.get("destination_scene")
				var prompt: String = c.get("prompt")
				var valid: Variant = "✅" if ResourceLoader.exists(dest) else "❌ MISSING"
				_checks.append(valid + " " + path.get_file() + " → " + dest.get_file() + " [" + prompt + "]")
				count += 1
		if count == 0:
			_checks.append("WARN empty Portals: " + path)
	s.queue_free()

func _report() -> void:
	for c in _checks: print(c)
	var ok: Variant = 0; var fail := 0
	for c in _checks:
		if c.startswith("✅"): ok += 1
		elif c.startswith("❌"): fail += 1
	print("PORTALS: " + str(ok) + " OK, " + str(fail) + " FAIL")
	quit(0 if fail == 0 else 1)
