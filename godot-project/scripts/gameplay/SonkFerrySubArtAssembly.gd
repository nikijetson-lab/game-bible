extends Node3D
## Simple structured art for salt warehouse, flooded chamber, flooded chapel

@export var build_on_ready: bool = true
@export var variant: String = "salt"

func _ready() -> void:
	if build_on_ready:
		await get_tree().process_frame
		match variant:
			"salt": _build_salt()
			"chamber": _build_chamber()
			"chapel": _build_chapel()

func _box(parent: Node3D, size: Vector3, pos: Vector3, color: Color) -> void:
	var mi := MeshInstance3D.new(); var mat := StandardMaterial3D.new()
	mat.albedo_color = color; mat.roughness = 0.9
	var bm := BoxMesh.new(); bm.size = size; bm.material = mat
	mi.mesh = bm; mi.position = pos; parent.add_child(mi)

func _build_salt() -> void:
	var n := Node3D.new(); n.name = "Architecture"; add_child(n)
	var wood := Color(0.22, 0.13, 0.07, 1)
	_box(n, Vector3(6, 3, 0.3), Vector3(0, 1.5, -3), wood)
	_box(n, Vector3(6, 3, 0.3), Vector3(0, 1.5, 3), wood)
	_box(n, Vector3(0.3, 3, 6), Vector3(-3, 1.5, 0), wood)
	_box(n, Vector3(0.3, 3, 6), Vector3(3, 1.5, 0), wood)
	_box(n, Vector3(6, 0.1, 6), Vector3(0, -0.05, 0), Color(0.15, 0.09, 0.05, 1))
	for i in range(6):
		_box(n, Vector3(0.5, 0.5, 0.5), Vector3(randf_range(-2, 2), 0.25, randf_range(-2, 2)), Color(0.7, 0.68, 0.6, 1))

func _build_chamber() -> void:
	var n := Node3D.new(); n.name = "Architecture"; add_child(n)
	var stone := Color(0.25, 0.26, 0.27, 1)
	_box(n, Vector3(8, 3, 0.4), Vector3(0, 0.5, -4), stone)
	_box(n, Vector3(8, 3, 0.4), Vector3(0, 0.5, 4), stone)
	_box(n, Vector3(0.4, 3, 7), Vector3(-4, 0.5, 0), stone)
	_box(n, Vector3(0.4, 3, 7), Vector3(4, 0.5, 0), stone)
	_box(n, Vector3(8, 0.1, 8), Vector3(0, -1.1, 0), Color(0.1, 0.11, 0.12, 1))
	# Water on floor
	_box(n, Vector3(7, 0.15, 7), Vector3(0, -0.8, 0), Color(0.03, 0.05, 0.06, 1))

func _build_chapel() -> void:
	var n := Node3D.new(); n.name = "Architecture"; add_child(n)
	var stone := Color(0.3, 0.31, 0.33, 1)
	_box(n, Vector3(5, 3.5, 0.3), Vector3(0, 1.8, -3.5), stone)
	_box(n, Vector3(5, 3.5, 0.3), Vector3(0, 1.8, 3.5), stone)
	_box(n, Vector3(0.3, 3.5, 6), Vector3(-2.5, 1.8, 0), stone)
	_box(n, Vector3(0.3, 3.5, 6), Vector3(2.5, 1.8, 0), stone)
	_box(n, Vector3(5, 4, 5), Vector3(0, 3.6, 0), Color(0.15, 0.16, 0.18, 1))
	# Altar
	_box(n, Vector3(1.2, 0.3, 0.8), Vector3(0, 0.6, 3), Color(0.35, 0.36, 0.37, 1))
	# Cross
	_box(n, Vector3(0.06, 1.2, 0.06), Vector3(0, 1.5, 3.2), Color(0.25, 0.2, 0.15, 1))
	_box(n, Vector3(0.4, 0.06, 0.06), Vector3(0, 2.0, 3.2), Color(0.25, 0.2, 0.15, 1))
