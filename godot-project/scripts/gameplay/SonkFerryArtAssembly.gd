extends Node3D
## SonkFerryArtAssembly — builds river town per concept layout
## "Остання Переправа" — North Bank, South Bank, river, ferry, chapel

@export var build_on_ready: bool = true

func _ready() -> void:
	if build_on_ready:
		await get_tree().process_frame
		build_sonk_ferry()

func build_sonk_ferry() -> void:
	var north := _group("NorthBank")
	var south := _group("SouthBank")
	var river := _group("River")
	
	# === NORTH BANK (Верхнє місто) ===
	# Ferry Dock + Tovan Rid
	_build_ferry_dock(north)
	# Trade Square
	_build_trade_square(north)
	# The Bastion (only dry building)
	_build_bastion(north)
	# Chapel of St. Vey
	_build_chapel_st_vey(north)
	
	# === RIVER ===
	_build_river_chain(river)
	
	# === SOUTH BANK (Нижній ярус) ===
	_build_lower_tier(south)
	# Salt Warehouse
	_build_salt_warehouse(south)
	
	# === EAST BANK ===
	var east := _group("EastBank")
	_build_smuggler_landing(east)
	
	# === DISTANT ===
	var distant := _group("Distant")
	_build_flooded_chapel_distant(distant)

func _group(name: String) -> Node3D:
	var n := Node3D.new()
	n.name = name
	add_child(n)
	return n

func _wood_mat(color: Color = Color(0.18, 0.11, 0.055, 1)) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = 0.9
	return m

func _stone_mat() -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = Color(0.33, 0.35, 0.36, 1)
	m.roughness = 0.85
	return m

func _water_mat() -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = Color(0.04, 0.06, 0.08, 1)
	m.metallic = 0.3
	m.roughness = 0.25
	return m

func _box(parent: Node3D, size: Vector3, pos: Vector3, mat: StandardMaterial3D) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	var bm := BoxMesh.new()
	bm.size = size
	bm.material = mat
	mi.mesh = bm
	mi.position = pos
	parent.add_child(mi)
	return mi

func _plank(parent: Node3D, pos: Vector3, rot: float = 0.0, mat_override = null) -> MeshInstance3D:
	var m := mat_override if mat_override else _wood_mat()
	var mi := _box(parent, Vector3(3.0, 0.12, 0.35), pos, m)
	mi.rotation_degrees = Vector3(0, rot, 0)
	return mi

func _stilt(parent: Node3D, pos: Vector3, height: float = 2.0) -> void:
	_box(parent, Vector3(0.2, height, 0.2), pos + Vector3(0, -height/2, 0), _wood_mat(Color(0.12, 0.07, 0.035, 1)))

func _lantern(parent: Node3D, pos: Vector3) -> void:
	var m := StandardMaterial3D.new()
	m.albedo_color = Color(1, 0.52, 0.18, 1)
	m.emission_enabled = true
	m.emission = Color(1, 0.4, 0.12, 1)
	m.emission_energy_multiplier = 1.5
	_box(parent, Vector3(0.15, 0.3, 0.15), pos, m)

# ---- NORTH BANK ----

func _build_ferry_dock(parent: Node3D) -> void:
	var dock := _group("FerryDock")
	dock.position = Vector3(0, 0.35, 12)
	parent.add_child(dock)
	
	# Main dock platform
	_box(dock, Vector3(7, 0.3, 4), Vector3(0, 0, 0), _wood_mat())
	# Dock stilts
	for x in [-2.5, 0, 2.5]:
		for z in [-1.2, 0, 1.2]:
			_stilt(dock, Vector3(x, -1.2, z))
	# Ferry boat
	_box(dock, Vector3(3.5, 0.5, 5.5), Vector3(1.5, -0.2, 0.6), _wood_mat(Color(0.22, 0.14, 0.07, 1)))
	# Iron chain on dock
	var iron := StandardMaterial3D.new()
	iron.albedo_color = Color(0.25, 0.22, 0.2, 1)
	iron.metallic = 0.7
	iron.roughness = 0.5
	_box(dock, Vector3(0.08, 0.08, 3.5), Vector3(2.8, 0.25, 0), iron)
	# Lantern on dock
	_lantern(dock, Vector3(2.5, 0.8, 1.8))
	# Ferry ramp
	_box(dock, Vector3(2, 0.15, 1.5), Vector3(2.5, 0.1, -2.2), _wood_mat())

func _build_trade_square(parent: Node3D) -> void:
	var sq := _group("TradeSquare")
	sq.position = Vector3(-3.5, 0.35, 8)
	parent.add_child(sq)
	
	# Ground
	_box(sq, Vector3(6, 0.1, 5), Vector3(0, -0.05, 0), _wood_mat(Color(0.15, 0.1, 0.06, 1)))
	# Market stalls
	for i in range(3):
		var x := -2.0 + i * 2.0
		_box(sq, Vector3(1.8, 0.08, 1.2), Vector3(x, 0.35, 0), _wood_mat(Color(0.2, 0.12, 0.06, 1)))
		# Awning
		var awning := StandardMaterial3D.new()
		awning.albedo_color = Color(0.35, 0.25, 0.15, 1)
		awning.roughness = 0.95
		_box(sq, Vector3(1.6, 0.04, 1.0), Vector3(x, 0.7, 0.15), awning)
	# Barrels
	for i in range(4):
		_box(sq, Vector3(0.3, 0.5, 0.3), Vector3(-1.5 + i, 0.25, 1.5), _wood_mat(Color(0.4, 0.22, 0.12, 1)))

func _build_bastion(parent: Node3D) -> void:
	var b := _group("Bastion")
	b.position = Vector3(6, 0.35, 7)
	parent.add_child(b)
	
	# Stone fortress - единственная сухая будівля
	var stone := _stone_mat()
	_box(b, Vector3(4, 3.5, 4), Vector3(0, 1.8, 0), stone)
	# Gatehouse
	_box(b, Vector3(1.5, 2.5, 0.8), Vector3(0, 1.3, 2.2), stone)
	# Blue banner (simplified)
	var banner := StandardMaterial3D.new()
	banner.albedo_color = Color(0.15, 0.25, 0.45, 1)
	banner.roughness = 0.9
	_box(b, Vector3(0.08, 1.2, 0.6), Vector3(0, 3.2, 2.0), banner)
	# Lantern at gate
	_lantern(b, Vector3(0, 1.8, 2.5))

func _build_chapel_st_vey(parent: Node3D) -> void:
	var ch := _group("ChapelStVey")
	ch.position = Vector3(3, 0.8, 2)
	parent.add_child(ch)
	
	# Gothic stone church on stilts
	var stone := _stone_mat()
	# Main body
	_box(ch, Vector3(3, 2.8, 5), Vector3(0, 1.5, 0), stone)
	# Steeple
	_box(ch, Vector3(0.5, 2, 0.5), Vector3(0, 3.5, -1.5), stone)
	# Cross on top
	var cross_h := _box(ch, Vector3(0.08, 1, 0.08), Vector3(0, 4.8, -1.5), _wood_mat(Color(0.15, 0.1, 0.05, 1)))
	var cross_bar := _box(ch, Vector3(0.5, 0.08, 0.08), Vector3(0, 4.5, -1.5), _wood_mat(Color(0.15, 0.1, 0.05, 1)))
	# Warm light from windows
	var win_mat := StandardMaterial3D.new()
	win_mat.albedo_color = Color(1, 0.55, 0.25, 1)
	win_mat.emission_enabled = true
	win_mat.emission = Color(0.9, 0.4, 0.15, 1)
	win_mat.emission_energy_multiplier = 2.0
	_box(ch, Vector3(0.8, 1.2, 0.06), Vector3(0, 1.6, 2.35), win_mat)
	_box(ch, Vector3(0.8, 1.2, 0.06), Vector3(0, 1.6, -2.35), win_mat)
	# Stilts
	for x in [-1, 0, 1]:
		for z in [-1.5, 0, 1.5]:
			_stilt(ch, Vector3(x, -1.5, z), 1.8)

# ---- RIVER ----

func _build_river_chain(parent: Node3D) -> void:
	parent.position = Vector3(0, 0, 0)
	
	# Dark water surface
	var water := _water_mat()
	_box(parent, Vector3(20, 0.15, 8), Vector3(0, -0.4, 0), water)
	
	# Stone pillars with campfires
	for i in range(4):
		var x := -6.0 + i * 4.0
		var pillar := _box(parent, Vector3(0.4, 1.5, 0.4), Vector3(x, 0.2, 0), _stone_mat())
		# Fire on top
		var fire := StandardMaterial3D.new()
		fire.albedo_color = Color(1, 0.4, 0.1, 1)
		fire.emission_enabled = true
		fire.emission = Color(1, 0.35, 0.08, 1)
		fire.emission_energy_multiplier = 3.0
		_box(parent, Vector3(0.2, 0.4, 0.2), Vector3(x, 1.2, 0), fire)
	
	# Heavy iron chain blocking river
	var iron := StandardMaterial3D.new()
	iron.albedo_color = Color(0.3, 0.25, 0.22, 1)
	iron.metallic = 0.8
	iron.roughness = 0.4
	for i in range(16):
		var z := -3.5 + i * 0.5
		_box(parent, Vector3(0.06, 0.06, 0.45), Vector3(3.5, 0.0, z), iron)

# ---- SOUTH BANK ----

func _build_lower_tier(parent: Node3D) -> void:
	var lt := _group("LowerTier")
	lt.position = Vector3(0, 0.35, -10)
	parent.add_child(lt)
	
	# Stilt houses (дерев'яні будинки на палях)
	for i in range(5):
		var x := -5.0 + i * 2.5
		var house := _group("StiltHouse%d" % i)
		house.position = Vector3(x, 0, 0)
		lt.add_child(house)
		
		_build_stilt_house(house, randf_range(2.0, 3.5), randf_range(1.8, 2.8))
	
	# Walkway
	_box(lt, Vector3(14, 0.08, 0.8), Vector3(0, 0.15, 1.5), _wood_mat(Color(0.14, 0.08, 0.05, 1)))

func _build_stilt_house(parent: Node3D, width: float, depth: float) -> void:
	var mat := _wood_mat(Color(0.14, 0.08, 0.04, 1))
	# Main body
	_box(parent, Vector3(width, 2.0, depth), Vector3(0, 1.5, 0), mat)
	# Roof (angled simplified)
	var roof := StandardMaterial3D.new()
	roof.albedo_color = Color(0.09, 0.06, 0.03, 1)
	roof.roughness = 0.95
	_box(parent, Vector3(width + 0.4, 0.15, depth + 0.4), Vector3(0, 2.55, 0), roof)
	# Stilts
	_stilt(parent, Vector3(-width/2 + 0.3, -1.2, -depth/2 + 0.3), 1.8)
	_stilt(parent, Vector3(width/2 - 0.3, -1.2, -depth/2 + 0.3), 1.8)
	_stilt(parent, Vector3(-width/2 + 0.3, -1.2, depth/2 - 0.3), 1.8)
	_stilt(parent, Vector3(width/2 - 0.3, -1.2, depth/2 - 0.3), 1.8)

func _build_salt_warehouse(parent: Node3D) -> void:
	var sw := _group("SaltWarehouse")
	sw.position = Vector3(-5, 0.35, -13)
	parent.add_child(sw)
	
	var mat := _wood_mat(Color(0.16, 0.09, 0.05, 1))
	_box(sw, Vector3(5, 3, 4), Vector3(0, 1.6, 0), mat)
	# Roof
	var roof := StandardMaterial3D.new()
	roof.albedo_color = Color(0.1, 0.07, 0.04, 1)
	_box(sw, Vector3(5.4, 0.15, 4.4), Vector3(0, 3.15, 0), roof)
	# Stilts
	for x in [-1.8, 0, 1.8]:
		for z in [-1.2, 1.2]:
			_stilt(sw, Vector3(x, -1.2, z), 2.0)

# ---- EAST BANK ----

func _build_smuggler_landing(parent: Node3D) -> void:
	parent.position = Vector3(9, 0.35, -3)
	
	var mat := _wood_mat(Color(0.13, 0.07, 0.035, 1))
	# Dock
	_box(parent, Vector3(3, 0.2, 2.5), Vector3(0, 0, 0), mat)
	# Small warehouse
	_box(parent, Vector3(2.5, 2, 2), Vector3(1.5, 1.2, 0), mat)
	_lantern(parent, Vector3(2, 0.8, 1))

# ---- DISTANT ----

func _build_flooded_chapel_distant(parent: Node3D) -> void:
	parent.position = Vector3(-8, 0.35, -16)
	
	var stone := _stone_mat()
	# Small isolated chapel
	_box(parent, Vector3(2, 2.2, 3), Vector3(0, 1.2, 0), stone)
	# Cross
	_box(parent, Vector3(0.06, 0.7, 0.06), Vector3(0, 2.8, 0), _wood_mat(Color(0.1, 0.07, 0.03, 1)))
	# Stilts over water
	for x in [-0.6, 0.6]:
		for z in [-0.8, 0.8]:
			_stilt(parent, Vector3(x, -1.2, z), 1.5)
	# Water reflection
	var water := _water_mat()
	_box(parent, Vector3(3.5, 0.08, 4.5), Vector3(0, -0.6, 0), water)
