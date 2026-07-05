extends Node3D

# ForbiddenGlade — sacred Tykhy Shelest glade with dark water, wisps, bonfire, totem
const TEX_WOOD := "res://assets/textures/greyford_tavern/dark_wood_planks.png"
const TEX_FLOOR := "res://assets/textures/greyford_tavern/wet_floor_planks.png"
const TEX_BEAMS := "res://assets/textures/greyford_tavern/soot_beams.png"

var mat_wood: StandardMaterial3D
var mat_beam: StandardMaterial3D
var mat_water: StandardMaterial3D
var mat_fire: StandardMaterial3D
var mat_wisp: StandardMaterial3D
var mat_reed: StandardMaterial3D
var mat_totem: StandardMaterial3D
var mat_figure: StandardMaterial3D

func _ready() -> void:
	_create_materials()
	_build_central_platform()
	_build_sacred_water()
	_build_wisps()
	_build_reeds()

func _create_materials() -> void:
	mat_wood = _mat(Color(0.22, 0.15, 0.09), TEX_WOOD, 0.9)
	mat_beam = _mat(Color(0.12, 0.09, 0.07), TEX_BEAMS, 0.96)
	mat_water = _mat(Color(0.02, 0.06, 0.04), "", 0.25); mat_water.metallic = 0.2
	mat_fire = _mat(Color(1, 0.35, 0.06), "", 0.5)
	mat_fire.emission_enabled = true; mat_fire.emission = Color(1, 0.3, 0.05)
	mat_fire.emission_energy_multiplier = 3.0
	mat_wisp = _mat(Color(0.2, 0.8, 0.3), "", 0.3)
	mat_wisp.emission_enabled = true; mat_wisp.emission = Color(0.15, 0.7, 0.2)
	mat_wisp.emission_energy_multiplier = 2.5
	mat_reed = _mat(Color(0.15, 0.25, 0.1), "", 0.92)
	mat_totem = _mat(Color(0.18, 0.10, 0.05), TEX_WOOD, 0.9)
	mat_figure = _mat(Color(0.15, 0.10, 0.06), "", 0.92)

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

func _sphere(p: Node3D, nm: String, pos: Vector3, r: float, mat: Material) -> void:
	var m := SphereMesh.new(); m.radius = r; m.height = r*2; var mi := MeshInstance3D.new()
	mi.name = nm; mi.mesh = m; mi.material_override = mat
	mi.position = pos; p.add_child(mi)

func _build_central_platform() -> void:
	var plat := Node3D.new(); plat.name = "CentralPlatform"; add_child(plat)
	_box(plat, "PlatformFloor", Vector3(0, 0.2, 0), Vector3(6, 0.3, 6), mat_wood)
	# Totem pole
	for i in range(5):
		var y := 1.2 + i*0.85
		_box(plat, "TotemSeg%d"%i, Vector3(0, y, 0), Vector3(0.27, 0.82, 0.27), mat_totem)
	# Bonfire
	for r in [0.35, 0.22, 0.14]:
		_sphere(plat, "BonfireGlow", Vector3(0, 0.6, 1.5), r, mat_fire)
	# Figures around fire
	for a in range(6):
		var ang := float(a) * PI / 3
		var x := sin(ang) * 1.6
		var z := cos(ang) * 1.6 + 1.2
		_box(plat, "Figure%d"%a, Vector3(x, 0.55, z), Vector3(0.2, 0.8, 0.2), mat_figure)

func _build_sacred_water() -> void:
	var water := Node3D.new(); water.name = "SacredWater"; add_child(water)
	_box(water, "DarkPool", Vector3(0, -0.5, -2), Vector3(8, 0.1, 6), mat_water)
	for i in range(10):
		var ang := float(i)/10.0*PI*2
		var x := sin(ang)*4.5; var z := cos(ang)*3.5-2
		_box(water, "WarningStake%d"%i, Vector3(x, 0.2, z), Vector3(0.06, 1.2, 0.06), mat_beam)

func _build_wisps() -> void:
	var wisps := Node3D.new(); wisps.name = "Wisps"; add_child(wisps)
	for i in range(15):
		var x := randf_range(-5, 5); var z := randf_range(-6, 3)
		var y := randf_range(0.3, 1.8)
		_sphere(wisps, "Wisp%d"%i, Vector3(x, y, z), 0.06 + randf()*0.08, mat_wisp)

func _build_reeds() -> void:
	var reeds := Node3D.new(); reeds.name = "Reeds"; add_child(reeds)
	for i in range(30):
		_box(reeds, "Reed%d"%i, Vector3(randf_range(-6, 6), 0.3, randf_range(-7, 3)),
			Vector3(0.04, 0.4 + randf()*0.9, 0.04), mat_reed)
