extends Node3D
## DeepBogArtAssembly — builds Episode 3 bog environment
## Dense fog, black root webs, peat chasms, poison gas, Warden stakes

@export var build_on_ready: bool = true

func _ready() -> void:
	if build_on_ready:
		await get_tree().process_frame
		build_bog()

func build_bog() -> void:
	_build_warden_stakes()
	_build_root_webs()
	_build_peat_chasms()
	_build_poison_gas()

func _box(parent: Node3D, size: Vector3, pos: Vector3, color: Color) -> void:
	var mi := MeshInstance3D.new()
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.roughness = 0.9
	var bm := BoxMesh.new()
	bm.size = size
	bm.material = mat
	mi.mesh = bm
	mi.position = pos
	parent.add_child(mi)

func _build_warden_stakes() -> void:
	var stakes := Node3D.new(); stakes.name = "WardenStakes"; add_child(stakes)
	var wood := Color(0.22, 0.15, 0.07, 1)
	for i in range(10):
		var z := -24.0 + i * 5.0
		var x := sin(float(i) * 0.7) * 2.5
		_box(stakes, Vector3(0.08, 1.6, 0.08), Vector3(x, 0.85, z), wood)
		# Glow on top
		_box(stakes, Vector3(0.12, 0.12, 0.12), Vector3(x, 1.7, z), Color(0.45, 0.5, 0.35, 1))

func _build_root_webs() -> void:
	var roots := Node3D.new(); roots.name = "RootWebs"; add_child(roots)
	var black := Color(0.04, 0.03, 0.02, 1)
	for i in range(8):
		var z := -20.0 + i * 5.0
		# Main root
		_box(roots, Vector3(4, 0.12, 0.12), Vector3(0, 0.3, z), black)
		# Cross roots
		_box(roots, Vector3(0.12, 0.12, 2.5), Vector3(1.5, 0.3, z), black)
		_box(roots, Vector3(0.12, 0.12, 2.5), Vector3(-1.5, 0.3, z), black)
		# Vertical roots
		_box(roots, Vector3(0.08, 1.2, 0.08), Vector3(0.8, 0.8, z), black)
		_box(roots, Vector3(0.08, 1.2, 0.08), Vector3(-0.6, 0.8, z + 1), black)

func _build_peat_chasms() -> void:
	var chasms := Node3D.new(); chasms.name = "PeatChasms"; add_child(chasms)
	var mud := Color(0.06, 0.05, 0.03, 1)
	for i in range(5):
		var z := -18.0 + i * 7.0
		var x := sin(float(i) * 1.3) * 3.0
		_box(chasms, Vector3(3, 0.05, 1.5), Vector3(x, -0.25, z), mud)
		# Dark water at bottom
		_box(chasms, Vector3(2.5, 0.05, 1.2), Vector3(x, -0.35, z), Color(0.02, 0.03, 0.02, 1))

func _build_poison_gas() -> void:
	var gas := Node3D.new(); gas.name = "PoisonGas"; add_child(gas)
	var green := Color(0.3, 0.5, 0.15, 0.45)
	for i in range(6):
		var z := -21.0 + i * 6.0
		var x := cos(float(i) * 1.1) * 2.0
		_box(gas, Vector3(1.5, 0.8, 1.5), Vector3(x, 0.9, z), green)
