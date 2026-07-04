extends SceneTree

func _init() -> void:
	call_deferred("_check")

func _check() -> void:
	var packed: PackedScene = load("res://scenes/locations/hazemoor/SwampPath.tscn")
	var scene := packed.instantiate()
	root.add_child(scene)
	await root.get_tree().process_frame
	await root.get_tree().process_frame
	var art := scene.get_node_or_null("SwampArtAssembly")
	if art == null:
		print("ART_NODE_NOT_FOUND")
		quit(1)
		return
	print("ART_NODE_CHILDREN: ", art.get_child_count())
	var dressing := art.get_node_or_null("SwampArtDressing")
	if dressing == null:
		print("DRESSING_NOT_FOUND")
	else:
		print("DRESSING_CHILDREN: ", dressing.get_child_count())
		for c in dressing.get_children():
			print(" - ", c.name, " (", c.get_child_count(), " children)")
	quit(0)
