extends Node3D
## ValkornUndercityArtAssembly — ancient stone, dry cold air, empty pedestal

@export var build_on_ready: bool = true

func _ready() -> void:
	if build_on_ready:
		await get_tree().process_frame
		build_undercity()

func build_undercity() -> void:
	# Ancient stone walls
	var stone := Color(0.22, 0.23, 0.24, 1)
	var n := Node3D.new(); n.name = "Architecture"; add_child(n); var p = n
	_box(p, Vector3(10, 3, 0.5), Vector3(0, 1.5, -3.5), stone)
	_box(p, Vector3(10, 3, 0.5), Vector3(0, 1.5, 3.5), stone)
	_box(p, Vector3(0.5, 3, 6), Vector3(-5, 1.5, 0), stone)
	_box(p, Vector3(0.5, 3, 6), Vector3(5, 1.5, 0), stone)
	# Floor
	_box(p, Vector3(10, 0.2, 7), Vector3(0, -0.1, 0), Color(0.18, 0.19, 0.2, 1))
	# Empty pedestal
	_box(p, Vector3(0.8, 1.2, 0.8), Vector3(0, 0.6, -1), Color(0.35, 0.35, 0.36, 1))
	_box(p, Vector3(0.6, 0.08, 0.6), Vector3(0, 1.2, -1), Color(0.28, 0.28, 0.29, 1))
	# Fabric scrap on floor
	_box(p, Vector3(0.3, 0.02, 0.4), Vector3(1.2, 0.1, -1.5), Color(0.12, 0.15, 0.22, 1))
	# Ancient runes on walls (glow)
	var rune := Color(0.3, 0.5, 0.7, 1)
	for i in range(3): _box(p, Vector3(0.08, 0.3, 0.05), Vector3(-4.7, 0.8 + i * 0.8, -1.5), rune)

func _box(parent: Node3D, size: Vector3, pos: Vector3, color: Color) -> void:
	var mi := MeshInstance3D.new(); var mat := StandardMaterial3D.new()
	mat.albedo_color = color; mat.roughness = 0.9
	var bm := BoxMesh.new(); bm.size = size; bm.material = mat
	mi.mesh = bm; mi.position = pos; parent.add_child(mi)
