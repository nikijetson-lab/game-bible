extends Node3D
# HazemoorSwampPathArtAssembly — болотяна стежка до Хейзмуру.
# Туман, мертві верби, попереджувальні кілки, сині вогники.

func _ready() -> void:
	var mud := _mat(Color(0.08,0.07,0.05), 0.96)
	var bark := _mat(Color(0.10,0.08,0.06), 0.94)
	var bone := _mat(Color(0.55,0.50,0.42), 0.85)
	var wisp := _mat(Color(0.1,0.3,0.7), 0.1)
	wisp.emission_enabled=true; wisp.emission=Color(0.05,0.2,0.6); wisp.emission_energy_multiplier=2.5
	var fog_mat := _mat(Color(0.06,0.08,0.06,0.10), 0.01)
	var stone_dark := _mat(Color(0.14,0.13,0.12), 0.92)
	
	var root := Node3D.new(); root.name = "HazemoorDressing"; add_child(root)
	
	# === БАГНИСТА СТЕЖКА ===
	var path := _box(Vector3(3,0.05,30), mud)
	path.position = Vector3(0,0.02,-5); root.add_child(path)
	
	# === МЕРТВІ ДЕРЕВА (скручені стовбури) ===
	for i in 8:
		var tx := -10+randf()*20; var tz := -15+randf()*30
		var trunk := _cyl(0.12+randf()*0.1, 3+randf()*3, bark)
		trunk.position = Vector3(tx,1.5, tz); trunk.rotation_degrees.z = -20+randf()*40; trunk.rotation_degrees.x = -10+randf()*20
		root.add_child(trunk)
		# Гілки
		for j in 3:
			var branch := _cyl(0.03, 1.0+randf()*1.5, bark)
			branch.position = trunk.position+Vector3((randf()-0.5)*2, 1+randf()*2, (randf()-0.5)*2)
			branch.rotation_degrees = Vector3(randf()*60-30, randf()*60-30, randf()*60-30)
			root.add_child(branch)
	
	# === ПОПЕРЕДЖУВАЛЬНІ КІЛКИ З ЧЕРЕПАМИ ===
	for i in 6:
		var stake := _cyl(0.04,1.5, bark)
		stake.position = Vector3(-6+randf()*12, 0.75, -12+randf()*24); root.add_child(stake)
		var skull := _box(Vector3(0.1,0.12,0.1), bone)
		skull.position = Vector3(-6+randf()*12, 1.6, -12+randf()*24); root.add_child(skull)
	
	# === СИНІ ВОГНИКИ (will-o'-wisps) ===
	for i in 5:
		var w := _cyl(0.06,0.15, wisp)
		w.position = Vector3(-8+randf()*16, 1+randf()*3, -10+randf()*20); root.add_child(w)
		var wl := _omni(Color(0.1,0.3,0.8), 0.8, 5.0)
		wl.position = w.position; root.add_child(wl)
	
	# === ТУМАН ===
	for i in 12:
		var fog := _box(Vector3(3+randf()*3, 1.2, 0.02), fog_mat)
		fog.position = Vector3(-12+randf()*24, 0.6+randf()*2, -15+randf()*30); root.add_child(fog)
	
	# === КАМІННЯ ===
	for i in 10:
		var stone := _box(Vector3(0.2+randf()*0.3, 0.15+randf()*0.2, 0.2+randf()*0.3), stone_dark)
		stone.position = Vector3(-5+randf()*10, 0.08, -15+randf()*30); root.add_child(stone)

func _mat(c: Color, r: float, _em:=false, _met:=0.0) -> StandardMaterial3D:
	var m := StandardMaterial3D.new(); m.albedo_color = c; m.roughness = r; m.metallic = _met; return m
func _box(size: Vector3, mat: Material) -> MeshInstance3D:
	var mi := MeshInstance3D.new(); var m := BoxMesh.new(); m.size = size; m.material = mat; mi.mesh = m; return mi
func _cyl(r: float, h: float, mat: Material) -> MeshInstance3D:
	var mi := MeshInstance3D.new(); var m := CylinderMesh.new(); m.top_radius = r; m.bottom_radius = r; m.height = h; m.material = mat; mi.mesh = m; return mi
func _omni(col: Color, energy: float, range: float) -> OmniLight3D:
	var l := OmniLight3D.new(); l.light_color = col; l.light_energy = energy; l.omni_range = range; return l
