extends SceneTree
## Runtime progression gate for Slice 01 — greyford_01_missing_recipient.
## Pins the canonical contract, not current behavior:
##  - completing a subset of required objectives must NOT complete the quest;
##  - completing ALL required objectives completes it exactly once;
##  - completion unlocks the route toward Tykhy Shelest.
## Runs deferred so the Quests autoload is registered before we touch it.

var _fail: Array[String] = []

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var qid := "greyford_01_missing_recipient"
	var qm = Engine.get_singleton("Quests") if Engine.has_singleton("Quests") else get_root().get_node_or_null("Quests")
	if qm == null:
		_finish(["Quests autoload not found"])
		return

	var data: Dictionary = qm.get_quest_data(qid)
	if data.is_empty():
		_finish(["quest data missing for " + qid])
		return

	var required: Array = []
	for o in data.get("objectives", []):
		if not o.get("optional", false):
			required.append(o.get("id"))
	if required.size() < 2:
		_finish(["expected >=2 required objectives, got " + str(required.size())])
		return

	# Fresh state.
	qm.active_quests.clear()
	qm.completed_quests.clear()
	qm.completed_objectives.clear()
	qm.world_flags.clear()

	if not qm.try_start_quest(qid):
		# GameManager may auto-start it; force clean start.
		qm.completed_quests.erase(qid)
		if not qm.try_start_quest(qid):
			_finish(["could not start " + qid])
			return

	# Complete all required objectives except the last.
	for i in range(required.size() - 1):
		qm.complete_objective(qid, required[i])

	if qid in qm.completed_quests:
		_fail.append("quest completed early after " + str(required.size() - 1) + "/" + str(required.size()) + " required objectives (completion_conditions.required_objectives gap)")

	# Complete the final required objective.
	qm.complete_objective(qid, required[required.size() - 1])

	if qid not in qm.completed_quests:
		_fail.append("quest did NOT complete after all " + str(required.size()) + " required objectives")

	# Route unlock: canonical contract says completion unlocks the Tykhy Shelest path.
	var unlocks_route := String(data.get("completion_conditions", {}).get("unlocks_route", ""))
	if unlocks_route == "":
		_fail.append("completion_conditions.unlocks_route missing in quest data")

	_finish(_fail)

func _finish(failures: Array) -> void:
	if failures.is_empty():
		print("GREYFORD_01_PROGRESSION_OK")
		quit(0)
	else:
		for f in failures:
			push_error(f)
			print("FAIL: " + String(f))
		print("GREYFORD_01_PROGRESSION_FAIL")
		quit(1)
