extends SceneTree

const ROWS := [
	["res://scenes/locations/greyford/TavernInterior.tscn", "NPCs/Ervan/MeshyErvanModel"],
	["res://scenes/locations/greyford/TavernInterior.tscn", "BackgroundPatrons/OldWomanPatron/MeshyOldWomanModel"],
	["res://scenes/locations/greyford/PortTavernInterior.tscn", "NPCs/PortBartender/MeshyBartenderModel"],
	["res://scenes/locations/greyford/CraftsmenQuarter.tscn", "NPCs/Furrier/MeshyFurrierModel"],
	["res://scenes/locations/greyford/CraftsmenQuarter.tscn", "NPCs/Woodcarver/MeshyWoodcarverModel"],
	["res://scenes/locations/greyford/GreyfordGate.tscn", "NPCs/GateSergeant/MeshySergeantModel"],
	["res://scenes/locations/greyford/AlteyaHiddenRoom.tscn", "NPCs/Alteya/MeshyAlteyaModel"],
]

func _initialize() -> void:
	call_deferred("_run")

func _walk(n: Node, model: Node3D) -> void:
	if n is AnimationPlayer:
		var ap := n as AnimationPlayer
		print("  AP path=%s playing=%s current=%s" % [model.get_path_to(ap), ap.is_playing(), ap.current_animation])
	if n is Skeleton3D:
		var sk := n as Skeleton3D
		print("  SK path=%s local_scale=%s global_scale=%s" % [model.get_path_to(sk), sk.scale, sk.global_basis.get_scale()])
	if n is MeshInstance3D:
		var mi := n as MeshInstance3D
		print("  MI path=%s local_scale=%s global_scale=%s aabb=%s world_aabb=%s" % [model.get_path_to(mi), mi.scale, mi.global_basis.get_scale(), mi.get_aabb(), mi.global_transform * mi.get_aabb()])
	for child in n.get_children():
		_walk(child, model)

func _run() -> void:
	for row in ROWS:
		var packed := load(row[0]) as PackedScene
		var scene := packed.instantiate()
		root.add_child(scene)
		for i in 4:
			await process_frame
		var model := scene.get_node(row[1]) as Node3D
		print("MODEL %s path=%s local_scale=%s global_scale=%s position=%s" % [row[0].get_file(), row[1], model.scale, model.global_basis.get_scale(), model.global_position])
		_walk(model, model)
		scene.queue_free()
		await process_frame
	print("NPC_RIG_RUNTIME_DIAG_OK")
	quit()
