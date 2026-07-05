extends Node3D
## GuildWarehouseArtAssembly — Trade Guild warehouse interior, crates, shelves

@export var build_on_ready: bool = true

func _ready() -> void:
	if build_on_ready:
		await get_tree().process_frame
		build_warehouse()

func build_warehouse() -> void:
	var n := Node3D.new(); n.name = "Architecture"; add_child(n); var p = n
	var wood := Color(0.2, 0.12, 0.06, 1)
	# Walls
	_box(p, Vector3(8, 3.5, 0.3), Vector3(0, 1.8, -4), wood)
	_box(p, Vector3(8, 3.5, 0.3), Vector3(0, 1.8, 4), wood)
	_box(p, Vector3(0.3, 3.5, 8), Vector3(-4, 1.8, 0), wood)
	_box(p, Vector3(0.3, 3.5, 8), Vector3(4, 1.8, 0), wood)
	# Floor
	_box(p, Vector3(8, 0.1, 8), Vector3(0, -0.05, 0), Color(0.15, 0.09, 0.05, 1))
	# Shelves
	for row in range(3):
		var z := -2.5 + row * 2.5
		_box(p, Vector3(3, 2.5, 0.15), Vector3(2, 1.3, z), wood)
		for shelf in range(3):
			_box(p, Vector3(2.8, 0.05, 0.3), Vector3(2, 0.7 + shelf * 0.8, z), Color(0.25, 0.15, 0.08, 1))
	# Crates
	for i in range(5):
		_box(p, Vector3(0.5, 0.5, 0.5), Vector3(randf_range(-2.5, 2.5), 0.25, randf_range(-2, 2)), Color(0.35, 0.22, 0.12, 1))

func _box(parent: Node3D, size: Vector3, pos: Vector3, color: Color) -> void:
	var mi := MeshInstance3D.new(); var mat := StandardMaterial3D.new()
	mat.albedo_color = color; mat.roughness = 0.9
	var bm := BoxMesh.new(); bm.size = size; bm.material = mat
	mi.mesh = bm; mi.position = pos; parent.add_child(mi)
