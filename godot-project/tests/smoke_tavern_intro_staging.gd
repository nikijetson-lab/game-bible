extends SceneTree

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var failures: Array[String] = []
	var packed: Variant = load("res://scenes/locations/greyford/TavernInterior.tscn")
	if packed == null:
		failures.append("Failed to load TavernInterior")
		_finish(failures)
		return

	var scene: Node = packed.instantiate()
	if scene == null:
		failures.append("Failed to instantiate TavernInterior")
		_finish(failures)
		return
	root.add_child(scene)
	await process_frame

	var staging: Node = scene.get_node_or_null("LetterHandoffStaging")
	var wiping_towel: Node = scene.get_node_or_null("NPCs/Ervan/WipingTowel") as Node3D
	var shoulder_towel: Node = scene.get_node_or_null("NPCs/Ervan/ShoulderTowel") as Node3D
	var ervan_letter: Node = scene.get_node_or_null("NPCs/Ervan/HeldLetter") as Node3D
	var guard_letter: Node = scene.get_node_or_null("NPCs/GreyfordGuard/CarriedLetter") as Node3D
	var bar_letter: Node = scene.get_node_or_null("BarCounter/SealedLetter") as Node3D

	if staging == null:
		failures.append("Missing LetterHandoffStaging")
	if wiping_towel == null or not wiping_towel.visible:
		failures.append("Scene start should show WipingTowel in Ervan's hand/bar-wiping beat")
	if shoulder_towel == null or shoulder_towel.visible:
		failures.append("ShoulderTowel should be hidden before guard/dialogue starts")
	if ervan_letter == null or ervan_letter.visible:
		failures.append("Ervan HeldLetter must be hidden at scene start")
	if guard_letter == null or not guard_letter.visible:
		failures.append("Guard must carry the letter at scene start")
	if bar_letter == null or bar_letter.visible:
		failures.append("Old bar SealedLetter / white plank must be hidden")

	if staging != null and staging.has_method("throw_towel_over_shoulder"):
		staging.call("throw_towel_over_shoulder")
		await process_frame
		if wiping_towel != null and wiping_towel.visible:
			failures.append("WipingTowel should hide when dialogue starts")
		if shoulder_towel != null and not shoulder_towel.visible:
			failures.append("ShoulderTowel should appear when dialogue starts")
	else:
		failures.append("Staging lacks throw_towel_over_shoulder")

	if staging != null and staging.has_method("complete_letter_handoff"):
		staging.call("complete_letter_handoff")
		await process_frame
		if guard_letter != null and guard_letter.visible:
			failures.append("Guard letter should hide after handoff")
		if ervan_letter != null and not ervan_letter.visible:
			failures.append("Ervan HeldLetter should show after handoff")
	else:
		failures.append("Staging lacks complete_letter_handoff")

	scene.queue_free()
	_finish(failures)

func _finish(failures: Array[String]) -> void:
	if failures.is_empty():
		print("TAVERN_INTRO_STAGING_SMOKE_OK")
		quit(0)
	else:
		for failure in failures:
			push_error(failure)
		quit(1)
