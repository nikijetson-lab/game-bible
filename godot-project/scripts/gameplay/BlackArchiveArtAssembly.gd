extends Node3D

# Black Archive — spiral stairs, cold wet stone, peat+mint, single candle, scrolls
const TEX_BEAMS := "res://assets/textures/greyford_tavern/soot_beams.png"

var mat_stone: StandardMaterial3D
var mat_chamber: StandardMaterial3D
var mat_candle: StandardMaterial3D
var mat_flame: StandardMaterial3D

func _ready() -> void:
	_create_materials()
	_build_archive()

func _create_materials() -> void:
	mat_stone = _mat(Color(0.15, 0.16, 0.17), "", 0.88)
	mat_chamber = _mat(Color(0.08, 0.09, 0.10), "", 0.92)
	mat_candle = _mat(Color(0.85, 0.78, 0.55), "", 0.85)
	mat_flame = _mat(Color(1, 0.5, 0.15), "", 0.5)
	mat_flame.emission_enabled = true; mat_flame.emission = Color(0.9, 0.4, 0.08)
	mat_flame.emission_energy_multiplier = 2.0

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

func _build_archive() -> void:
	var arch := Node3D.new(); arch.name = "BlackArchiveChamber"; add_child(arch)
	_box(arch, "OuterShell", Vector3(0, 1.8, 0), Vector3(6, 3.5, 6), mat_stone)
	_box(arch, "InnerChamber", Vector3(0, 1.75, 0), Vector3(5.5, 3.2, 5.5), mat_chamber)
	# Stone table
	_box(arch, "StoneTable", Vector3(0, 0.7, 0), Vector3(1.8, 0.3, 1.2), mat_stone)
	# Candle
	_box(arch, "Candle", Vector3(0.6, 1.0, 0), Vector3(0.05, 0.3, 0.05), mat_candle)
	_box(arch, "Flame", Vector3(0.6, 1.2, 0), Vector3(0.06, 0.06, 0.06), mat_flame)
	# Shelves
	for i in range(4):
		_box(arch, "Shelf%d"%i, Vector3(2, 1.1 + i*0.5, 2.5), Vector3(1.5, 0.06, 0.25), mat_stone)
	# Spiral stairs
	_box(arch, "Stair1", Vector3(-2, 0.15, -2), Vector3(0.8, 0.15, 0.8), mat_stone)
	_box(arch, "Stair2", Vector3(-2, 0.5, -1.5), Vector3(0.8, 0.15, 0.8), mat_stone)
	_box(arch, "Stair3", Vector3(-1.5, 0.85, -1), Vector3(0.8, 0.15, 0.8), mat_stone)
