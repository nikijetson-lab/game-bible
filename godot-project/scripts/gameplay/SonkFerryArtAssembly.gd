extends Node3D

# Sonk-Ferry river town — art-grounded assembly matching concept layout "Остання Переправа"
const TEX_WOOD := "res://assets/textures/greyford_tavern/dark_wood_planks.png"
const TEX_FLOOR := "res://assets/textures/greyford_tavern/wet_floor_planks.png"
const TEX_PLASTER := "res://assets/textures/greyford_tavern/smoked_plaster.png"
const TEX_BEAMS := "res://assets/textures/greyford_tavern/soot_beams.png"
const TEX_BARREL := "res://assets/textures/greyford_tavern/barrel_staves.png"
const TEX_CRATE := "res://assets/textures/greyford_tavern/crate_boards.png"
const TEX_CLOTH := "res://assets/textures/greyford_tavern/dirty_towel_cloth.png"

var mat_wood: StandardMaterial3D
var mat_floor: StandardMaterial3D
var mat_stone: StandardMaterial3D
var mat_beam: StandardMaterial3D
var mat_barrel: StandardMaterial3D
var mat_crate: StandardMaterial3D
var mat_metal: StandardMaterial3D
var mat_warm: StandardMaterial3D
var mat_water: StandardMaterial3D
var mat_banner: StandardMaterial3D
var mat_window_glow: StandardMaterial3D

func _ready() -> void:
	_create_materials()
	_build_north_bank()
	_build_river()
	_build_south_bank()
	_build_east_bank()
	_build_distant_chapel()

func _create_materials() -> void:
	mat_wood = _mat(Color(0.22, 0.15, 0.09), TEX_WOOD, 0.9)
	mat_floor = _mat(Color(0.18, 0.12, 0.08), TEX_FLOOR, 0.88)
	mat_stone = _mat(Color(0.33, 0.35, 0.36), "", 0.85)
	mat_beam = _mat(Color(0.12, 0.09, 0.07), TEX_BEAMS, 0.96)
	mat_barrel = _mat(Color(0.46, 0.26, 0.12), TEX_BARREL, 0.9)
	mat_crate = _mat(Color(0.44, 0.27, 0.14), TEX_CRATE, 0.9)
	mat_metal = _mat(Color(0.24, 0.22, 0.18), "", 0.55)
	mat_metal.metallic = 0.45
	mat_warm = _mat(Color(0.95, 0.52, 0.15), "", 0.55)
	mat_warm.emission_enabled = true
	mat_warm.emission = Color(0.9, 0.4, 0.1)
	mat_warm.emission_energy_multiplier = 1.5
	mat_water = _mat(Color(0.04, 0.06, 0.08), "", 0.3)
	mat_water.metallic = 0.25
	mat_banner = _mat(Color(0.15, 0.25, 0.45), "", 0.9)
	mat_window_glow = _mat(Color(0.9, 0.55, 0.25), "", 0.8)
	mat_window_glow.emission_enabled = true
	mat_window_glow.emission = Color(0.85, 0.4, 0.12)
	mat_window_glow.emission_energy_multiplier = 2.0

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

func _box(p: Node3D, nm: String, pos: Vector3, sz: Vector3, mat: Material, rot: Vector3 = Vector3.ZERO) -> void:
	var m := BoxMesh.new(); m.size = sz; var mi := MeshInstance3D.new()
	mi.name = nm; mi.mesh = m; mi.material_override = mat
	mi.position = pos; mi.rotation_degrees = rot; p.add_child(mi)

func _cyl(p: Node3D, nm: String, pos: Vector3, r: float, h: float, mat: Material) -> void:
	var m := CylinderMesh.new(); m.top_radius = r; m.bottom_radius = r
	m.height = h; m.radial_segments = 18; var mi := MeshInstance3D.new()
	mi.name = nm; mi.mesh = m; mi.material_override = mat
	mi.position = pos; p.add_child(mi)

func _stilt(p: Node3D, pos: Vector3, h: float = 2.0) -> void:
	_box(p, "Stilt", pos + Vector3(0, -h/2, 0), Vector3(0.2, h, 0.2), mat_beam)

# ── NORTH BANK ──

func _build_north_bank() -> void:
	var nb := Node3D.new(); nb.name = "NorthBank"; nb.position = Vector3(0, 0, 10); add_child(nb)
	# --- FERRY DOCK ---
	var dock := Node3D.new(); dock.name = "FerryDock"; dock.position = Vector3(0, 0.35, 3); nb.add_child(dock)
	_box(dock, "DockPlatform", Vector3(0, 0.15, 0), Vector3(7, 0.3, 4), mat_floor)
	for x in [-2.5, 0, 2.5]:
		for z in [-1.2, 0, 1.2]:
			_stilt(dock, Vector3(x, -0.9, z), 1.5)
	_box(dock, "FerryBoat", Vector3(1.5, -0.2, 0.6), Vector3(3.5, 0.5, 5.5), mat_wood)
	_box(dock, "IronChain", Vector3(2.8, 0.25, 0), Vector3(0.08, 0.08, 3.5), mat_metal)
	_box(dock, "DockLantern", Vector3(2.5, 0.8, 1.8), Vector3(0.15, 0.3, 0.15), mat_warm)
	for i in range(3): _cyl(dock, "MooringPost", Vector3(-3 + i*3, 0.8, 1.6), 0.08, 1.4, mat_beam)
	
	# --- BASTION ---
	var b := Node3D.new(); b.name = "Bastion"; b.position = Vector3(5.5, 0, 6); nb.add_child(b)
	_box(b, "FortressBody", Vector3(0, 1.8, 0), Vector3(4, 3.5, 4), mat_stone)
	_box(b, "Gatehouse", Vector3(0, 1.3, 2.2), Vector3(1.5, 2.5, 0.8), mat_stone)
	_box(b, "BlueBanner", Vector3(0, 3.2, 2.0), Vector3(0.08, 1.2, 0.6), mat_banner)
	_box(b, "GateLantern", Vector3(0, 1.8, 2.5), Vector3(0.12, 0.3, 0.12), mat_warm)
	
	# --- CHAPEL OF ST. VEY ---
	var ch := Node3D.new(); ch.name = "ChapelStVey"; ch.position = Vector3(2.5, 0.8, 1.5); nb.add_child(ch)
	_box(ch, "ChapelBody", Vector3(0, 1.5, 0), Vector3(3, 2.8, 5), mat_stone)
	_box(ch, "Steeple", Vector3(0, 3.5, -1.5), Vector3(0.5, 2, 0.5), mat_stone)
	_box(ch, "CrossV", Vector3(0, 4.8, -1.5), Vector3(0.08, 1, 0.08), mat_beam)
	_box(ch, "CrossH", Vector3(0, 4.5, -1.5), Vector3(0.5, 0.08, 0.08), mat_beam)
	_box(ch, "WarmWindowFront", Vector3(0, 1.6, 2.35), Vector3(0.8, 1.2, 0.06), mat_window_glow)
	_box(ch, "WarmWindowBack", Vector3(0, 1.6, -2.35), Vector3(0.8, 1.2, 0.06), mat_window_glow)
	for x in [-1, 0, 1]:
		for z in [-1.5, 0, 1.5]:
			_stilt(ch, Vector3(x, -1.2, z), 1.8)
	
	# --- TRADE SQUARE ---
	var sq := Node3D.new(); sq.name = "TradeSquare"; sq.position = Vector3(-3.5, 0, 7.5); nb.add_child(sq)
	_box(sq, "SquareFloor", Vector3(0, -0.05, 0), Vector3(6, 0.1, 5), mat_floor)
	for i in range(3):
		var x := -2.0 + i*2.0
		_box(sq, "StallTop%d"%i, Vector3(x, 0.35, 0), Vector3(1.8, 0.08, 1.2), mat_wood)
		_box(sq, "Awning%d"%i, Vector3(x, 0.7, 0.15), Vector3(1.6, 0.04, 1.0), mat_crate)
	for i in range(4):
		_cyl(sq, "Barrel%d"%i, Vector3(-1.5 + i, 0.25, 1.5), 0.3, 0.5, mat_barrel)

# ── RIVER ──

func _build_river() -> void:
	var rv := Node3D.new(); rv.name = "River"; add_child(rv)
	_box(rv, "DarkWater", Vector3(0, -0.4, 0), Vector3(20, 0.15, 8), mat_water)
	for i in range(4):
		var x := -6.0 + i*4.0
		_box(rv, "Pillar%d"%i, Vector3(x, 0.2, 0), Vector3(0.4, 1.5, 0.4), mat_stone)
		_box(rv, "Fire%d"%i, Vector3(x, 1.2, 0), Vector3(0.2, 0.4, 0.2), mat_warm)
	for i in range(16):
		_box(rv, "ChainLink%d"%i, Vector3(3.5, 0, -3.5 + i*0.5), Vector3(0.06, 0.06, 0.45), mat_metal)

# ── SOUTH BANK (Lower Tier) ──

func _build_south_bank() -> void:
	var sb := Node3D.new(); sb.name = "SouthBank"; sb.position = Vector3(0, 0.35, -10); add_child(sb)
	for i in range(6):
		var x := -5.5 + i*2.2
		var h := Node3D.new(); h.name = "StiltHouse%d"%i; h.position = Vector3(x, 0, 0); sb.add_child(h)
		_box(h, "HouseBody", Vector3(0, 1.5, 0), Vector3(2, 2.2, 2.5), mat_wood)
		_box(h, "Roof", Vector3(0, 2.65, 0), Vector3(2.4, 0.15, 2.9), mat_beam)
		for cx in [-0.7, 0.7]:
			for cz in [-0.8, 0.8]:
				_stilt(h, Vector3(cx, -1.2, cz), 1.8)
	_box(sb, "Walkway", Vector3(0, 0.15, 2), Vector3(14, 0.08, 0.8), mat_floor)
	
	# Salt Warehouse
	var sw := Node3D.new(); sw.name = "SaltWarehouse"; sw.position = Vector3(6, 0, -3.5); sb.add_child(sw)
	_box(sw, "WarehouseBody", Vector3(0, 1.6, 0), Vector3(5, 3, 4), mat_wood)
	_box(sw, "WarehouseRoof", Vector3(0, 3.15, 0), Vector3(5.4, 0.15, 4.4), mat_beam)
	for x in [-1.8, 0, 1.8]:
		for z in [-1.2, 1.2]:
			_stilt(sw, Vector3(x, -1.2, z), 2.0)

# ── EAST BANK ──

func _build_east_bank() -> void:
	var eb := Node3D.new(); eb.name = "EastBank"; eb.position = Vector3(9, 0.35, -2); add_child(eb)
	_box(eb, "SmugglerDock", Vector3(0, 0, 0), Vector3(3, 0.2, 2.5), mat_floor)
	_box(eb, "SmugglerHut", Vector3(1.5, 1.2, 0), Vector3(2.5, 2, 2), mat_wood)
	_box(eb, "SmugglerLantern", Vector3(2, 0.8, 1), Vector3(0.12, 0.25, 0.12), mat_warm)

# ── DISTANT: FLOODED CHAPEL ──

func _build_distant_chapel() -> void:
	var fc := Node3D.new(); fc.name = "FloodedChapel"; fc.position = Vector3(-9, 0.35, -16); add_child(fc)
	_box(fc, "ChapelBody", Vector3(0, 1.2, 0), Vector3(2, 2.2, 3), mat_stone)
	_box(fc, "CrossV", Vector3(0, 2.8, 0), Vector3(0.06, 0.7, 0.06), mat_beam)
	_box(fc, "CrossH", Vector3(0, 2.8, 0), Vector3(0.35, 0.06, 0.06), mat_beam)
	for x in [-0.6, 0.6]:
		for z in [-0.8, 0.8]:
			_stilt(fc, Vector3(x, -1.2, z), 1.5)
	_box(fc, "ReflectionWater", Vector3(0, -0.6, 0), Vector3(3.5, 0.08, 4.5), mat_water)
