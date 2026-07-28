extends Node3D
## GreyfordStreetArtAssembly — runtime visual assembly for the central Greyford street hub.
## Builds a medieval walled-town street matching the hand-drawn Greyford map:
## cobblestone ground, stone/timber buildings on both sides, iron gate at one end,
## hanging lanterns, fogged atmosphere.

const TEX_COBBLE := "res://assets/textures/greyford_tavern/wet_floor_planks.png"
const TEX_WOOD := "res://assets/textures/greyford_tavern/dark_wood_planks.png"
const TEX_PLASTER := "res://assets/textures/greyford_tavern/smoked_plaster.png"
const TEX_BEAMS := "res://assets/textures/greyford_tavern/soot_beams.png"

var mat_stone: StandardMaterial3D
var mat_wood: StandardMaterial3D
var mat_beam: StandardMaterial3D
var mat_roof: StandardMaterial3D
var mat_metal: StandardMaterial3D
var mat_warm: StandardMaterial3D
var mat_plaster: StandardMaterial3D
var mat_ground: StandardMaterial3D

func _ready() -> void:
	# _hide_blockout()
	_create_materials()
	_build_ground()
	_build_north_buildings()
	_build_south_buildings()
	_build_gate_end()
	_build_street_lanterns()
	_build_details()

func _hide_blockout() -> void:
	var root := get_parent()
	for path in ["Floor", "NorthWall", "SouthWall", "EastWall", "WestWall", "LanternA", "LanternB", "LanternC", "LanternD"]:
		var node := root.get_node_or_null(path)
		if node is Node3D:
			(node as Node3D).visible = false

func _create_materials() -> void:
	mat_ground = _mat(Color(0.35, 0.33, 0.30), TEX_COBBLE, 0.88)
	mat_stone = _mat(Color(0.45, 0.43, 0.40), TEX_PLASTER, 0.92)
	mat_wood = _mat(Color(0.28, 0.18, 0.10), TEX_WOOD, 0.86)
	mat_beam = _mat(Color(0.15, 0.10, 0.07), TEX_BEAMS, 0.94)
	mat_roof = _mat(Color(0.12, 0.08, 0.05), "", 0.95)
	mat_metal = _mat(Color(0.25, 0.22, 0.18), "", 0.52)
	mat_metal.metallic = 0.5
	mat_warm = _mat(Color(0.95, 0.52, 0.15), "", 0.55)
	mat_warm.emission_enabled = true
	mat_warm.emission = Color(0.95, 0.42, 0.10)
	mat_warm.emission_energy_multiplier = 0.7
	mat_plaster = _mat(Color(0.62, 0.60, 0.56), TEX_PLASTER, 0.90)

func _mat(color: Color, tex_path: String, roughness: float) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = roughness
	m.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
	if tex_path != "":
		var tex := load(tex_path)
		if tex is Texture2D:
			m.albedo_texture = tex
	return m

func _box(p: Node3D, nm: String, pos: Vector3, sz: Vector3, mat: Material, rot: Vector3 = Vector3.ZERO) -> MeshInstance3D:
	var m := BoxMesh.new(); m.size = sz
	var mi := MeshInstance3D.new(); mi.name = nm; mi.mesh = m
	mi.material_override = mat; mi.position = pos; mi.rotation_degrees = rot
	p.add_child(mi); return mi

func _cyl(p: Node3D, nm: String, pos: Vector3, r: float, h: float, mat: Material) -> MeshInstance3D:
	var m := CylinderMesh.new(); m.top_radius = r; m.bottom_radius = r
	m.height = h; m.radial_segments = 16
	var mi := MeshInstance3D.new(); mi.name = nm; mi.mesh = m
	mi.material_override = mat; mi.position = pos
	p.add_child(mi); return mi

func _build_ground() -> void:
	var g := Node3D.new(); g.name = "ArtGround"; add_child(g)
	_box(g, "CobblestoneStreet", Vector3(0, -0.08, 0), Vector3(14, 0.16, 20), mat_ground)
	# Subtle street edges
	_box(g, "StreetEdgeN", Vector3(0, 0.02, 9.9), Vector3(14, 0.18, 0.4), mat_stone)
	_box(g, "StreetEdgeS", Vector3(0, 0.02, -9.9), Vector3(14, 0.18, 0.4), mat_stone)

func _build_north_buildings() -> void:
	var n := Node3D.new(); n.name = "ArtNorthRow"; add_child(n)
	# Row of 2-3 story stone/timber buildings along the north side (z positive).
	for i in range(5):
		var bx := -6.0 + i * 3.0
		var bh := 2.5 + (i % 3) * 0.8  # varied heights
		_box(n, "BldgN_%d" % i, Vector3(bx, bh*0.5+0.1, 7.8), Vector3(2.6, bh, 2.8), mat_stone)
		_box(n, "RoofN_%d" % i, Vector3(bx, bh+0.35, 7.8), Vector3(2.9, 0.25, 3.1), mat_roof, Vector3(0, 0, 0))
		# Timber frame accents
		for fy in [0.3, bh*0.65]:
			_box(n, "BeamN_%d_%d" % [i, int(fy*10)], Vector3(bx, fy+0.15, 8.8), Vector3(2.5, 0.15, 0.15), mat_beam)
		# Window
		if i % 2 == 0:
			_box(n, "WinN_%d" % i, Vector3(bx, 1.5, 8.95), Vector3(0.9, 0.7, 0.05), mat_metal)

func _build_south_buildings() -> void:
	var s := Node3D.new(); s.name = "ArtSouthRow"; add_child(s)
	for i in range(5):
		var bx := -5.5 + i * 3.0
		var bh := 2.2 + (i % 2) * 1.0
		_box(s, "BldgS_%d" % i, Vector3(bx, bh*0.5+0.1, -7.8), Vector3(2.4, bh, 2.8), mat_plaster)
		_box(s, "RoofS_%d" % i, Vector3(bx, bh+0.35, -7.8), Vector3(2.7, 0.25, 3.1), mat_roof)
		for fy in [0.3, bh*0.65]:
			_box(s, "BeamS_%d_%d" % [i, int(fy*10)], Vector3(bx, fy+0.15, -8.8), Vector3(2.3, 0.15, 0.15), mat_beam)
		if i % 2 == 1:
			_box(s, "WinS_%d" % i, Vector3(bx, 1.4, -8.95), Vector3(0.85, 0.65, 0.05), mat_metal)

func _build_gate_end() -> void:
	var gate := Node3D.new(); gate.name = "ArtIronGate"; add_child(gate)
	# Two stone towers flanking the gate on the east end.
	_cyl(gate, "GateTowerN", Vector3(6.0, 1.7, 1.8), 0.85, 3.4, mat_stone)
	_cyl(gate, "GateTowerS", Vector3(6.0, 1.7, -1.8), 0.85, 3.4, mat_stone)
	# Tower roofs
	_cyl(gate, "TowerRoofN", Vector3(6.0, 3.5, 1.8), 1.0, 0.5, mat_roof)
	_cyl(gate, "TowerRoofS", Vector3(6.0, 3.5, -1.8), 1.0, 0.5, mat_roof)
	# Iron gate between towers
	_box(gate, "IronGate", Vector3(6.5, 1.5, 0), Vector3(0.2, 2.8, 2.8), mat_metal)
	# Gate arch
	_box(gate, "GateArchTop", Vector3(6.5, 2.95, 0), Vector3(0.3, 0.3, 3.2), mat_stone)
	# Wall connecting towers to buildings
	_box(gate, "GateWallTop", Vector3(6.0, 3.0, 4.5), Vector3(1.8, 0.5, 1.5), mat_stone)
	_box(gate, "GateWallBottom", Vector3(6.0, 0.3, 4.5), Vector3(1.8, 0.6, 1.5), mat_stone)

func _build_street_lanterns() -> void:
	var l := Node3D.new(); l.name = "ArtLanterns"; add_child(l)
	for i in range(4):
		var lz := -6.0 + i * 4.0
		var post_h := 2.4
		_cyl(l, "LanternPost_%d" % i, Vector3(0, post_h*0.5, lz), 0.08, post_h, mat_metal)
		_box(l, "LanternBody_%d" % i, Vector3(0, post_h+0.25, lz), Vector3(0.45, 0.45, 0.45), mat_warm)
		_box(l, "LanternCap_%d" % i, Vector3(0, post_h+0.55, lz), Vector3(0.55, 0.08, 0.55), mat_metal)
		_cyl(l, "LanternFinial_%d" % i, Vector3(0, post_h+0.72, lz), 0.05, 0.2, mat_metal)

func _build_details() -> void:
	var d := Node3D.new(); d.name = "ArtDetails"; add_child(d)
	# Cart near gate
	_box(d, "CartBody", Vector3(4.5, 0.55, -2.5), Vector3(2.2, 0.6, 1.2), mat_wood)
	_cyl(d, "CartWheelL", Vector3(3.8, 0.3, -3.0), 0.3, 0.12, mat_beam)
	_cyl(d, "CartWheelR", Vector3(5.2, 0.3, -2.0), 0.3, 0.12, mat_beam)
	# Notice board near center
	_box(d, "NoticeBoard", Vector3(-5.5, 1.2, -4.5), Vector3(1.2, 1.0, 0.08), mat_wood)
	_box(d, "NoticeBoardPost", Vector3(-5.5, 0.55, -4.5), Vector3(0.1, 1.1, 0.1), mat_beam)
	# Shrine/book near gate
	_box(d, "ShrineBase", Vector3(5.0, 0.35, 4.2), Vector3(0.8, 0.3, 0.6), mat_stone)
	_box(d, "ShrineBook", Vector3(5.0, 0.55, 4.2), Vector3(0.5, 0.06, 0.35), mat_wood)
	# Scattered barrels
	for bp in [Vector3(-3, 0.35, 5.5), Vector3(-5, 0.35, -6), Vector3(4, 0.35, -5.5)]:
		_cyl(d, "Barrel", bp, 0.28, 0.6, mat_wood)
