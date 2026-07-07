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

# Runtime visual assembly for the port tavern decoration.
# Adds fishing nets, wall charts, bar dressing, stools, and a sleeping patron.
# Does NOT create or modify any lights/environment.
# Does NOT hide any existing scene nodes — adds only the "PortArtDressing" subtree.

var mat_net: StandardMaterial3D
var mat_cork: StandardMaterial3D
var mat_paper: StandardMaterial3D
var mat_dark_wood: StandardMaterial3D
var mat_stool: StandardMaterial3D
var mat_lamp_glass: StandardMaterial3D
var mat_bottle_green: StandardMaterial3D
var mat_cloth: StandardMaterial3D

func _ready() -> void:
	_create_materials()
	_build_fishing_nets()
	_build_wall_charts()
	_build_bar_dressing()
	_build_stools()
	_build_sleeping_patron()

func _create_materials() -> void:
	mat_net = _mat(Color(0.25, 0.28, 0.24), "", 0.95)
	mat_cork = _mat(Color(0.55, 0.42, 0.28), "", 0.9)
	mat_paper = _mat(Color(0.62, 0.58, 0.48), "", 0.85)
	mat_dark_wood = _mat(Color(0.16, 0.11, 0.07), "", 0.9)
	mat_stool = _mat(Color(0.22, 0.15, 0.09), "", 0.9)
	mat_lamp_glass = _mat(Color(0.95, 0.62, 0.28, 0.75), "", 0.72)
	mat_lamp_glass.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat_lamp_glass.emission_enabled = true
	mat_lamp_glass.emission = Color(0.95, 0.5, 0.15)
	mat_lamp_glass.emission_energy_multiplier = 1.2
	mat_bottle_green = _mat(Color(0.18, 0.32, 0.22, 0.85), "", 0.65)
	mat_bottle_green.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat_cloth = _mat(Color(0.45, 0.42, 0.36), "", 0.95)

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

func _build_fishing_nets() -> void:
	var nets := Node3D.new()
	nets.name = "FishingNets"
	add_child(nets)

	var net_rots := [12.0, -8.0]
	for i in range(2):
		var net_panel := _box(nets, "NetPanel_%s" % i, \
			Vector3(-6.85, 1.7 + i * -0.2, -1.8 + i * 3.4), \
			Vector3(2.2, 1.6, 0.04), mat_net, Vector3(0, 0, net_rots[i]))
		var cork_count := 4 + i
		for j in range(cork_count):
			var cx := lerpf(-0.85, 0.85, float(j) / float(cork_count - 1)) if cork_count > 1 else 0.0
			var cy := 0.6 + fmod(float(j) * 0.4, 0.8)
			_box(net_panel, "CorkFloat_%s_%s" % [i, j], \
				Vector3(cx, cy, 0.02), Vector3(0.07, 0.07, 0.07), mat_cork)

func _build_wall_charts() -> void:
	var charts := Node3D.new()
	charts.name = "WallCharts"
	add_child(charts)

	var positions := [
		Vector3(-6.88, 2.0, -3.5),
		Vector3(-6.88, 1.6, 0.8),
		Vector3(1.5, 1.8, -4.95),
		Vector3(-2.0, 2.05, -4.95)
	]
	for i in range(positions.size()):
		_box(charts, "WallChart_%s" % i, positions[i], \
			Vector3(0.7, 0.5, 0.02), mat_paper)

func _build_bar_dressing() -> void:
	var dressing := Node3D.new()
	dressing.name = "BarDressing"
	add_child(dressing)

	# Kerosene lamp on the right side of the bar counter (x = 2.2)
	var lamp := Node3D.new()
	lamp.name = "KeroseneLamp"
	lamp.position = Vector3(2.2, 1.05, -3.5)
	dressing.add_child(lamp)

	_box(lamp, "LampBase", Vector3(0, -0.06, 0), Vector3(0.12, 0.08, 0.12), mat_dark_wood)
	_box(lamp, "LampGlass", Vector3(0, 0.05, 0), Vector3(0.16, 0.22, 0.16), mat_lamp_glass)

	# 3 green bottles on the shelf behind the bar
	for i in range(3):
		var bx := -1.0 + float(i) * 0.5
		_box(dressing, "Bottle_%s" % i, Vector3(bx, 1.3, -4.3), \
			Vector3(0.12, 0.4, 0.12), mat_bottle_green)

	# Folded cloth on the bar
	_box(dressing, "FoldedCloth", Vector3(0.5, 1.07, -3.5), \
		Vector3(0.3, 0.04, 0.2), mat_cloth)

func _build_stools() -> void:
	var stools := Node3D.new()
	stools.name = "BarStools"
	add_child(stools)

	for i in range(4):
		var sx := -2.4 + float(i) * 1.6
		var stool := Node3D.new()
		stool.name = "Stool_%s" % i
		stool.position = Vector3(sx, 0, -2.7)
		stools.add_child(stool)

		# Seat
		_box(stool, "Seat", Vector3(0, 0.48, 0), Vector3(0.38, 0.06, 0.38), mat_stool)
		# 4 legs
		for leg_x in [-0.14, 0.14]:
			for leg_z in [-0.14, 0.14]:
				_box(stool, "Leg_%.0f_%.0f" % [leg_x * 100, leg_z * 100], \
					Vector3(leg_x, 0.225, leg_z), Vector3(0.05, 0.45, 0.05), mat_stool)

func _build_sleeping_patron() -> void:
	var patron := Node3D.new()
	patron.name = "SleepingPatron"
	patron.position = Vector3(2.6, 0, -3.2)
	add_child(patron)

	# Torso leaning onto the bar counter
	_box(patron, "Torso", Vector3(0, 0.6, 0.15), \
		Vector3(0.5, 0.35, 0.3), mat_cloth, Vector3(15, 0, 0))

	# Head as a sphere
	var head_mesh := SphereMesh.new()
	head_mesh.radius = 0.11
	head_mesh.height = 0.22
	head_mesh.radial_segments = 16
	head_mesh.rings = 12
	var head := MeshInstance3D.new()
	head.name = "Head"
	head.mesh = head_mesh
	head.material_override = mat_cloth
	head.position = Vector3(0, 0.9, 0.22)
	patron.add_child(head)

	# Folded arms resting on the bar surface
	_box(patron, "LeftArm", Vector3(-0.18, 0.45, 0.35), \
		Vector3(0.08, 0.28, 0.22), mat_cloth, Vector3(0, 0, 20))
	_box(patron, "RightArm", Vector3(0.18, 0.45, 0.35), \
		Vector3(0.08, 0.28, 0.22), mat_cloth, Vector3(0, 0, -20))

func _box(parent: Node3D, name: String, pos: Vector3, size: Vector3, \
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
