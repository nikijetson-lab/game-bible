extends Node3D

const TEX_WOOD := "res://assets/textures/greyford_tavern/dark_wood_planks.png"
const TEX_FLOOR := "res://assets/textures/greyford_tavern/wet_floor_planks.png"
const TEX_PLASTER := "res://assets/textures/greyford_tavern/smoked_plaster.png"
const TEX_BEAMS := "res://assets/textures/greyford_tavern/soot_beams.png"
const TEX_BARREL := "res://assets/textures/greyford_tavern/barrel_staves.png"
const TEX_CRATE := "res://assets/textures/greyford_tavern/crate_boards.png"
const TEX_WINDOW := "res://assets/textures/greyford_tavern/rainy_cold_window.png"
const TEX_CLOTH := "res://assets/textures/greyford_tavern/dirty_towel_cloth.png"
const TEX_PAPER := "res://assets/textures/greyford_tavern/aged_paper.png"

# Runtime visual assembly for the Swamp Path (Ash Trails) art dressing.
# Builds boardwalk with chains, cracked mud flats, still black pools,
# dry reeds, ancient menhirs with runes, and fallen columns.
# Does NOT create or modify lights/environment.

var mat_cracked_mud: StandardMaterial3D
var mat_mud_dark: StandardMaterial3D
var mat_black_water: StandardMaterial3D
var mat_plank: StandardMaterial3D
var mat_plank_dark: StandardMaterial3D
var mat_chain: StandardMaterial3D
var mat_reed_dry: StandardMaterial3D
var mat_reed_pale: StandardMaterial3D
var mat_stone_ancient: StandardMaterial3D
var mat_rune: StandardMaterial3D

func _ready() -> void:
	print("SWAMP_ART_READY_FIRED")
	var root: Node3D = Node3D.new()
	root.name = "SwampArtDressing"
	add_child(root)
	_create_materials()
	_build_boardwalk(root)
	_build_cracked_flats(root)
	_build_still_pools(root)
	_build_dry_reeds(root)
	_build_menhirs(root)
	_build_fallen_columns(root)

func _create_materials() -> void:
	mat_cracked_mud = _mat(Color(0.32, 0.29, 0.25), 0.9)
	mat_mud_dark = _mat(Color(0.22, 0.20, 0.17), 0.9)
	mat_black_water = _mat(Color(0.05, 0.06, 0.07), 0.08)
	mat_black_water.metallic = 0.1
	mat_plank = _mat(Color(0.24, 0.18, 0.11), 0.88)
	mat_plank_dark = _mat(Color(0.16, 0.12, 0.08), 0.88)
	mat_chain = _mat(Color(0.18, 0.18, 0.19), 0.55)
	mat_chain.metallic = 0.6
	mat_reed_dry = _mat(Color(0.52, 0.44, 0.26), 0.95)
	mat_reed_pale = _mat(Color(0.58, 0.52, 0.34), 0.95)
	mat_stone_ancient = _mat(Color(0.36, 0.35, 0.32), 0.92)
	mat_rune = _mat(Color(0.30, 0.34, 0.30), 0.92)
	mat_rune.emission_enabled = true
	mat_rune.emission = Color(0.35, 0.5, 0.4)
	mat_rune.emission_energy_multiplier = 0.25

func _mat(color: Color, roughness: float) -> StandardMaterial3D:
	var m: StandardMaterial3D = StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = roughness
	return m

func _box(parent: Node3D, bb_name: String, pos: Vector3, size: Vector3, material: Material, rot_deg: Vector3 = Vector3.ZERO) -> MeshInstance3D:
	var mesh: BoxMesh = BoxMesh.new()
	mesh.size = size
	var mi: MeshInstance3D = MeshInstance3D.new()
	mi.name = bb_name
	mi.mesh = mesh
	mi.material_override = material
	mi.position = pos
	mi.rotation_degrees = rot_deg
	parent.add_child(mi)
	return mi

func _build_boardwalk(parent: Node3D) -> void:
	var bw: Node3D = Node3D.new()
	bw.name = "Boardwalk"
	parent.add_child(bw)

	# Deck planks from z = 22 to z = -22
	var z_start: float = 21.55
	var plank_spacing: float = 0.95
	var plank_count: int = 46
	for i in plank_count:
		var z: float = z_start - float(i) * plank_spacing
		var pm: StandardMaterial3D = mat_plank if i % 2 == 0 else mat_plank_dark
		var rot_x: float = randf_range(-3.0, 3.0)
		var rot_z: float = randf_range(-3.0, 3.0)
		var y_off: float = randf_range(-0.03, 0.03)
		_box(bw, "Plank_%02d" % i, Vector3(0, 0.55 + y_off, z), Vector3(2.2, 0.08, 0.9), pm, Vector3(rot_x, 0, rot_z))

	# Support piles every ~2 m under the deck
	var zp: float = 21.0
	while zp >= -21.0:
		_box(bw, "Pile_%.0f" % zp, Vector3(0, 0.20, zp), Vector3(0.16, 0.7, 0.16), mat_plank_dark)
		_box(bw, "Lath_%.0f" % zp, Vector3(0, 0.46, zp), Vector3(2.4, 0.06, 0.08), mat_plank_dark)
		zp -= 2.0

	# Edge posts every ~4 m
	var post_zs: Array[float] = []
	var zpost: float = 20.0
	while zpost >= -20.0:
		post_zs.append(zpost)
		for sx in [-1.1, 1.1]:
			_box(bw, "Post_%.1f_%.0f" % [sx, zpost], Vector3(sx, 1.0, zpost), Vector3(0.12, 0.9, 0.12), mat_plank_dark)
		zpost -= 4.0

	# Sagging chains between adjacent posts
	for i in range(post_zs.size() - 1):
		var za: float = post_zs[i]
		var zb: float = post_zs[i + 1]
		var span: float = abs(zb - za)
		var seg_count: int = 3 if span < 4.5 else 4
		for sx in [-1.1, 1.1]:
			for j in range(seg_count):
				var t_ratio: float = float(j + 1) / float(seg_count + 1)
				var chain_z: float = lerp(za, zb, t_ratio)
				# Parabolic sag 0.35 m at midpoint
				var sag: float = -0.35 * sin(PI * t_ratio)
				var angle_deg: float = rad_to_deg(atan(-0.35 * PI * cos(PI * t_ratio) / span))
				_box(bw, "Chain_%.0f_%.0f_%d" % [za, zb, j], Vector3(sx, 1.35 + sag, chain_z), Vector3(0.05, 0.18, 0.05), mat_chain, Vector3(angle_deg, 0, 0))

func _build_cracked_flats(parent: Node3D) -> void:
	var cf: Node3D = Node3D.new()
	cf.name = "CrackedFlats"
	parent.add_child(cf)

	# Solid dark mud base underneath everything
	_box(cf, "MudBase", Vector3(0, -0.02, 0), Vector3(40, 0.04, 50), mat_mud_dark)

	# 9 cracked mud plates on both sides of the boardwalk
	var plates: Array = [
		[-6.0, 18.0, 4.2, 4.5, 12.0],
		[5.5, 15.0, 3.8, 4.0, -25.0],
		[-5.0, 10.0, 4.8, 3.5, 45.0],
		[6.0, 6.0, 3.5, 4.5, 8.0],
		[-7.0, 3.0, 4.5, 4.0, -35.0],
		[5.0, -2.0, 4.0, 5.0, 60.0],
		[-6.5, -6.0, 5.0, 4.0, -15.0],
		[6.5, -10.0, 3.5, 4.5, 30.0],
		[-5.0, -14.0, 4.0, 4.0, -50.0],
	]
	for d in plates:
		var x: float = d[0] as float
		var pz: float = d[1] as float
		var sx: float = d[2] as float
		var sz: float = d[3] as float
		var ry: float = d[4] as float
		_box(cf, "Plate_%.0f_%.0f" % [x, pz], Vector3(x, 0.06, pz), Vector3(sx, 0.12, sz), mat_cracked_mud, Vector3(0, ry, 0))

func _build_still_pools(parent: Node3D) -> void:
	var sp: Node3D = Node3D.new()
	sp.name = "StillPools"
	parent.add_child(sp)

	var pools: Array = [
		[3.5, 16.0, 4.0, 5.0],
		[-3.0, 9.0, 3.0, 4.0],
		[4.0, -2.0, 4.0, 5.0],
		[-3.5, -10.0, 3.0, 4.0],
	]
	for d in pools:
		var x: float = d[0] as float
		var pz: float = d[1] as float
		var sx: float = d[2] as float
		var sz: float = d[3] as float
		_box(sp, "Pool_%.0f_%.0f" % [x, pz], Vector3(x, 0.09, pz), Vector3(sx, 0.03, sz), mat_black_water)

func _build_dry_reeds(parent: Node3D) -> void:
	var dr: Node3D = Node3D.new()
	dr.name = "DryReeds"
	parent.add_child(dr)

	var clusters: Array = [
		Vector3(4.8, 0, 17.5),
		Vector3(2.2, 0, 14.5),
		Vector3(-4.5, 0, 10.5),
		Vector3(-1.8, 0, 8.0),
		Vector3(5.5, 0, -1.0),
		Vector3(2.8, 0, -3.5),
		Vector3(-5.0, 0, -9.0),
	]
	for c_idx in clusters.size():
		var base: Vector3 = clusters[c_idx]
		var stem_count: int = randi_range(6, 9)
		for s_idx in stem_count:
			var spread: float = 0.6
			var x_off: float = randf_range(-spread, spread)
			var z_off: float = randf_range(-spread, spread)
			var height: float = randf_range(1.4, 1.9)
			var tilt_x: float = randf_range(-8.0, 8.0)
			var tilt_z: float = randf_range(-8.0, 8.0)
			var rm: StandardMaterial3D = mat_reed_dry if s_idx % 2 == 0 else mat_reed_pale
			_box(dr, "Reed_%02d_%02d" % [c_idx, s_idx], base + Vector3(x_off, height * 0.5, z_off), Vector3(0.04, height, 0.04), rm, Vector3(tilt_x, 0, tilt_z))

func _build_menhirs(parent: Node3D) -> void:
	var mh: Node3D = Node3D.new()
	mh.name = "Menhirs"
	parent.add_child(mh)

	# 1 — Large menhir with rune panel
	var m1: Node3D = Node3D.new()
	m1.name = "LargeMenhir"
	m1.position = Vector3(-3.5, 0, 8)
	m1.rotation_degrees = Vector3(0, 0, 4)
	mh.add_child(m1)
	_box(m1, "StoneBody", Vector3.ZERO, Vector3(0.9, 3.4, 0.7), mat_stone_ancient)
	_box(m1, "RunePanel", Vector3(0.46, -0.2, 0), Vector3(0.06, 1.2, 0.5), mat_rune)

	# 2 — Medium menhir, tilted the other way
	var m2: Node3D = Node3D.new()
	m2.name = "MediumMenhir"
	m2.position = Vector3(4, 0, -6)
	m2.rotation_degrees = Vector3(0, 0, -7)
	mh.add_child(m2)
	_box(m2, "StoneBody", Vector3.ZERO, Vector3(0.7, 2.6, 0.6), mat_stone_ancient)
	_box(m2, "RunePanel", Vector3(0.36, -0.1, 0), Vector3(0.05, 0.8, 0.35), mat_rune)

	# 3 — Fallen menhir (lying on its side)
	var m3: Node3D = Node3D.new()
	m3.name = "FallenMenhir"
	m3.position = Vector3(-4, 0.3, -14)
	m3.rotation_degrees = Vector3(90, 20, 0)
	mh.add_child(m3)
	_box(m3, "StoneBody", Vector3.ZERO, Vector3(0.6, 0.6, 2.8), mat_stone_ancient)

	# Debris chunks near the fallen menhir
	var r1x: float = randf_range(-30, 30)
	var r1y: float = randf_range(-30, 30)
	var r1z: float = randf_range(-30, 30)
	_box(mh, "Debris_01", Vector3(-3.4, 0.08, -13.2), Vector3(0.35, 0.2, 0.3), mat_stone_ancient,
			Vector3(r1x, r1y, r1z))
	var r2x: float = randf_range(-30, 30)
	var r2y: float = randf_range(-30, 30)
	var r2z: float = randf_range(-30, 30)
	_box(mh, "Debris_02", Vector3(-4.6, 0.06, -15.0), Vector3(0.25, 0.15, 0.4), mat_stone_ancient,
			Vector3(r2x, r2y, r2z))

func _build_fallen_columns(parent: Node3D) -> void:
	var fc: Node3D = Node3D.new()
	fc.name = "FallenColumns"
	parent.add_child(fc)

	_box(fc, "ColumnLeft", Vector3(-7, 0.25, 12), Vector3(0.5, 0.5, 2.2), mat_stone_ancient, Vector3(0, 0, 25))
	_box(fc, "ColumnRight", Vector3(7, 0.25, -15), Vector3(0.5, 0.5, 2.2), mat_stone_ancient, Vector3(0, 0, -35))
	_box(fc, "Chip_01", Vector3(-7.3, 0.06, 11.5), Vector3(0.2, 0.12, 0.2), mat_stone_ancient)
	_box(fc, "Chip_02", Vector3(7.3, 0.06, -14.3), Vector3(0.25, 0.1, 0.25), mat_stone_ancient)
