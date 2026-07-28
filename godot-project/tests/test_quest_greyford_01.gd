extends SceneTree

var _results: Array = []

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	# 1. Scene loading
	_test_load("TavernInterior", "res://scenes/locations/greyford/TavernInterior.tscn")
	_test_load("RufinRoom", "res://scenes/locations/greyford/RufinRoom.tscn")
	_test_load("CraftsmenQuarter", "res://scenes/locations/greyford/CraftsmenQuarter.tscn")
	_test_load("PortTavernInterior", "res://scenes/locations/greyford/PortTavernInterior.tscn")
	_test_load("GreyfordGate", "res://scenes/locations/greyford/GreyfordGate.tscn")
	_test_load("AlteyaHiddenRoom", "res://scenes/locations/greyford/AlteyaHiddenRoom.tscn")
	_test_load("GreyfordStreet", "res://scenes/locations/greyford/GreyfordStreet.tscn")

	# 2. NPC presence + credible (non-primitive) model. Primitive = FAIL, not WARN.
	_test_npcs("TavernInterior", "res://scenes/locations/greyford/TavernInterior.tscn", ["ervan", "greyford_guard_letter"])
	_test_npcs("CraftsmenQuarter", "res://scenes/locations/greyford/CraftsmenQuarter.tscn", ["woodcarver", "furrier"])
	_test_npcs("PortTavernInterior", "res://scenes/locations/greyford/PortTavernInterior.tscn", ["cassandra", "port_bartender"])
	_test_npcs("GreyfordGate", "res://scenes/locations/greyford/GreyfordGate.tscn", ["gate_sergeant"])
	_test_npcs("AlteyaHiddenRoom", "res://scenes/locations/greyford/AlteyaHiddenRoom.tscn", ["alteya"])

	# 3. Portal navigation
	_test_portals("TavernInterior", "res://scenes/locations/greyford/TavernInterior.tscn", ["RufinRoom", "CraftsmenQuarter", "GreyfordStreet"])
	_test_portals("GreyfordStreet", "res://scenes/locations/greyford/GreyfordStreet.tscn", ["TavernInterior", "CraftsmenQuarter", "PortTavernInterior", "GreyfordGate"])
	_test_portals("PortTavernInterior", "res://scenes/locations/greyford/PortTavernInterior.tscn", ["CraftsmenQuarter", "GreyfordGate", "AlteyaHiddenRoom"])

	await process_frame
	_report()

func _test_load(scene_name: String, path: String) -> void:
	var p: PackedScene = load(path)
	if p == null:
		_results.append("FAIL LOAD " + scene_name)
		return
	var s: Node = p.instantiate()
	if s == null:
		_results.append("FAIL INST " + scene_name)
	else:
		_results.append("OK " + scene_name)
		s.queue_free()

func _find_npc_by_id(node: Node, npc_id: String) -> Node:
	if node.get("npc_id") == npc_id:
		return node
	for c in node.get_children():
		var found := _find_npc_by_id(c, npc_id)
		if found != null:
			return found
	return null

## Recursively classify the geometry under an NPC node.
## Returns "glb" (credible imported mesh), "primitive" (Capsule/Box/etc), or "none".
func _classify_model(node: Node) -> String:
	var saw_primitive := false
	var stack: Array = [node]
	while not stack.is_empty():
		var n: Node = stack.pop_back()
		if n is MeshInstance3D:
			var mesh = (n as MeshInstance3D).mesh
			if mesh != null:
				var cls := mesh.get_class()
				if cls == "ImporterMesh" or cls == "ArrayMesh":
					return "glb"
				if cls in ["CapsuleMesh", "BoxMesh", "SphereMesh", "CylinderMesh", "PrismMesh", "PlaneMesh", "QuadMesh"]:
					saw_primitive = true
				else:
					# Unknown non-primitive mesh — treat as credible geometry.
					return "glb"
		for c in n.get_children():
			stack.append(c)
	return "primitive" if saw_primitive else "none"

func _test_npcs(scene_name: String, path: String, npc_ids: Array) -> void:
	var p: PackedScene = load(path)
	if p == null:
		_results.append("FAIL LOAD npcs " + scene_name)
		return
	var s: Node = p.instantiate()
	root.add_child(s)
	var npcs_node: Node = s.get_node_or_null("NPCs")
	if npcs_node == null:
		_results.append("FAIL " + scene_name + " no NPCs node")
		s.queue_free()
		return
	for nid in npc_ids:
		var npc := _find_npc_by_id(npcs_node, nid)
		if npc == null:
			_results.append("FAIL NPC " + nid + " MISSING in " + scene_name)
			continue
		var kind := _classify_model(npc)
		if kind == "glb":
			_results.append("OK NPC " + nid + " GLB in " + scene_name)
		elif kind == "primitive":
			_results.append("FAIL NPC " + nid + " PRIMITIVE model in " + scene_name)
		else:
			_results.append("FAIL NPC " + nid + " NO model in " + scene_name)
	s.queue_free()

func _test_portals(scene_name: String, path: String, expected_dests: Array) -> void:
	var p: PackedScene = load(path)
	if p == null:
		_results.append("FAIL LOAD portals " + scene_name)
		return
	var s: Node = p.instantiate()
	var portals_node: Node = s.get_node_or_null("Portals")
	if portals_node == null:
		_results.append("FAIL " + scene_name + " no Portals node")
		s.queue_free()
		return
	for dest in expected_dests:
		var found := false
		for c in portals_node.get_children():
			var dest_path = c.get("destination_scene")
			if dest_path != null and dest in String(dest_path):
				if ResourceLoader.exists(dest_path):
					_results.append("OK Portal " + scene_name + " -> " + dest)
				else:
					_results.append("FAIL Portal " + scene_name + " -> " + dest + " target missing")
				found = true
				break
		if not found:
			_results.append("FAIL Portal " + scene_name + " -> " + dest + " NOT FOUND")
	s.queue_free()

func _report() -> void:
	for r in _results:
		print(r)
	var ok := 0
	var fail := 0
	for r in _results:
		if r.begins_with("FAIL"):
			fail += 1
		elif r.begins_with("OK"):
			ok += 1
	print("\nQUEST TEST: " + str(ok) + " OK, " + str(fail) + " FAIL")
	quit(0 if fail == 0 else 1)
