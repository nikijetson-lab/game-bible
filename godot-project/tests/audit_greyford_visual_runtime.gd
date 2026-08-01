extends SceneTree

const SCENES := [
	"res://scenes/locations/greyford/TavernInterior.tscn",
	"res://scenes/locations/greyford/PortTavernInterior.tscn",
	"res://scenes/locations/greyford/RufinRoom.tscn",
	"res://scenes/locations/greyford/CraftsmenQuarter.tscn",
	"res://scenes/locations/greyford/AlteyaHiddenRoom.tscn",
	"res://scenes/locations/greyford/GreyfordStreet.tscn",
	"res://scenes/locations/greyford/GreyfordGate.tscn",
]

func _initialize() -> void:
	call_deferred("_run")

func _glb_ancestor(node: Node) -> String:
	var current: Node = node
	while current != null:
		if current.scene_file_path.to_lower().ends_with(".glb"):
			return current.scene_file_path
		current = current.get_parent()
	return ""

func _walk(node: Node, stats: Dictionary, details: Array[String]) -> void:
	if node is MeshInstance3D and node.is_visible_in_tree():
		var mesh := (node as MeshInstance3D).mesh
		var glb_path := _glb_ancestor(node)
		if not glb_path.is_empty():
			stats.glb_meshes += 1
			stats.glb_sources[glb_path] = true
		elif mesh != null:
			var cls := mesh.get_class()
			if cls in ["BoxMesh", "SphereMesh", "CapsuleMesh", "CylinderMesh", "PrismMesh", "PlaneMesh", "QuadMesh"]:
				stats.primitives += 1
				details.append("PRIMITIVE %s %s" % [node.get_path(), cls])
			else:
				stats.other_meshes += 1
	if node is Label3D and node.is_visible_in_tree():
		stats.labels += 1
		details.append("LABEL3D %s text=%s" % [node.get_path(), (node as Label3D).text])
	if node is Light3D and node.is_visible_in_tree():
		stats.lights += 1
	for child in node.get_children():
		_walk(child, stats, details)

func _run() -> void:
	for path in SCENES:
		var packed := load(path) as PackedScene
		if packed == null:
			print("AUDIT_FAIL ", path)
			continue
		var instance := packed.instantiate()
		get_root().add_child(instance)
		await process_frame
		await process_frame
		var stats := {
			"primitives": 0,
			"glb_meshes": 0,
			"glb_sources": {},
			"other_meshes": 0,
			"labels": 0,
			"lights": 0,
		}
		var details: Array[String] = []
		_walk(instance, stats, details)
		print("AUDIT %s visible_primitive=%d glb_meshes=%d glb_sources=%d other_meshes=%d labels=%d lights=%d" % [
			path.get_file(), stats.primitives, stats.glb_meshes, stats.glb_sources.size(), stats.other_meshes, stats.labels, stats.lights
		])
		for source in stats.glb_sources.keys():
			print("  GLB ", source)
		for detail in details:
			print("  ", detail)
		instance.queue_free()
		await process_frame
	quit()
