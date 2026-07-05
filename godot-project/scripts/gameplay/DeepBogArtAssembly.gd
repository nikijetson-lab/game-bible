extends Node3D

# DeepBog — Episode 3: dense fog, root webs, peat chasms, Warden stakes, poison gas
const TEX_WOOD := "res://assets/textures/greyford_tavern/dark_wood_planks.png"
const TEX_BEAMS := "res://assets/textures/greyford_tavern/soot_beams.png"

var mat_wood: StandardMaterial3D
var mat_beam: StandardMaterial3D
var mat_root: StandardMaterial3D
var mat_mud: StandardMaterial3D
var mat_deep_water: StandardMaterial3D
var mat_gas: StandardMaterial3D
var mat_stake_glow: StandardMaterial3D

func _ready() -> void:
	_create_materials()
	_build_warden_stakes()
	_build_root_webs()
	_build_peat_chasms()
	_build_poison_gas()

func _create_materials() -> void:
	mat_wood = _mat(Color(0.22, 0.15, 0.09), TEX_WOOD, 0.9)
	mat_beam = _mat(Color(0.12, 0.09, 0.07), TEX_BEAMS, 0.96)
	mat_root = _mat(Color(0.04, 0.03, 0.02), "", 0.92)
	mat_mud = _mat(Color(0.06, 0.05, 0.03), "", 0.95)
	mat_deep_water = _mat(Color(0.02, 0.03, 0.02), "", 0.3)
	mat_gas = _mat(Color(0.3, 0.5, 0.15, 0.45), "", 0.8)
	mat_gas.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat_gas.albedo_color.a = 0.45
	mat_stake_glow = _mat(Color(0.45, 0.5, 0.35), "", 0.6)
	mat_stake_glow.emission_enabled = true
	mat_stake_glow.emission = Color(0.35, 0.4, 0.25)
	mat_stake_glow.emission_energy_multiplier = 1.5

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

func _build_warden_stakes() -> void:
	var stakes := Node3D.new(); stakes.name = "WardenStakes"; add_child(stakes)
	for i in range(12):
		var z := -24.0 + i*4.5
		var x := sin(float(i)*0.7)*2.8
		_box(stakes, "Stake%d"%i, Vector3(x, 0.85, z), Vector3(0.08, 1.6, 0.08), mat_beam)
		_box(stakes, "Glow%d"%i, Vector3(x, 1.7, z), Vector3(0.12, 0.12, 0.12), mat_stake_glow)

func _build_root_webs() -> void:
	var roots := Node3D.new(); roots.name = "RootWebs"; add_child(roots)
	for i in range(10):
		var z := -20.0 + i*4.0; var x := sin(float(i)*0.9)*2.5
		_box(roots, "RootMain%d"%i, Vector3(x, 0.3, z), Vector3(4.5, 0.12, 0.12), mat_root)
		_box(roots, "RootCross%d"%i, Vector3(x+1.5, 0.3, z), Vector3(0.12, 0.12, 2.8), mat_root)
		_box(roots, "RootV%d"%i, Vector3(x+0.8, 0.8, z), Vector3(0.08, 1.3, 0.08), mat_root)

func _build_peat_chasms() -> void:
	var chasms := Node3D.new(); chasms.name = "PeatChasms"; add_child(chasms)
	for i in range(6):
		var z := -18.0 + i*6.0; var x := sin(float(i)*1.3)*3.2
		_box(chasms, "ChasmMud%d"%i, Vector3(x, -0.25, z), Vector3(3.5, 0.06, 2), mat_mud)
		_box(chasms, "ChasmWater%d"%i, Vector3(x, -0.38, z), Vector3(2.8, 0.06, 1.5), mat_deep_water)

func _build_poison_gas() -> void:
	var gas := Node3D.new(); gas.name = "PoisonGas"; add_child(gas)
	for i in range(8):
		var z := -21.0 + i*5.0; var x := cos(float(i)*1.1)*2.5
		_box(gas, "GasCloud%d"%i, Vector3(x, 0.9, z), Vector3(2, 1.2, 2), mat_gas)
