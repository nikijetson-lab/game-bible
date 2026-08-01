extends Node3D
# TykhyShelistArtAssembly — повне поселення за картою
# 7 районів: Центр, Північ(Варрік), Захід(Каен), Схід(Причал), Південь(СвятіВоди), ПдСхід(Рибалка), Периметр(Очерет)

const HUT_GLB := "res://assets/meshy/tykhy_shelist/stilt_hut.glb"
const WALKWAY_GLB := "res://assets/meshy/tykhy_shelist/walkway.glb"
const BOAT_GLB := "res://assets/meshy/tykhy_shelist/boat.glb"
const TEX_WOOD := "res://assets/textures/greyford_tavern/dark_wood_planks.png"
const TEX_THATCH := "res://assets/textures/greyford_tavern/dark_wood_planks.png"
const TEX_BARK := "res://assets/textures/greyford_tavern/soot_beams.png"

func _ready() -> void:
	var root: Node3D = Node3D.new(); root.name = "TykhyDressing"; add_child(root)
	
	# МАТЕРІАЛИ
	var wood: StandardMaterial3D = _mat(Color(0.18, 0.12, 0.06), TEX_WOOD, 0.88)
	var dark_wood: StandardMaterial3D = _mat(Color(0.10, 0.07, 0.04), TEX_BARK, 0.92)
	var thatch: StandardMaterial3D = _mat(Color(0.12, 0.18, 0.06), TEX_THATCH, 0.95)
	var fire_emit: StandardMaterial3D = _emit(Color(1.0, 0.35, 0.06), 1.5)
	var wisp_mat: StandardMaterial3D = _emit(Color(0.1, 0.8, 0.3), 2.5)
	
	# GLB моделі
	var hut_scene: PackedScene = load(HUT_GLB) as PackedScene if ResourceLoader.exists(HUT_GLB) else null
	var walkway_scene: PackedScene = load(WALKWAY_GLB) as PackedScene if ResourceLoader.exists(WALKWAY_GLB) else null
	var boat_scene: PackedScene = load(BOAT_GLB) as PackedScene if ResourceLoader.exists(BOAT_GLB) else null
	
	# ==================== ВОДА ====================
	var water_mat: StandardMaterial3D = StandardMaterial3D.new()
	water_mat.albedo_color = Color(0.015, 0.04, 0.05, 1)
	water_mat.roughness = 0.03; water_mat.metallic = 0.3
	var pool: MeshInstance3D = _box(Vector3(40, 0.06, 40), water_mat)
	pool.position = Vector3(0, -0.12, 0)
	root.add_child(pool)
	
	# ==================== ЦЕНТРАЛЬНА ПЛАТФОРМА ====================
	_platform(root, "CentralPlatform", Vector3(0, 2.5, 0), 8, 8, wood, 4)
	# Тотем
	_totem(root, Vector3(1.5, 2.5, 2.0), dark_wood)
	_totem(root, Vector3(-1.5, 2.5, -2.0), dark_wood)
	
	# ==================== ПІВНІЧ — ВЕЖА ВАРРІКА ====================
	_tower(root, "VarrikTower", Vector3(0, 2.5, -12), wood, dark_wood, fire_emit)
	_bridge(root, Vector3(0, 2.6, -4), Vector3(0, 2.6, -8), wood, dark_wood, walkway_scene)
	# Шкури на просушці
	_rack(root, Vector3(-1.5, 3.5, -12), dark_wood)
	_rack(root, Vector3(1.5, 3.5, -12), dark_wood)
	
	# ==================== ЗАХІД — ЛІКАРСЬКИЙ ДІМ КАЕНА ====================
	_hut_node(root, "KaenHouse", Vector3(-12, 2.5, 0), hut_scene, fire_emit)
	_bridge(root, Vector3(-4, 2.6, 0), Vector3(-8, 2.6, 0), wood, dark_wood, walkway_scene)
	# Трави
	for i: int in 6:
		var herb: MeshInstance3D = _cyl(0.06, 0.4 + randf() * 0.3, thatch)
		herb.position = Vector3(-11 + randf() * 3, 3.3, -1 + randf() * 2)
		root.add_child(herb)
	
	# ==================== СХІД — ТОРГОВИЙ ПРИЧАЛ (єдиний вхід) ====================
	_pier(root, "TradingPier", Vector3(12, 2.3, 0), wood, dark_wood, 6.0)
	_bridge(root, Vector3(4, 2.6, 0), Vector3(8, 2.6, 0), wood, dark_wood, walkway_scene)
	# Човни біля причалу
	for i: int in 3:
		if boat_scene:
			var boat: Node3D = boat_scene.instantiate() as Node3D
			boat.position = Vector3(14 + i * 2, 0.1, 2 + i * 1.5)
			boat.rotation_degrees = Vector3(0, -30 + i * 15, 0)
			boat.scale = Vector3(0.7, 0.7, 0.7)
			root.add_child(boat)
	
	# ==================== ПІВДЕНЬ — СВЯЩЕННІ ВОДИ ====================
	# Огороджена зона з водою всередині
	_fence_ring(root, Vector3(0, 2.5, 10), 3.5, dark_wood)
	# Вода всередині
	var sacred_water: MeshInstance3D = _box(Vector3(6, 0.04, 6), water_mat)
	sacred_water.position = Vector3(0, 2.65, 10)
	root.add_child(sacred_water)
	# Знаки «не ходити»
	_sign_post(root, Vector3(0, 3.5, 8), dark_wood)
	
	# ==================== ПдСХІД — РИБАЛЬСЬКИЙ РАЙОН / МАТИ МІА ====================
	_platform(root, "FishingPlatform", Vector3(8, 2.5, 10), 5, 3, wood, 2)
	_hut_node(root, "MiaMotherHut", Vector3(8, 2.5, 12), hut_scene, fire_emit)
	# Сітки
	for i: int in 3:
		var net: MeshInstance3D = _box(Vector3(1.5, 1.0, 0.05), thatch)
		net.position = Vector3(6 + i * 1.2, 3.0, 9)
		root.add_child(net)
	# Місток до центру
	_bridge(root, Vector3(4, 2.6, 5), Vector3(6, 2.6, 8), wood, dark_wood, walkway_scene)
	
	# ==================== ДІМ МІА ====================
	_hut_node(root, "MiaHouse", Vector3(-6, 2.5, 6), hut_scene, fire_emit)
	_bridge(root, Vector3(-2, 2.6, 3), Vector3(-5, 2.6, 5), wood, dark_wood, walkway_scene)
	
	# ==================== ПЕРИМЕТР — СТІНА З ОЧЕРЕТУ ====================
	for i: int in 60:
		var angle: float = deg_to_rad(i * 6.0)
		var rx: float = cos(angle) * 16.0
		var rz: float = sin(angle) * 17.0
		# Не ставити очерет там де причал (схід)
		if abs(angle - 0) < 0.6: continue
		var reed_h: float = 1.5 + randf() * 2.5
		var reed: MeshInstance3D = _cyl(0.03, reed_h, thatch)
		reed.position = Vector3(rx, reed_h * 0.5 - 0.1, rz)
		root.add_child(reed)
	
	# ==================== ЗЕЛЕНІ ВОГНІ ЗОВНІ ====================
	for i: int in 12:
		var angle: float = deg_to_rad(i * 30.0 + 15)
		var gx: float = cos(angle) * 19.0
		var gz: float = sin(angle) * 20.0
		var wisp: MeshInstance3D = _box(Vector3(0.15, 0.15, 0.15), wisp_mat)
		wisp.position = Vector3(gx, 0.5, gz)
		root.add_child(wisp)
		var wl: OmniLight3D = OmniLight3D.new()
		wl.light_color = Color(0.1, 0.6, 0.3); wl.light_energy = 1.2; wl.omni_range = 5.0
		wl.position = Vector3(gx, 0.5, gz)
		root.add_child(wl)

# ==================== ХЕЛПЕРИ ====================

func _platform(parent: Node3D, name: String, pos: Vector3, w: float, d: float, mat: Material, pile_count: int) -> void:
	var g: Node3D = Node3D.new(); g.name = name; parent.add_child(g)
	# Палі по кутах
	for dx in [-w * 0.4, w * 0.4]:
		for dz in [-d * 0.4, d * 0.4]:
			var pile: MeshInstance3D = _cyl(0.12, 2.5, mat)
			pile.position = Vector3(pos.x + dx, 1.25, pos.z + dz)
			g.add_child(pile)
	# Настил
	var deck: MeshInstance3D = _box(Vector3(w, 0.1, d), mat)
	deck.position = Vector3(pos.x, pos.y + 0.05, pos.z)
	g.add_child(deck)

func _bridge(parent: Node3D, from_pos: Vector3, to_pos: Vector3, wood_mat: Material, dark_mat: Material, walkway_scene: PackedScene) -> void:
	if walkway_scene:
		var mid: Vector3 = (from_pos + to_pos) * 0.5
		var dist: float = from_pos.distance_to(to_pos)
		var walk: Node3D = walkway_scene.instantiate() as Node3D
		walk.position = mid
		walk.scale = Vector3(dist * 0.3, 0.8, 1.0)
		# Без look_at — використовуємо тільки позицію
		parent.add_child(walk)
	else:
		# Fallback: прості дошки
		var mid: Vector3 = (from_pos + to_pos) * 0.5
		var dist: float = from_pos.distance_to(to_pos)
		var plank: MeshInstance3D = _box(Vector3(dist, 0.06, 0.6), wood_mat)
		plank.position = mid
		plank.look_at(to_pos, Vector3.UP)
		parent.add_child(plank)

func _tower(parent: Node3D, name: String, pos: Vector3, wood_mat: Material, dark_mat: Material, fire_mat: Material) -> void:
	var g: Node3D = Node3D.new(); g.name = name; parent.add_child(g)
	# 4 опори
	for dx in [-1.2, 1.2]:
		for dz in [-1.2, 1.2]:
			var pile: MeshInstance3D = _cyl(0.15, 5.5, dark_mat)
			pile.position = Vector3(pos.x + dx, 2.75, pos.z + dz)
			g.add_child(pile)
	# Платформа
	var deck: MeshInstance3D = _box(Vector3(3, 0.12, 3), wood_mat)
	deck.position = Vector3(pos.x, pos.y + 2.8, pos.z)
	g.add_child(deck)
	# Стіни вежі
	var walls: MeshInstance3D = _box(Vector3(2.5, 3.0, 2.5), wood_mat)
	walls.position = Vector3(pos.x, pos.y + 4.5, pos.z)
	g.add_child(walls)
	# Вогні на вежі
	var flare: MeshInstance3D = _box(Vector3(0.3, 0.3, 0.3), fire_mat)
	flare.position = Vector3(pos.x, pos.y + 6.2, pos.z)
	g.add_child(flare)

func _hut_node(parent: Node3D, name: String, pos: Vector3, hut_scene: PackedScene, fire_mat: Material) -> void:
	if hut_scene:
		var hut: Node3D = hut_scene.instantiate() as Node3D
		hut.name = name; hut.position = pos; hut.scale = Vector3(1.2, 1.2, 1.2)
		parent.add_child(hut)
	var fl: OmniLight3D = OmniLight3D.new()
	fl.light_color = Color(1.0, 0.35, 0.08); fl.light_energy = 1.8; fl.omni_range = 4.0
	fl.position = pos + Vector3(0, 1.0, 1.0)
	parent.add_child(fl)

func _pier(parent: Node3D, name: String, pos: Vector3, wood_mat: Material, dark_mat: Material, length: float) -> void:
	var g: Node3D = Node3D.new(); g.name = name; parent.add_child(g)
	# Опори
	for t: float in [0.2, 0.5, 0.8]:
		var px: float = pos.x + t * length
		var pile_l: MeshInstance3D = _cyl(0.1, 2.3, dark_mat)
		pile_l.position = Vector3(px, 1.15, pos.z - 0.7)
		g.add_child(pile_l)
		var pile_r: MeshInstance3D = _cyl(0.1, 2.3, dark_mat)
		pile_r.position = Vector3(px, 1.15, pos.z + 0.7)
		g.add_child(pile_r)
	# Настил
	var deck: MeshInstance3D = _box(Vector3(length * 0.5, 0.08, 1.5), wood_mat)
	deck.position = Vector3(pos.x + length * 0.25, pos.y + 0.04, pos.z)
	g.add_child(deck)
	# Поручні
	var rail_l: MeshInstance3D = _box(Vector3(length * 0.5, 0.05, 0.06), dark_mat)
	rail_l.position = Vector3(pos.x + length * 0.25, pos.y + 0.6, pos.z - 0.7)
	g.add_child(rail_l)
	var rail_r: MeshInstance3D = _box(Vector3(length * 0.5, 0.05, 0.06), dark_mat)
	rail_r.position = Vector3(pos.x + length * 0.25, pos.y + 0.6, pos.z + 0.7)
	g.add_child(rail_r)

func _fence_ring(parent: Node3D, center: Vector3, radius: float, mat: Material) -> void:
	for i: int in 16:
		var angle: float = deg_to_rad(i * 22.5)
		var fx: float = center.x + cos(angle) * radius
		var fz: float = center.z + sin(angle) * radius
		var post: MeshInstance3D = _cyl(0.05, 1.2, mat)
		post.position = Vector3(fx, center.y + 0.6, fz)
		parent.add_child(post)

func _totem(parent: Node3D, pos: Vector3, mat: Material) -> void:
	var pole: MeshInstance3D = _cyl(0.12, 3.0, mat)
	pole.position = pos + Vector3(0, 1.5, 0)
	parent.add_child(pole)
	var head: MeshInstance3D = _box(Vector3(0.4, 0.5, 0.4), mat)
	head.position = pos + Vector3(0, 3.2, 0)
	parent.add_child(head)

func _rack(parent: Node3D, pos: Vector3, mat: Material) -> void:
	var post_l: MeshInstance3D = _cyl(0.04, 1.5, mat)
	post_l.position = pos + Vector3(-0.5, 0.75, 0)
	parent.add_child(post_l)
	var post_r: MeshInstance3D = _cyl(0.04, 1.5, mat)
	post_r.position = pos + Vector3(0.5, 0.75, 0)
	parent.add_child(post_r)
	var bar: MeshInstance3D = _box(Vector3(1.0, 0.04, 0.04), mat)
	bar.position = pos + Vector3(0, 1.5, 0)
	parent.add_child(bar)

func _sign_post(parent: Node3D, pos: Vector3, mat: Material) -> void:
	var post: MeshInstance3D = _cyl(0.04, 1.5, mat)
	post.position = pos + Vector3(0, 0.75, 0)
	parent.add_child(post)
	var sign: MeshInstance3D = _box(Vector3(0.8, 0.3, 0.04), mat)
	sign.position = pos + Vector3(0, 1.4, 0)
	parent.add_child(sign)

# ==================== БАЗОВІ ПРИМІТИВИ ====================

func _mat(color: Color, tex_path: String, roughness: float) -> StandardMaterial3D:
	var m: StandardMaterial3D = StandardMaterial3D.new()
	m.albedo_color = color; m.roughness = roughness
	if tex_path != "":
		var tex: Texture2D = load(tex_path) as Texture2D
		if tex: m.albedo_texture = tex
	return m

func _emit(color: Color, energy: float) -> StandardMaterial3D:
	var m: StandardMaterial3D = StandardMaterial3D.new()
	m.albedo_color = color; m.emission_enabled = true
	m.emission = color; m.emission_energy_multiplier = energy
	return m

func _box(size: Vector3, mat: Material) -> MeshInstance3D:
	var mi: MeshInstance3D = MeshInstance3D.new()
	var m: BoxMesh = BoxMesh.new(); m.size = size; m.material = mat
	mi.mesh = m; return mi

func _cyl(radius: float, height: float, mat: Material) -> MeshInstance3D:
	var mi: MeshInstance3D = MeshInstance3D.new()
	var m: CylinderMesh = CylinderMesh.new()
	m.top_radius = radius; m.bottom_radius = radius
	m.height = height; m.material = mat
	mi.mesh = m; return mi
