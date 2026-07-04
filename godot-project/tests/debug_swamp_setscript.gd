extends SceneTree

func _init() -> void:
	call_deferred("_check")

func _check() -> void:
	var script = load("res://scripts/gameplay/SwampPathArtAssembly.gd")
	if script == null:
		print("SCRIPT_LOAD_FAILED")
		quit(1)
		return
	print("SCRIPT_OK")
	var node := Node3D.new()
	node.set_script(script)
	root.add_child(node)
	print("ADDED_NODE_WITH_SCRIPT")
	await root.get_tree().process_frame
	await root.get_tree().process_frame
	print("AFTER_FRAMES children=", node.get_child_count())
	for c in node.get_children():
		print(" - ", c.name)
	quit(0)
