extends SceneTree

func _init() -> void:
	var failures: Array[String] = []
	_check_resource("res://scripts/ai/AIPlanner.gd", failures)
	_check_resource("res://scripts/ai/NPCBehavior.gd", failures)
	_check_scene(
		"res://scenes/locations/greyford/TavernInterior.tscn",
		["NPCs/Ervan"],
		["NPCs/Mia", "NPCs/Kelm", "NPCs/Cassandra"],
		failures
	)
	_check_scene(
		"res://scenes/locations/greyford/PortTavernInterior.tscn",
		["NPCs/PortBartender", "NPCs/Cassandra"],
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
	var resource := load(path)
	if resource == null:
		failures.append("Failed to load resource: " + path)

func _check_scene(path: String, required_npc_paths: Array[String], forbidden_npc_paths: Array[String], failures: Array[String]) -> void:
	var packed := load(path)
	if packed == null:
		failures.append("Failed to load scene: " + path)
		return

	var scene = packed.instantiate()
	if scene == null:
		failures.append("Failed to instantiate scene: " + path)
		return

	for npc_path in required_npc_paths:
		var npc = scene.get_node_or_null(npc_path)
		if npc == null:
			failures.append("Missing NPC node in %s: %s" % [path, npc_path])
		elif not npc.has_method("interact"):
			failures.append("NPC node has no interact() method in %s: %s" % [path, npc_path])

	for npc_path in forbidden_npc_paths:
		if scene.get_node_or_null(npc_path) != null:
			failures.append("Forbidden NPC node in %s: %s" % [path, npc_path])

	var dialogue_anchor = scene.get_node_or_null("DialogueAnchor")
	if dialogue_anchor == null:
		failures.append("Missing DialogueAnchor in " + path)

	scene.queue_free()
