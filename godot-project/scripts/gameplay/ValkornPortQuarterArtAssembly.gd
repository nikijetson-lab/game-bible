extends Node3D

# Valkorn Port Quarter — docks, inn, wide cobbled streets, sea wind atmosphere
const TEX_WOOD := "res://assets/textures/greyford_tavern/dark_wood_planks.png"
const TEX_FLOOR := "res://assets/textures/greyford_tavern/wet_floor_planks.png"
const TEX_BEAMS := "res://assets/textures/greyford_tavern/soot_beams.png"
const TEX_CRATE := "res://assets/textures/greyford_tavern/crate_boards.png"

var mat_wood: StandardMaterial3D
var mat_floor: StandardMaterial3D
var mat_stone: StandardMaterial3D
var mat_beam: StandardMaterial3D
var mat_crate: StandardMaterial3D
var mat_metal: StandardMaterial3D
var mat_warm: StandardMaterial3D
var mat_cobble: StandardMaterial3D

func _ready() -> void:
	_create_materials()
	_build_docks()
	_build_inn()
	_build_streets()

func _create_materials() -> void:
	mat_wood = _mat(Color(0.22, 0.15, 0.09), TEX_WOOD, 0.9)
	mat_floor = _mat(Color(0.18, 0.12, 0.08), TEX_FLOOR, 0.88)
	mat_stone = _mat(Color(0.33, 0.35, 0.36), "", 0.85)
	mat_beam = _mat(Color(0.12, 0.09, 0.07), TEX_BEAMS, 0.96)
	mat_crate = _mat(Color(0.44, 0.27, 0.14), TEX_CRATE, 0.9)
	mat_metal = _mat(Color(0.24, 0.22, 0.18), "", 0.55); mat_metal.metallic = 0.45
	mat_warm = _mat(Color(0.95, 0.50, 0.15), "", 0.55)
	mat_warm.emission_enabled = true; mat_warm.emission = Color(0.85, 0.38, 0.08)
	mat_warm.emission_energy_multiplier = 1.8
	mat_cobble = _mat(Color(0.32, 0.33, 0.34), "", 0.92)

func _mat(color: Color, tex_path: String, roughness: float) -> StandardMaterial3D:
	var m := StandardMaterial3D.new(); m.albedo_color = color; m.roughness = roughness
	m.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
	if tex_path != "":
		var tex := load(tex_path)
		if tex is Texture2D: m.albedo_texture = tex
	return m

func _box(p: Node3D, nm: String, pos: Vector3, sz: Vector3, mat: Material) -> void:
	var m := BoxMesh.new(); m.size = sz; var mi := MeshInstance3D.new()
	mi.name = nm; mi.mesh = m; mi.material_override = mat
	mi.position = pos; p.add_child(mi)

func _cyl(p: Node3D, nm: String, pos: Vector3, r: float, h: float, mat: Material) -> void:
	var m := CylinderMesh.new(); m.top_radius = r; m.bottom_radius = r
	m.height = h; m.radial_segments = 18; var mi := MeshInstance3D.new()
	mi.name = nm; mi.mesh = m; mi.material_override = mat
	mi.position = pos; p.add_child(mi)

func _build_docks() -> void:
	var d := Node3D.new(); d.name = "Docks"; d.position = Vector3(0, 0, 5); add_child(d)
	_box(d, "PierPlatform", Vector3(0, 0, 0), Vector3(12, 0.4, 6), mat_floor)
	for x in [-4, -1.5, 1.5, 4]:
		_cyl(d, "StonePillar", Vector3(x, -0.8, 2), 0.25, 2.5, mat_stone)
	for z in [-1.5, 1.5]:
		_cyl(d, "MooringPost", Vector3(5, 0.8, z), 0.08, 1.5, mat_beam)
		_cyl(d, "MooringPost", Vector3(-5, 0.8, z), 0.08, 1.5, mat_beam)
	for i in range(8):
		_box(d, "Crate%d"%i, Vector3(randf_range(-3, 3), 0.45, randf_range(-1, 1)), Vector3(0.6, 0.5, 0.6), mat_crate)

func _build_inn() -> void:
	var inn := Node3D.new(); inn.name = "Inn"; inn.position = Vector3(4.5, 0, -3); add_child(inn)
	_box(inn, "InnBody", Vector3(0, 1.8, 0), Vector3(5, 3.5, 4), mat_wood)
	_box(inn, "InnSign", Vector3(0, 2.8, 2.1), Vector3(2.2, 0.4, 0.1), mat_beam)
	_box(inn, "WarmWindowL", Vector3(-1.5, 1.8, 1.95), Vector3(1, 0.8, 0.05), mat_warm)
	_box(inn, "WarmWindowR", Vector3(1.5, 1.8, 1.95), Vector3(1, 0.8, 0.05), mat_warm)
	_box(inn, "DoorLantern", Vector3(1.8, 1.5, 2.0), Vector3(0.12, 0.3, 0.12), mat_warm)

func _build_streets() -> void:
	var st := Node3D.new(); st.name = "Streets"; st.position = Vector3(0, 0, -4); add_child(st)
	_box(st, "CobbledStreet", Vector3(0, -0.15, 0), Vector3(10, 0.1, 8), mat_cobble)
	for i in range(4):
		var z := -3.0 + i*2.0
		_box(st, "LampPostL%d"%i, Vector3(3.5, 1.1, z), Vector3(0.06, 2, 0.06), mat_metal)
		_box(st, "LampGlowL%d"%i, Vector3(3.5, 2.2, z), Vector3(0.2, 0.2, 0.2), mat_warm)
		_box(st, "LampPostR%d"%i, Vector3(-3.5, 1.1, z), Vector3(0.06, 2, 0.06), mat_metal)
		_box(st, "LampGlowR%d"%i, Vector3(-3.5, 2.2, z), Vector3(0.2, 0.2, 0.2), mat_warm)
	_box(st, "BenchL", Vector3(2, 0.25, 0), Vector3(1.5, 0.12, 0.4), mat_wood)
	_box(st, "BenchR", Vector3(-2, 0.25, 2), Vector3(1.5, 0.12, 0.4), mat_wood)
