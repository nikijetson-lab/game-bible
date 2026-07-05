extends Node3D
## ValkornPortQuarterArtAssembly — builds port city district
## Docks, inn, wide streets, sea wind, salt smell

@export var build_on_ready: bool = true

func _ready() -> void:
	if build_on_ready:
		await get_tree().process_frame
		build_port()

func build_port() -> void:
	_build_docks()
	_build_inn()
	_build_streets()

func _box(parent: Node3D, size: Vector3, pos: Vector3, color: Color, metal: bool = false) -> void:
	var mi := MeshInstance3D.new()
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = 0.85
	if metal:
		mat.metallic = 0.6
		mat.roughness = 0.5
	var bm := BoxMesh.new()
	bm.size = size
	bm.material = mat
	mi.mesh = bm
	mi.position = pos
	parent.add_child(mi)

func _build_docks() -> void:
	var d := Node3D.new(); d.name = "Docks"; d.position = Vector3(0, 0, 5); add_child(d)
	var wood := Color(0.22, 0.14, 0.08, 1)
	var stone := Color(0.38, 0.40, 0.42, 1)
	# Pier platform
	_box(d, Vector3(12, 0.4, 6), Vector3(0, 0, 0), wood)
	# Stone pillars
	for x in [-4, -1.5, 1.5, 4]:
		_box(d, Vector3(0.5, 2.5, 0.5), Vector3(x, -1, 2), stone)
	# Mooring posts
	for z in [-1.5, 1.5]:
		_box(d, Vector3(0.15, 1.5, 0.15), Vector3(5, 0.8, z), wood)
		_box(d, Vector3(0.15, 1.5, 0.15), Vector3(-5, 0.8, z), wood)
	# Cargo crates
	for i in range(6):
		_box(d, Vector3(0.6, 0.5, 0.6), Vector3(randf_range(-3, 3), 0.45, randf_range(-1, 1)), Color(0.35, 0.22, 0.12, 1))

func _build_inn() -> void:
	var inn := Node3D.new(); inn.name = "Inn"; inn.position = Vector3(4, 0, -2); add_child(inn)
	var inn_color := Color(0.28, 0.18, 0.10, 1)
	# Main building
	_box(inn, Vector3(5, 3.5, 4), Vector3(0, 1.8, 0), inn_color)
	# Sign
	_box(inn, Vector3(2, 0.4, 0.1), Vector3(0, 2.8, 2.1), Color(0.2, 0.1, 0.05, 1))
	# Warm windows
	_box(inn, Vector3(1, 0.8, 0.05), Vector3(-1.5, 1.8, 1.95), Color(0.9, 0.55, 0.2, 1))
	_box(inn, Vector3(1, 0.8, 0.05), Vector3(1.5, 1.8, 1.95), Color(0.9, 0.55, 0.2, 1))
	# Lantern
	_box(inn, Vector3(0.12, 0.3, 0.12), Vector3(1.8, 1.5, 2.0), Color(1, 0.45, 0.15, 1))

func _build_streets() -> void:
	var st := Node3D.new(); st.name = "Streets"; st.position = Vector3(0, 0, -4); add_child(st)
	var cobble := Color(0.32, 0.33, 0.34, 1)
	# Wide street
	_box(st, Vector3(10, 0.1, 8), Vector3(0, -0.15, 0), cobble)
	# Street lamps
	for i in range(4):
		var z := -3.0 + i * 2.0
		_box(st, Vector3(0.06, 2, 0.06), Vector3(3.5, 1.1, z), Color(0.25, 0.25, 0.25, 1), true)
		_box(st, Vector3(0.2, 0.2, 0.2), Vector3(3.5, 2.2, z), Color(1, 0.5, 0.2, 1))
		_box(st, Vector3(0.06, 2, 0.06), Vector3(-3.5, 1.1, z), Color(0.25, 0.25, 0.25, 1), true)
		_box(st, Vector3(0.2, 0.2, 0.2), Vector3(-3.5, 2.2, z), Color(1, 0.5, 0.2, 1))
	# Benches
	_box(st, Vector3(1.5, 0.12, 0.4), Vector3(2, 0.25, 0), Color(0.25, 0.15, 0.08, 1))
	_box(st, Vector3(1.5, 0.12, 0.4), Vector3(-2, 0.25, 2), Color(0.25, 0.15, 0.08, 1))
