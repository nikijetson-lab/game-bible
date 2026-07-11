extends SceneTree

var _results: Variant = []

func _init() -> void:
	# 1. Test scene loading
	_test_load("TavernInterior", "res://scenes/locations/greyford/TavernInterior.tscn")
	_test_load("RufinRoom", "res://scenes/locations/greyford/RufinRoom.tscn")
	_test_load("CraftsmenQuarter", "res://scenes/locations/greyford/CraftsmenQuarter.tscn")
	_test_load("PortTavernInterior", "res://scenes/locations/greyford/PortTavernInterior.tscn")
	_test_load("GreyfordGate", "res://scenes/locations/greyford/GreyfordGate.tscn")
	_test_load("AlteyaHiddenRoom", "res://scenes/locations/greyford/AlteyaHiddenRoom.tscn")
	_test_load("GreyfordStreet", "res://scenes/locations/greyford/GreyfordStreet.tscn")
	
	# 2. Test NPC presence in each scene
	_test_npcs("TavernInterior", "res://scenes/locations/greyford/TavernInterior.tscn", ["ervan", "greyford_guard_letter"])
	_test_npcs("CraftsmenQuarter", "res://scenes/locations/greyford/CraftsmenQuarter.tscn", ["woodcarver", "furrier"])
	_test_npcs("PortTavernInterior", "res://scenes/locations/greyford/PortTavernInterior.tscn", ["cassandra", "port_bartender"])
	_test_npcs("GreyfordGate", "res://scenes/locations/greyford/GreyfordGate.tscn", ["gate_sergeant"])
	_test_npcs("AlteyaHiddenRoom", "res://scenes/locations/greyford/AlteyaHiddenRoom.tscn", ["alteya"])
	
	# 3. Test portal navigation
	_test_portals("TavernInterior", "res://scenes/locations/greyford/TavernInterior.tscn", ["RufinRoom", "CraftsmenQuarter", "GreyfordStreet"])
	_test_portals("GreyfordStreet", "res://scenes/locations/greyford/GreyfordStreet.tscn", ["TavernInterior", "CraftsmenQuarter", "PortTavernInterior", "GreyfordGate"])
	_test_portals("PortTavernInterior", "res://scenes/locations/greyford/PortTavernInterior.tscn", ["CraftsmenQuarter", "GreyfordGate", "AlteyaHiddenRoom"])
	
	call_deferred("_report")

func _test_load(name: String, path: String) -> void:
	var p: PackedScene = load(path)
	if p == null: _results.append("❌ LOAD " + name); return
	var s: Node = p.instantiate()
	if s == null: _results.append("❌ INST " + name)
	else: _results.append("✅ " + name); s.queue_free()

func _test_npcs(scene: String, path: String, npc_ids: Array) -> void:
	var p: PackedScene = load(path)
	if p == null: return
	var s: Node = p.instantiate()
	var npcs_node: Node = s.get_node_or_null("NPCs")
	if npcs_node == null:
		_results.append("⚠️ " + scene + " no NPCs node")
		s.queue_free(); return
	for nid in npc_ids:
		var found: Variant = false
		for c in npcs_node.get_children():
			if c.get("npc_id") == nid:
				var has_glb: Variant = false
				for ch in c.get_children():
					if ch.name == "Model" and ch.get_child_count() > 0: has_glb = true
				_results.append("  NPC " + nid + (" ✅GLB" if has_glb else " ⬜capsule") + " in " + scene)
				found = true; break
		if not found:
			_results.append("  ❌ NPC " + nid + " MISSING in " + scene)
	s.queue_free()

func _test_portals(scene: String, path: String, expected_dests: Array) -> void:
	var p: PackedScene = load(path)
	if p == null: return
	var s: Node = p.instantiate()
	var portals_node: Node = s.get_node_or_null("Portals")
	if portals_node == null:
		_results.append("⚠️ " + scene + " no Portals")
		s.queue_free(); return
	for dest in expected_dests:
		var found: Variant = false
		for c in portals_node.get_children():
			var dest_path: String = c.get("destination_scene")
			if dest in dest_path:
				var exists: Variant = ResourceLoader.exists(dest_path)
				_results.append("  Portal → " + dest + (" ✅" if exists else " ❌MISSING"))
				found = true; break
		if not found:
			_results.append("  ❌ Portal → " + dest + " NOT FOUND")
	s.queue_free()

func _report() -> void:
	for r in _results: print(r)
	var ok: Variant = 0; var fail := 0
	for r in _results:
		if r.begins_with("❌"): fail += 1
		elif r.begins_with("✅"): ok += 1
	print("\nQUEST TEST: " + str(ok) + " OK, " + str(fail) + " FAIL, " + str(_results.size() - ok - fail) + " WARN")
	quit(0 if fail == 0 else 1)
