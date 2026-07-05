extends Node3D
## ForbiddenGladeArtAssembly — builds sacred glade per Tykhy Shelest layout
## Dark water center, green wisps, central platform, totem, bonfire

@export var build_on_ready: bool = true

func _ready() -> void:
	if build_on_ready:
		await get_tree().process_frame
		build_glade()

func build_glade() -> void:
	# Central platform + totem
	_build_central_platform()
	# Dark sacred water pool
	_build_sacred_water()
	# Green wisp lights
	_build_wisps()
	# Reed border
	_build_reeds()

func _box(parent: Node3D, size: Vector3, pos: Vector3, color: Color, emissive: bool = false) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	var bm := BoxMesh.new()
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = 0.88
	if emissive:
		mat.emission_enabled = true
		mat.emission = color
		mat.emission_energy_multiplier = 2.0
	bm.material = mat
	bm.size = size
	mi.mesh = bm
	mi.position = pos
	parent.add_child(mi)
	return mi

func _sphere(parent: Node3D, radius: float, pos: Vector3, color: Color, emissive: bool = false) -> void:
	var mi := MeshInstance3D.new()
	var sm := SphereMesh.new()
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	if emissive:
		mat.emission_enabled = true
		mat.emission = color
		mat.emission_energy_multiplier = 3.0
	sm.material = mat
	sm.radius = radius
	sm.height = radius * 2
	mi.mesh = sm
	mi.position = pos
	parent.add_child(mi)

func _build_central_platform() -> void:
	var plat := Node3D.new(); plat.name = "CentralPlatform"; add_child(plat)
	# Large wooden platform
	_box(plat, Vector3(6, 0.3, 6), Vector3(0, 0.2, 0), Color(0.22, 0.14, 0.07, 1))
	# Totem pole
	for i in range(4):
		_box(plat, Vector3(0.25, 0.8, 0.25), Vector3(0, 1.2 + i * 0.85, 0), Color(0.18, 0.10, 0.05, 1))
	# Bonfire
	_sphere(plat, 0.35, Vector3(0, 0.6, 1.5), Color(1, 0.35, 0.08, 1), true)
	# Figures around bonfire (simplified)
	for a in range(6):
		var angle := float(a) * PI / 3
		var x := sin(angle) * 1.6
		var z := cos(angle) * 1.6 + 1.2
		_box(plat, Vector3(0.2, 0.8, 0.2), Vector3(x, 0.55, z), Color(0.15, 0.1, 0.06, 1))

func _build_sacred_water() -> void:
	var water := Node3D.new(); water.name = "SacredWater"; add_child(water)
	# Dark pool - "не ходити"
	_box(water, Vector3(8, 0.1, 6), Vector3(0, -0.5, -3), Color(0.02, 0.06, 0.04, 1))
	# Warning stakes
	for i in range(8):
		var angle := float(i) / 8.0 * PI * 2
		var x := sin(angle) * 4.5
		var z := cos(angle) * 3.5 - 2
		_box(water, Vector3(0.06, 1.2, 0.06), Vector3(x, 0.2, z), Color(0.08, 0.05, 0.03, 1))

func _build_wisps() -> void:
	var wisps := Node3D.new(); wisps.name = "Wisps"; add_child(wisps)
	# Green floating lights
	var green := Color(0.2, 0.8, 0.3, 1)
	for i in range(12):
		var x := randf_range(-5, 5)
		var z := randf_range(-6, 4)
		var y := randf_range(0.2, 1.5)
		_sphere(wisps, 0.08 + randf() * 0.06, Vector3(x, y, z), green, true)

func _build_reeds() -> void:
	var reeds := Node3D.new(); reeds.name = "Reeds"; add_child(reeds)
	var reed_color := Color(0.15, 0.25, 0.1, 1)
	for i in range(25):
		var x := randf_range(-6, 6)
		var z := randf_range(-7, 3)
		_box(reeds, Vector3(0.04, 0.5 + randf() * 0.8, 0.04), Vector3(x, 0.3, z), reed_color)
