extends SceneTree

func _init() -> void:
	var failures: Array[String] = []
	_check_resource("res://scripts/ai/AIPlanner.gd", failures)
	_check_resource("res://scripts/ai/NPCBehavior.gd", failures)
	_check_resource("res://scripts/gameplay/LocationPortal.gd", failures)
	_check_resource("res://scripts/gameplay/InspectClue.gd", failures)
	_check_scene(
		"res://scenes/locations/greyford/TavernInterior.tscn",
		["NPCs/Ervan", "Portals/ToRufinRoomPortal", "Portals/ToCraftsmenQuarterPortal"],
		["NPCs/Mia", "NPCs/Kelm", "NPCs/Cassandra"],
		failures
	)
	_check_scene(
		"res://scenes/locations/greyford/PortTavernInterior.tscn",
		["NPCs/PortBartender", "NPCs/Cassandra", "Portals/ToGreyfordGatePortal"],
		["NPCs/Mia", "NPCs/Kelm"],
		failures
	)
	_check_scene(
		"res://scenes/locations/greyford/RufinRoom.tscn",
		["Portals/BackToTavernPortal", "Portals/ToCraftsmenQuarterPortal", "InvestigationProps/LeatherBagWithBrand"],
		["NPCs/Mia", "NPCs/Kelm"],
		failures
	)
	_check_scene(
		"res://scenes/locations/greyford/CraftsmenQuarter.tscn",
		["NPCs/Furrier", "NPCs/Woodcarver", "Portals/ToPortTavernPortal"],
		["NPCs/Mia", "NPCs/Kelm"],
		failures
	)
	_check_scene(
		"res://scenes/locations/greyford/AlteyaHiddenRoom.tscn",
		["NPCs/Alteya", "Portals/ToPortTavernPortal", "Portals/ToGreyfordGatePortal", "InvestigationProps/VeilTraceClue"],
		["NPCs/Mia", "NPCs/Kelm"],
		failures
	)
	_check_scene(
		"res://scenes/locations/greyford/GreyfordGate.tscn",
		["NPCs/GateSergeant", "Portals/ToSwampPortal"],
		["NPCs/Mia", "NPCs/Kelm"],
		failures
	)

	if failures.is_empty():
		print("AI_FOUNDATION_SMOKE_OK")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)

func _check_resource(path: String, failures: Array[String]) -> void:
	var resource: Variant = load(path)
	if resource == null:
		failures.append("Failed to load resource: " + path)

func _check_scene(path: String, required_paths: Array, forbidden_paths: Array, failures: Array[String]) -> void:
	var packed: Variant = load(path)
	if packed == null:
		failures.append("Failed to load scene: " + path)
		return

	var scene = packed.instantiate()
	if scene == null:
		failures.append("Failed to instantiate scene: " + path)
		return

	for node_path in required_paths:
		var node = scene.get_node_or_null(node_path)
		if node == null:
			failures.append("Missing required node in %s: %s" % [path, node_path])
		elif String(node_path).begins_with("NPCs/") and not node.has_method("interact"):
			failures.append("NPC node has no interact() method in %s: %s" % [path, node_path])

	for node_path in forbidden_paths:
		if scene.get_node_or_null(node_path) != null:
			failures.append("Forbidden node in %s: %s" % [path, node_path])

	var dialogue_anchor = scene.get_node_or_null("DialogueAnchor")
	if dialogue_anchor == null:
		failures.append("Missing DialogueAnchor in " + path)

	scene.queue_free()
