extends SceneTree

const SCENES := [
	"res://scenes/locations/greyford/TavernInterior.tscn",
	"res://scenes/locations/greyford/CraftsmenQuarter.tscn",
	"res://scenes/locations/greyford/PortTavernInterior.tscn",
	"res://scenes/locations/greyford/GreyfordGate.tscn",
	"res://scenes/locations/greyford/AlteyaHiddenRoom.tscn",
	"res://scenes/locations/greyford/RufinRoom.tscn",
	"res://scenes/locations/greyford/GreyfordStreet.tscn",
]

func _init() -> void:
	call_deferred("_run")

func _world_aabb(mi: MeshInstance3D) -> AABB:
	return mi.global_transform * mi.get_aabb()

func _merge_visible_meshes(node: Node, result: Dictionary) -> void:
	if node is MeshInstance3D and node.visible and node.mesh != null:
		var box := _world_aabb(node)
		if box.size.length() > 0.001:
			if result["has"]:
				result["box"] = result["box"].merge(box)
			else:
				result["box"] = box
				result["has"] = true
	for child in node.get_children():
		_merge_visible_meshes(child, result)

func _npc_rows(node: Node, rows: Array[String]) -> void:
	if node is Area3D:
		var meshes := {"has": false, "box": AABB()}
		_merge_visible_meshes(node, meshes)
		if meshes["has"]:
			var box: AABB = meshes["box"]
			rows.append("NPC|%s|pos=%s|center=%s|size=%s" % [node.get_path(), node.global_position, box.get_center(), box.size])
	for child in node.get_children():
		_npc_rows(child, rows)

func _run() -> void:
	for path in SCENES:
		var packed: PackedScene = load(path)
		var scene: Node = packed.instantiate()
		root.add_child(scene)
		await process_frame
		await process_frame
		var all := {"has": false, "box": AABB()}
		_merge_visible_meshes(scene, all)
		var box: AABB = all["box"]
		print("SCENE|%s|center=%s|size=%s|min=%s|max=%s" % [path.get_file(), box.get_center(), box.size, box.position, box.end])
		var rows: Array[String] = []
		_npc_rows(scene, rows)
		for row in rows:
			print(row)
		scene.queue_free()
		await process_frame
	print("GREYFORD_VISUAL_BOUNDS_OK")
	quit()
