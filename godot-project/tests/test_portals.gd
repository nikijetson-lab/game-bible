extends SceneTree

var _checks: Array = []

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	_test_scene("res://scenes/locations/greyford/GreyfordStreet.tscn")
	_test_scene("res://scenes/locations/greyford/TavernInterior.tscn")
	_test_scene("res://scenes/locations/greyford/RufinRoom.tscn")
	_test_scene("res://scenes/locations/greyford/CraftsmenQuarter.tscn")
	_test_scene("res://scenes/locations/greyford/PortTavernInterior.tscn")
	_test_scene("res://scenes/locations/greyford/GreyfordGate.tscn")
	_test_scene("res://scenes/locations/greyford/AlteyaHiddenRoom.tscn")
	_report()

func _test_scene(path: String) -> void:
	var p: PackedScene = load(path)
	if p == null:
		_checks.append("FAIL load: " + path)
		return
	var s: Node = p.instantiate()
	var portals_node: Node = s.get_node_or_null("Portals")
	if portals_node == null:
		_checks.append("WARN no Portals: " + path)
	else:
		var count := 0
		for c in portals_node.get_children():
			var dest = c.get("destination_scene")
			if c.has_method("interact") or dest != null:
				var dest_str := String(dest) if dest != null else ""
				var ok := ResourceLoader.exists(dest_str)
				_checks.append(("OK " if ok else "FAIL ") + path.get_file() + " -> " + dest_str.get_file())
				count += 1
		if count == 0:
			_checks.append("WARN empty Portals: " + path)
	s.queue_free()

func _report() -> void:
	var ok := 0
	var fail := 0
	for c in _checks:
		print(c)
		if c.begins_with("OK"):
			ok += 1
		elif c.begins_with("FAIL"):
			fail += 1
	print("PORTALS: " + str(ok) + " OK, " + str(fail) + " FAIL")
	quit(0 if fail == 0 else 1)
