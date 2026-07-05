extends Node3D

# Runtime visual assembly for Rufin the cartographer's room.
# Adds desk, map tubes, wall maps, travel gear, scattered papers, and quest clues.
# Does NOT create or modify any lights/environment.

var mat_old_wood: StandardMaterial3D
var mat_paper: StandardMaterial3D
var mat_paper_dark: StandardMaterial3D
var mat_leather: StandardMaterial3D
var mat_cloth_grey: StandardMaterial3D
var mat_candle: StandardMaterial3D
var mat_ink: StandardMaterial3D
var mat_map_green: StandardMaterial3D
var mat_clay: StandardMaterial3D


func _ready() -> void:
	_create_materials()
	var dressing := Node3D.new()
	dressing.name = "RufinArtDressing"
	add_child(dressing)

	dressing.add_child(_build_cartographer_desk())
	dressing.add_child(_build_map_tubes())
	dressing.add_child(_build_wall_maps())
	dressing.add_child(_build_travel_gear())
	dressing.add_child(_build_scattered_papers())
	dressing.add_child(_build_quest_clues())


func _create_materials() -> void:
	mat_old_wood = _mat(Color(0.18, 0.13, 0.08), "res://assets/textures/greyford_tavern/dark_wood_planks.png", 0.92)
	mat_paper = _mat(Color(0.60, 0.56, 0.46), "res://assets/textures/greyford_tavern/aged_paper.png", 0.95)
	mat_paper_dark = _mat(Color(0.48, 0.44, 0.36), "res://assets/textures/greyford_tavern/aged_paper.png", 0.95)
	mat_leather = _mat(Color(0.30, 0.20, 0.12), "res://assets/textures/greyford_tavern/dirty_towel_cloth.png", 0.95)
	mat_cloth_grey = _mat(Color(0.36, 0.35, 0.32), "res://assets/textures/greyford_tavern/dirty_towel_cloth.png", 0.95)
	mat_candle = _mat(Color(0.85, 0.80, 0.70), "", 0.95)
	mat_candle.emission_enabled = true
	mat_candle.emission = Color(0.9, 0.55, 0.2)
	mat_candle.emission_energy_multiplier = 0.8
	mat_ink = _mat(Color(0.08, 0.08, 0.09), "", 0.4)
	mat_map_green = _mat(Color(0.35, 0.40, 0.32), "res://assets/textures/greyford_tavern/smoked_plaster.png", 0.95)
	mat_clay = _mat(Color(0.06, 0.05, 0.03), "res://assets/textures/greyford_tavern/wet_floor_planks.png", 0.8)


func _mat(color: Color, texture_path: String, roughness: float) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = roughness
	m.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
	if texture_path != "":
		var tex := load(texture_path)
		if tex is Texture2D:
			m.albedo_texture = tex
	return m


func _box(parent: Node3D, name: String, pos: Vector3, size: Vector3,
		material: Material, rot_deg: Vector3 = Vector3.ZERO) -> MeshInstance3D:
	var mesh := BoxMesh.new()
	mesh.size = size
	var mi := MeshInstance3D.new()
	mi.name = name
	mi.mesh = mesh
	mi.material_override = material
	mi.position = pos
	mi.rotation_degrees = rot_deg
	parent.add_child(mi)
	return mi


func _build_cartographer_desk() -> Node3D:
	var desk := Node3D.new()
	desk.name = "CartographerDesk"
	desk.position = Vector3(1.8, 0, -1.6)

	_box(desk, "Tabletop", Vector3(0, 0.78, 0), Vector3(1.2, 0.07, 0.7), mat_old_wood)

	var leg_offsets := [Vector3(-0.54, 0, -0.32), Vector3(-0.54, 0, 0.32),
		Vector3(0.54, 0, -0.32), Vector3(0.54, 0, 0.32)]
	for i in range(leg_offsets.size()):
		_box(desk, "Leg_%s" % i, leg_offsets[i] + Vector3(0, 0.39, 0),
			Vector3(0.06, 0.78, 0.06), mat_old_wood)

	# Unrolled map
	var map_layer := Node3D.new()
	map_layer.name = "MapLayer"
	map_layer.position = Vector3(0, 0.82, 0)
	desk.add_child(map_layer)
	_box(map_layer, "MapBase", Vector3(0, 0, 0), Vector3(0.8, 0.01, 0.55), mat_map_green)
	_box(map_layer, "MapSheet", Vector3(0, 0.012, 0), Vector3(0.5, 0.012, 0.4), mat_paper, Vector3(0, 15, 0))

	# Inkwell + candle
	_box(desk, "Inkwell", Vector3(0.4, 0.82, -0.25), Vector3(0.07, 0.07, 0.07), mat_ink)
	_box(desk, "CandleStub", Vector3(-0.2, 0.82, 0.25), Vector3(0.06, 0.12, 0.06), mat_candle)

	# Stool
	_box(desk, "StoolSeat", Vector3(-0.8, 0.42, 0.05), Vector3(0.4, 0.06, 0.35), mat_old_wood)
	for sx in [-0.16, 0.16]:
		for sz in [-0.12, 0.12]:
			_box(desk, "StoolLeg", Vector3(-0.8 + sx, 0.21, 0.05 + sz), Vector3(0.05, 0.42, 0.05), mat_old_wood)

	return desk


func _build_map_tubes() -> Node3D:
	var tubes := Node3D.new()
	tubes.name = "MapTubes"
	_box(tubes, "Tube_Leaning", Vector3(1.95, 0.42, -1.9),
		Vector3(0.09, 0.85, 0.09), mat_leather, Vector3(12, 0, 0))
	_box(tubes, "Tube_Floor_1", Vector3(-1.5, 0.42, 1.2),
		Vector3(0.09, 0.85, 0.09), mat_leather, Vector3(0, 0, 90))
	_box(tubes, "Tube_Floor_2", Vector3(-1.3, 0.42, 1.0),
		Vector3(0.09, 0.85, 0.09), mat_leather, Vector3(0, 0, 85))
	return tubes


func _build_wall_maps() -> Node3D:
	var wall_maps := Node3D.new()
	wall_maps.name = "WallMaps"
	_box(wall_maps, "WallMap_Large", Vector3(3.4, 1.7, -0.5),
		Vector3(0.65, 0.5, 0.015), mat_paper)
	_box(wall_maps, "WallMap_Small", Vector3(-0.8, 1.7, 2.9),
		Vector3(0.5, 0.42, 0.015), mat_paper_dark)
	return wall_maps


func _build_travel_gear() -> Node3D:
	var gear := Node3D.new()
	gear.name = "TravelGear"

	var chest := Node3D.new()
	chest.name = "TravelChest"
	chest.position = Vector3(-1.8, 0, 1.6)
	gear.add_child(chest)
	_box(chest, "ChestBody", Vector3(0, 0.225, 0), Vector3(0.85, 0.45, 0.5), mat_old_wood)
	_box(chest, "ChestLid", Vector3(0, 0.49, 0),
		Vector3(0.85, 0.06, 0.5), mat_old_wood, Vector3(-8, 0, 0))

	_box(gear, "FoldedBlanket", Vector3(-0.5, 0.18, 2.2),
		Vector3(0.5, 0.18, 0.35), mat_cloth_grey)

	_box(gear, "Boot_Left", Vector3(-1.95, 0.14, 1.1),
		Vector3(0.12, 0.28, 0.3), mat_leather)
	_box(gear, "Boot_Right", Vector3(-1.75, 0.14, 1.05),
		Vector3(0.12, 0.28, 0.3), mat_leather)

	return gear


func _build_scattered_papers() -> Node3D:
	var papers := Node3D.new()
	papers.name = "ScatteredPapers"
	var angles := [10.0, 30.0, 55.0, 70.0, 20.0]
	var positions := [
		Vector3(1.2, 0.004, -2.0),
		Vector3(1.6, 0.004, -2.2),
		Vector3(2.1, 0.004, -1.9),
		Vector3(1.4, 0.004, -2.4),
		Vector3(2.3, 0.004, -2.2),
	]
	for i in range(positions.size()):
		_box(papers, "Paper_%s" % i, positions[i],
			Vector3(0.25, 0.008, 0.32), mat_paper, Vector3(0, angles[i], 0))
	return papers


func _build_quest_clues() -> Node3D:
	var clues := Node3D.new()
	clues.name = "QuestClues"

	# Worn cloak
	_box(clues, "WornCloak", Vector3(2.8, 1.5, 2.5),
		Vector3(0.6, 0.8, 0.06), mat_cloth_grey, Vector3(0, 5, 0))

	# Empty leather bag with stamp
	var bag := Node3D.new()
	bag.name = "LeatherBag"
	bag.position = Vector3(1.2, 0.08, -2.5)
	clues.add_child(bag)
	_box(bag, "BagBody", Vector3(0, 0.12, 0), Vector3(0.35, 0.22, 0.25), mat_leather)
	_box(bag, "StampMark", Vector3(0, 0.12, 0.13), Vector3(0.08, 0.06, 0.01), mat_ink)

	# Black bog clay traces
	for i in range(4):
		_box(clues, "BogClay_%d" % i,
			Vector3(0.3 + i * 0.4, 0.003, -2.8),
			Vector3(0.15, 0.01, 0.2), mat_clay)

	# Protective signs above door
	var signs := Node3D.new()
	signs.name = "ProtectiveSigns"
	signs.position = Vector3(-2.2, 2.3, -3.1)
	clues.add_child(signs)
	for i in range(3):
		_box(signs, "Ward_%d" % i, Vector3(i * 0.35, 0, 0),
			Vector3(0.15, 0.15, 0.01), mat_candle)

	return clues
