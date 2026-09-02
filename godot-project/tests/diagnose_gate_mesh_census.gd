extends SceneTree

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var packed: PackedScene = load("res://scenes/locations/greyford/GreyfordGate.tscn")
	var s := packed.instantiate()
	get_root().add_child(s)
	for i in range(6):
		await process_frame
	print("=== GATE MESH CENSUS (world AABB) ===")
	_walk(s, s)
	print("=== END ===")
	quit()

func _walk(node: Node, root_node: Node) -> void:
	if node is MeshInstance3D:
		var mi := node as MeshInstance3D
		var a := mi.get_aabb()
		var gt := mi.global_transform
		var wa := gt * a
		var h := wa.size.y
		if mi.visible and h > 0.001:
			print("%s | h=%.3f | gpos=(%.2f,%.2f,%.2f) | scale=%s" % [
				root_node.get_path_to(mi), h,
				gt.origin.x, gt.origin.y, gt.origin.z,
				str(gt.basis.get_scale())])
	for c in node.get_children():
		_walk(c, root_node)
