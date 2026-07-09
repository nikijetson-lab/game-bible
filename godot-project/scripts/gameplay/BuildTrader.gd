extends "res://scripts/gameplay/BuildWaitress.gd"
func _ready() -> void:
	build(0.80,0.62,0.45, 0.18,0.10,0.05, 0.30,0.22,0.12, 0.30,0.22,0.12, 0,0,0)
	# капюшон замість волосся
	var hood := MeshInstance3D.new()
	var m := BoxMesh.new(); m.size = Vector3(0.26,0.28,0.24)
	var mat := StandardMaterial3D.new(); mat.albedo_color = Color(0.30,0.22,0.12); mat.roughness = 0.85
	m.material = mat; hood.mesh = m; hood.position = Vector3(0,1.62,-0.02); add_child(hood)
