extends Node3D
## BlackArchiveArtAssembly — spiral stairs, wet cold, peat+mint smell, stone table

@export var build_on_ready: bool = true

func _ready() -> void:
	if build_on_ready:
		await get_tree().process_frame
		build_archive()

func build_archive() -> void:
	var n := Node3D.new(); n.name = "Architecture"; add_child(n); var p = n
	var stone := Color(0.15, 0.16, 0.17, 1)
	# Arched chamber
	_box(p, Vector3(6, 3.5, 6), Vector3(0, 1.8, 0), stone, true)  # shell
	_box(p, Vector3(5.5, 3.2, 5.5), Vector3(0, 1.75, 0), Color(0.08, 0.09, 0.10, 1))
	# Stone table center
	_box(p, Vector3(1.8, 0.3, 1.2), Vector3(0, 0.7, 0), Color(0.2, 0.21, 0.22, 1))
	# Single candle
	_box(p, Vector3(0.05, 0.3, 0.05), Vector3(0.6, 1.0, 0), Color(0.85, 0.78, 0.55, 1))
	_box(p, Vector3(0.06, 0.06, 0.06), Vector3(0.6, 1.2, 0), Color(1, 0.5, 0.15, 1))
	# Shelves with scrolls
	for i in range(4):
		_box(p, Vector3(1.5, 0.06, 0.25), Vector3(2, 1.2 + i * 0.5, 2.5), Color(0.18, 0.11, 0.06, 1))
	# Spiral stairs hint
	_box(p, Vector3(0.8, 0.15, 0.8), Vector3(-2, 0.15, -2), Color(0.13, 0.14, 0.15, 1))
	_box(p, Vector3(0.8, 0.15, 0.8), Vector3(-2, 0.5, -1.5), Color(0.13, 0.14, 0.15, 1))

func _box(parent: Node3D, size: Vector3, pos: Vector3, color: Color, hollow: bool = false) -> void:
	var mi := MeshInstance3D.new(); var mat := StandardMaterial3D.new()
	mat.albedo_color = color; mat.roughness = 0.88
	if hollow: mat.albedo_color = color; pass
	var bm := BoxMesh.new(); bm.size = size; bm.material = mat
	mi.mesh = bm; mi.position = pos; parent.add_child(mi)
