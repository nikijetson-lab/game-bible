extends SceneTree

func _init() -> void:
	print("BEFORE_LOAD")
	var script = load("res://scripts/gameplay/SwampPathArtAssembly.gd")
	if script == null:
		print("SCRIPT_LOAD_FAILED")
		quit(1)
		return
	print("SCRIPT_LOADED_OK: ", script)
	print("BEFORE_NEW")
	var inst = script.new()
	print("INSTANCE_CREATED: ", inst)
	if inst is Node3D:
		root.add_child(inst)
	print("ADDED_TO_TREE")
	quit(0)
