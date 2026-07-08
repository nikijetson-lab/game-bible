extends Node3D
# SonkFerryArtAssembly — портове село на палях, річка, човни, туман, ліхтарі.

func _ready() -> void:
	var wood_dock := _mat(Color(0.18,0.14,0.09), 0.88)
	var wood_stilt := _mat(Color(0.12,0.09,0.05), 0.92)
	var stone := _mat(Color(0.22,0.21,0.20), 0.90)
	var roof := _mat(Color(0.08,0.09,0.11), 0.75)
	var river := _mat(Color(0.04,0.08,0.10), 0.05, false, 0.35)
	var lantern_fire := _mat(Color(0.9,0.35,0.06), 0.2)
	lantern_fire.emission_enabled = true; lantern_fire.emission = Color(0.7,0.2,0.03); lantern_fire.emission_energy_multiplier = 1.3
	
	var root := Node3D.new(); root.name = "SonkFerryDressing"; add_child(root)
	
	# === ДОКИ ===
	for i in 4:
		var dock := _box(Vector3(4, 0.15, 6), wood_dock)
		dock.position = Vector3(-12 + i*8, 0.15, 10); root.add_child(dock)
		# Палі
		for j in [-1,1]:
			var stilt := _cyl(0.12, 1.5, wood_stilt)
			stilt.position = Vector3(-12+i*8 + j*1.8, -0.5, 10); root.add_child(stilt)
	
	# === ХАТИНИ НА ПАЛЯХ ===
	for i in 3:
		var x := -8.0 + i*8
		# Стіни
		var hut := _box(Vector3(3, 2.5, 3), wood_dock)
		hut.position = Vector3(x, 2.5, 16); root.add_child(hut)
		# Дах
		var r := _box(Vector3(3.5, 0.3, 3.5), roof)
		r.position = Vector3(x, 3.8, 16); root.add_child(r)
		# Палі під хатою
		for j in [-1,1]:
			for k in [-1,1]:
				var s := _cyl(0.1, 2.3, wood_stilt)
				s.position = Vector3(x+j*1.2, 1.2, 16+k*1.2); root.add_child(s)
		# Ліхтар біля входу
		var l := _cyl(0.05,0.25, lantern_fire)
		l.position = Vector3(x, 2.2, 14.7); root.add_child(l)
		var ll := _omni(Color(1,0.35,0.05), 1.5, 6.0)
		ll.position = Vector3(x, 2.2, 14.7); root.add_child(ll)
	
	# === РІЧКА (водна поверхня) ===
	var water := _box(Vector3(40, 0.05, 8), river)
	water.position = Vector3(0, -0.1, 3); root.add_child(water)
	
	# === ЧОВЕН ===
	var boat_body := _box(Vector3(1.2, 0.3, 3), wood_dock)
	boat_body.position = Vector3(15, 0.3, 5); root.add_child(boat_body)
	
	# === ТУМАН (пластини) ===
	for i in 8:
		var fog := _box(Vector3(4, 1.0, 0.02), _mat(Color(0.08,0.10,0.12,0.12), 0.01))
		fog.position = Vector3(-15+randf()*30, 0.5+randf()*2, -2+randf()*8); root.add_child(fog)

func _mat(c: Color, r: float, _em:=false, _met:=0.0) -> StandardMaterial3D:
	var m := StandardMaterial3D.new(); m.albedo_color = c; m.roughness = r; m.metallic = _met; return m
func _box(size: Vector3, mat: Material) -> MeshInstance3D:
	var mi := MeshInstance3D.new(); var m := BoxMesh.new(); m.size = size; m.material = mat; mi.mesh = m; return mi
func _cyl(r: float, h: float, mat: Material) -> MeshInstance3D:
	var mi := MeshInstance3D.new(); var m := CylinderMesh.new(); m.top_radius = r; m.bottom_radius = r; m.height = h; m.material = mat; mi.mesh = m; return mi
func _omni(col: Color, energy: float, range: float) -> OmniLight3D:
	var l := OmniLight3D.new(); l.light_color = col; l.light_energy = energy; l.omni_range = range; return l
