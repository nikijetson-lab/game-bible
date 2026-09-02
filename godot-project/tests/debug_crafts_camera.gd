extends SceneTree

func _initialize() -> void:
	call_deferred("_run")

func _global_aabb(mi: MeshInstance3D) -> AABB:
	return mi.global_transform * mi.get_aabb()

func _run() -> void:
	var scene := load("res://scenes/locations/greyford/CraftsmenQuarter.tscn") as PackedScene
	var s := scene.instantiate()
	root.add_child(s)
	await process_frame
	await process_frame
	# shot 1: top-down view to prove content exists
	var cam := Camera3D.new()
	cam.fov = 62.0
	cam.near = 0.12
	root.add_child(cam)
	cam.make_current()
	DirAccess.make_dir_recursive_absolute("res://screenshots")
	# top-down
	cam.global_position = Vector3(0, 12, 0)
	cam.look_at(Vector3(0, 0, 0), Vector3.FORWARD)
	await process_frame
	for i in 10: await process_frame
	root.get_viewport().get_texture().get_image().save_png("res://screenshots/dbg_crafts_top.png")
	print("SHOT top-down saved")
	# shot 2: the render-test camera, then list everything between cam and target
	cam.global_position = Vector3(7.2, 2.8, 5.0)
	cam.look_at(Vector3(0.8, 1.55, -1.35), Vector3.UP)
	await process_frame
	for i in 60: await process_frame
	root.get_viewport().get_texture().get_image().save_png("res://screenshots/dbg_crafts_testcam.png")
	print("SHOT testcam saved")
	# list all visible meshes with global AABB
	var cam_pos := cam.global_position
	for mi in s.find_children("*", "MeshInstance3D", true, false):
		if mi.mesh == null or not mi.visible:
			continue
		var g := _global_aabb(mi)
		var dist := (g.get_center() - cam_pos).length()
		var contains := g.has_point(cam_pos)
		print("MESH %s parent=%s size=%s center=%s dist=%.1f cam_inside=%s" % [mi.name, mi.get_parent().name, g.size.round(), g.get_center().round(), dist, contains])
	print("DONE")
	quit()
