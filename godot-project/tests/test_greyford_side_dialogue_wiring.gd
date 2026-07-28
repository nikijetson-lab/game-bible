extends SceneTree
## Slice 01 RED gate: real DialogueManager.end_dialogue() must advance the
## currently reachable dialogue objective, but never skip later objectives.

var _fail: Array[String] = []

func _init() -> void:
	call_deferred("_run")

func _reset(qm: Node) -> void:
	qm.active_quests.clear()
	qm.completed_quests.clear()
	qm.completed_objectives.clear()
	qm.world_flags.clear()

func _talk(dialogue: Node, npc_id: String) -> void:
	dialogue.current_npc = npc_id
	dialogue.is_dialogue_active = true
	dialogue.end_dialogue()

func _run() -> void:
	var qm := get_root().get_node_or_null("Quests")
	var dialogue := get_root().get_node_or_null("Dialogue")
	if qm == null or dialogue == null:
		_finish(["Quests or Dialogue autoload missing"])
		return

	# Witch trouble: Ervan and Kelm are sequential required dialogue objectives.
	_reset(qm)
	if not qm.try_start_quest("greyford_side_01_witch_trouble"):
		_fail.append("could not start greyford_side_01_witch_trouble")
	else:
		_talk(dialogue, "npc_ervan")
		var done1: Array = qm.completed_objectives.get("greyford_side_01_witch_trouble", [])
		if not "hear_rumors" in done1:
			_fail.append("Ervan dialogue did not complete hear_rumors")
		if "talk_kelm" in done1:
			_fail.append("Ervan dialogue skipped ahead to talk_kelm")

		_talk(dialogue, "npc_kelm")
		done1 = qm.completed_objectives.get("greyford_side_01_witch_trouble", [])
		if not "talk_kelm" in done1:
			_fail.append("Kelm dialogue did not complete talk_kelm")

	# Lost heirloom: first Varrik talk must complete only talk_varrik.
	_reset(qm)
	if not qm.try_start_quest("greyford_side_02_lost_heirloom"):
		_fail.append("could not start greyford_side_02_lost_heirloom")
	else:
		_talk(dialogue, "npc_varrik")
		var done2: Array = qm.completed_objectives.get("greyford_side_02_lost_heirloom", [])
		if not "talk_varrik" in done2:
			_fail.append("Varrik first dialogue did not complete talk_varrik")
		if "return_varrik" in done2:
			_fail.append("Varrik first dialogue incorrectly completed return_varrik")

		# Return is not reachable until search + find are complete.
		qm.complete_objective("greyford_side_02_lost_heirloom", "search_swamp_edge")
		qm.complete_objective("greyford_side_02_lost_heirloom", "find_medallion")
		_talk(dialogue, "npc_varrik")
		if not "greyford_side_02_lost_heirloom" in qm.completed_quests:
			_fail.append("Varrik return dialogue did not complete the quest after medallion")

	_finish(_fail)

func _finish(failures: Array) -> void:
	if failures.is_empty():
		print("GREYFORD_SIDE_DIALOGUE_WIRING_OK")
		quit(0)
	else:
		for failure in failures:
			print("FAIL: " + String(failure))
		print("GREYFORD_SIDE_DIALOGUE_WIRING_FAIL")
		quit(1)
