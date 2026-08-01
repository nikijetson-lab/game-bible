extends SceneTree

const MODELS := [
	"res://assets/meshy/greyford_tavern/tavern_interior_from_art.glb",
	"res://assets/meshy/greyford_tavern/tavern_props_kit.glb",
	"res://assets/meshy/greyford_tavern/tavern_bar_counter.glb",
]

func _initialize() -> void:
	call_deferred("_run")

func _collect(node: Node, root: Node3D, merged: AABB, has_box: bool) -> Dictionary:
	if node is MeshInstance3D and (node as MeshInstance3D).mesh != null:
		var mi := node as MeshInstance3D
		var rel := root.global_transform.affine_inverse() * mi.global_transform
		var box := rel * mi.get_aabb()
		if not has_box:
			merged = box
			has_box = true
		else:
			merged = merged.merge(box)
	for child in node.get_children():
		var result := _collect(child, root, merged, has_box)
		merged = result.box
		has_box = result.has_box
	return {"box": merged, "has_box": has_box}

func _run() -> void:
	for path in MODELS:
		var packed := load(path) as PackedScene
		var instance := packed.instantiate() as Node3D
		get_root().add_child(instance)
		await process_frame
		var result := _collect(instance, instance, AABB(), false)
		var box: AABB = result.box
		print("BOUNDS %s pos=%s size=%s center=%s children=%d" % [path.get_file(), box.position, box.size, box.get_center(), instance.get_child_count()])
		instance.queue_free()
		await process_frame
	quit()
