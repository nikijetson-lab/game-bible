extends SceneTree

func _init() -> void:
	var failures: Array[String] = []
	_check_resource("res://scripts/ai/AIPlanner.gd", failures)
	_check_resource("res://scripts/ai/NPCBehavior.gd", failures)
	_check_scene("res://scenes/locations/greyford/TavernInterior.tscn", failures)

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

func _check_scene(path: String, failures: Array[String]) -> void:
	var packed := load(path)
	if packed == null:
		failures.append("Failed to load scene: " + path)
		return

	var scene = packed.instantiate()
	if scene == null:
		failures.append("Failed to instantiate scene: " + path)
		return

	var npc_paths := [
		"NPCs/Ervan",
		"NPCs/Mia",
		"NPCs/Kelm"
	]
	for npc_path in npc_paths:
		var npc = scene.get_node_or_null(npc_path)
		if npc == null:
			failures.append("Missing NPC node: " + npc_path)
		elif not npc.has_method("interact"):
			failures.append("NPC node has no interact() method: " + npc_path)

	var dialogue_anchor = scene.get_node_or_null("DialogueAnchor")
	if dialogue_anchor == null:
		failures.append("Missing DialogueAnchor")
	var quest_board = scene.get_node_or_null("QuestBoard")
	if quest_board == null:
		failures.append("Missing QuestBoard")

	scene.queue_free()
