extends Node3D

# Undercity — ancient stone chambers under Valkorn, empty pedestal, runes, fabric scrap
const TEX_BEAMS := "res://assets/textures/greyford_tavern/soot_beams.png"

var mat_stone: StandardMaterial3D
var mat_floor: StandardMaterial3D
var mat_rune: StandardMaterial3D
var mat_cloth: StandardMaterial3D

func _ready() -> void:
	_create_materials()
	_build_chamber()

func _create_materials() -> void:
	mat_stone = _mat(Color(0.22, 0.23, 0.24), "", 0.88)
	mat_floor = _mat(Color(0.16, 0.17, 0.18), "", 0.92)
	mat_rune = _mat(Color(0.3, 0.5, 0.7), "", 0.5)
	mat_rune.emission_enabled = true; mat_rune.emission = Color(0.2, 0.4, 0.6)
	mat_rune.emission_energy_multiplier = 1.2
	mat_cloth = _mat(Color(0.12, 0.15, 0.22), "", 0.95)

func _mat(color: Color, tex_path: String, roughness: float) -> StandardMaterial3D:
	var m := StandardMaterial3D.new(); m.albedo_color = color; m.roughness = roughness
	if tex_path != "":
		var tex := load(tex_path)
		if tex is Texture2D: m.albedo_texture = tex
	return m

func _box(p: Node3D, nm: String, pos: Vector3, sz: Vector3, mat: Material) -> void:
	var m := BoxMesh.new(); m.size = sz; var mi := MeshInstance3D.new()
	mi.name = nm; mi.mesh = m; mi.material_override = mat
	mi.position = pos; p.add_child(mi)

func _build_chamber() -> void:
	var chamber := Node3D.new(); chamber.name = "UndercityChamber"; add_child(chamber)
	_box(chamber, "Floor", Vector3(0, -0.1, 0), Vector3(10, 0.2, 7), mat_floor)
	_box(chamber, "BackWall", Vector3(0, 1.5, -3.5), Vector3(10, 3, 0.5), mat_stone)
	_box(chamber, "FrontWall", Vector3(0, 1.5, 3.5), Vector3(10, 3, 0.5), mat_stone)
	_box(chamber, "LeftWall", Vector3(-5, 1.5, 0), Vector3(0.5, 3, 6), mat_stone)
	_box(chamber, "RightWall", Vector3(5, 1.5, 0), Vector3(0.5, 3, 6), mat_stone)
	# Empty pedestal — artifact already taken
	_box(chamber, "PedestalBase", Vector3(0, 0.6, -1), Vector3(0.8, 1.2, 0.8), mat_stone)
	_box(chamber, "PedestalTop", Vector3(0, 1.2, -1), Vector3(0.6, 0.08, 0.6), mat_stone)
	# Fabric scrap
	_box(chamber, "FabricScrap", Vector3(1.2, 0.1, -1.5), Vector3(0.3, 0.02, 0.4), mat_cloth)
	# Ancient runes
	for i in range(4):
		_box(chamber, "Rune%d"%i, Vector3(-4.7, 0.7 + i*0.7, -2), Vector3(0.08, 0.3, 0.05), mat_rune)
