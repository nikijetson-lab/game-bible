extends Node3D

# GuildWarehouse / SaltWarehouse / FloodedChamber / FloodedChapel — shared assembly
const TEX_WOOD := "res://assets/textures/greyford_tavern/dark_wood_planks.png"
const TEX_BEAMS := "res://assets/textures/greyford_tavern/soot_beams.png"
const TEX_CRATE := "res://assets/textures/greyford_tavern/crate_boards.png"

@export var variant: String = "warehouse"

var mat_wood: StandardMaterial3D
var mat_beam: StandardMaterial3D
var mat_stone: StandardMaterial3D
var mat_crate: StandardMaterial3D
var mat_floor: StandardMaterial3D
var mat_water: StandardMaterial3D
var mat_salt: StandardMaterial3D
var mat_altar: StandardMaterial3D

func _ready() -> void:
	_create_materials()
	match variant:
		"warehouse": _build_warehouse()
		"salt": _build_salt()
		"chamber": _build_chamber()
		"chapel": _build_chapel()

func _create_materials() -> void:
	mat_wood = _mat(Color(0.22, 0.15, 0.09), TEX_WOOD, 0.9)
	mat_beam = _mat(Color(0.12, 0.09, 0.07), TEX_BEAMS, 0.96)
	mat_stone = _mat(Color(0.28, 0.30, 0.31), "", 0.85)
	mat_crate = _mat(Color(0.44, 0.27, 0.14), TEX_CRATE, 0.9)
	mat_floor = _mat(Color(0.15, 0.09, 0.05), "", 0.9)
	mat_water = _mat(Color(0.03, 0.05, 0.06), "", 0.3); mat_water.metallic = 0.2
	mat_salt = _mat(Color(0.7, 0.68, 0.6), "", 0.88)
	mat_altar = _mat(Color(0.35, 0.36, 0.37), "", 0.85)

func _mat(color: Color, tex_path: String, roughness: float) -> StandardMaterial3D:
	var m := StandardMaterial3D.new(); m.albedo_color = color; m.roughness = roughness
	m.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
	if tex_path != "":
		var tex := load(tex_path)
		if tex is Texture2D: m.albedo_texture = tex
	return m

func _box(p: Node3D, nm: String, pos: Vector3, sz: Vector3, mat: Material) -> void:
	var m := BoxMesh.new(); m.size = sz; var mi := MeshInstance3D.new()
	mi.name = nm; mi.mesh = m; mi.material_override = mat; mi.position = pos; p.add_child(mi)

func _build_warehouse() -> void:
	var wh := Node3D.new(); wh.name = "GuildWarehouse"; add_child(wh)
	_box(wh, "Floor", Vector3(0, -0.05, 0), Vector3(8, 0.1, 8), mat_floor)
	_box(wh, "WallN", Vector3(0, 1.8, -4), Vector3(8, 3.5, 0.3), mat_wood)
	_box(wh, "WallS", Vector3(0, 1.8, 4), Vector3(8, 3.5, 0.3), mat_wood)
	_box(wh, "WallW", Vector3(-4, 1.8, 0), Vector3(0.3, 3.5, 8), mat_wood)
	_box(wh, "WallE", Vector3(4, 1.8, 0), Vector3(0.3, 3.5, 8), mat_wood)
	for row in range(3):
		var z := -2.5 + row*2.5
		_box(wh, "Shelf%d"%row, Vector3(2, 1.3, z), Vector3(3, 2.5, 0.15), mat_wood)
	for i in range(6):
		_box(wh, "Crate%d"%i, Vector3(randf_range(-2.5, 2.5), 0.25, randf_range(-2, 2)), Vector3(0.5, 0.5, 0.5), mat_crate)

func _build_salt() -> void:
	var sw := Node3D.new(); sw.name = "SaltWarehouse"; add_child(sw)
	_box(sw, "Floor", Vector3(0, -0.05, 0), Vector3(6, 0.1, 6), mat_floor)
	_box(sw, "WallN", Vector3(0, 1.5, -3), Vector3(6, 3, 0.3), mat_wood)
	_box(sw, "WallS", Vector3(0, 1.5, 3), Vector3(6, 3, 0.3), mat_wood)
	_box(sw, "WallW", Vector3(-3, 1.5, 0), Vector3(0.3, 3, 6), mat_wood)
	_box(sw, "WallE", Vector3(3, 1.5, 0), Vector3(0.3, 3, 6), mat_wood)
	for i in range(6):
		_box(sw, "SaltPile%d"%i, Vector3(randf_range(-2, 2), 0.25, randf_range(-2, 2)), Vector3(0.5, 0.5, 0.5), mat_salt)

func _build_chamber() -> void:
	var fc := Node3D.new(); fc.name = "FloodedChamber"; add_child(fc)
	_box(fc, "Floor", Vector3(0, -1.1, 0), Vector3(8, 0.1, 8), mat_floor)
	_box(fc, "WallN", Vector3(0, 0.5, -4), Vector3(8, 3, 0.4), mat_stone)
	_box(fc, "WallS", Vector3(0, 0.5, 4), Vector3(8, 3, 0.4), mat_stone)
	_box(fc, "WallW", Vector3(-4, 0.5, 0), Vector3(0.4, 3, 7), mat_stone)
	_box(fc, "WallE", Vector3(4, 0.5, 0), Vector3(0.4, 3, 7), mat_stone)
	_box(fc, "FloodWater", Vector3(0, -0.7, 0), Vector3(7, 0.15, 7), mat_water)

func _build_chapel() -> void:
	var ch := Node3D.new(); ch.name = "FloodedChapel"; add_child(ch)
	_box(ch, "Floor", Vector3(0, -0.1, 0), Vector3(5, 0.1, 6), mat_stone)
	_box(ch, "WallN", Vector3(0, 1.8, -3.5), Vector3(5, 3.5, 0.3), mat_stone)
	_box(ch, "WallS", Vector3(0, 1.8, 3.5), Vector3(5, 3.5, 0.3), mat_stone)
	_box(ch, "WallW", Vector3(-2.5, 1.8, 0), Vector3(0.3, 3.5, 6), mat_stone)
	_box(ch, "WallE", Vector3(2.5, 1.8, 0), Vector3(0.3, 3.5, 6), mat_stone)
	_box(ch, "VaultedCeiling", Vector3(0, 3.6, 0), Vector3(5, 4, 5), mat_stone)
	_box(ch, "Altar", Vector3(0, 0.6, 3), Vector3(1.2, 0.3, 0.8), mat_altar)
	_box(ch, "CrossV", Vector3(0, 1.5, 3.2), Vector3(0.06, 1.2, 0.06), mat_beam)
	_box(ch, "CrossH", Vector3(0, 2.0, 3.2), Vector3(0.4, 0.06, 0.06), mat_beam)
