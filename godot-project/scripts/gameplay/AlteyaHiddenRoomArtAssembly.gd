extends Node3D
# AlteyaHiddenRoom — затоплена кам'яна руїна з колонами, мохом, арками, водяним дзеркалом.
# Референс: Алтея в затопленому храмі з золотим циліндром, мох на колонах, темна вода.

func _ready() -> void:
	var stone_dark := _mat(Color(0.12,0.13,0.14), 0.92)
	var stone_light := _mat(Color(0.20,0.21,0.22), 0.88)
	var moss_green := _mat(Color(0.08,0.16,0.06), 0.70)
	var water := _mat(Color(0.03,0.06,0.08), 0.05, false, 0.4)  # reflective dark pool
	var wood_dark := _mat(Color(0.10,0.07,0.04), 0.95)
	var candle := _mat(Color(0.9,0.45,0.10), 0.3)
	candle.emission_enabled = true; candle.emission = Color(0.7,0.25,0.04); candle.emission_energy_multiplier = 1.2
	var gold_glow := _mat(Color(0.9,0.6,0.05), 0.1, false, 0.8)
	gold_glow.emission_enabled = true; gold_glow.emission = Color(0.8,0.4,0.02); gold_glow.emission_energy_multiplier = 3.0
	
	var root := Node3D.new(); root.name = "AlteyaDressing"; add_child(root)
	
	# === ЗАТОПЛЕНА ПІДЛОГА (темна вода) ===
	var pool := _box(Vector3(7, 0.08, 8), water)
	pool.position = Vector3(0, 0.04, -1); root.add_child(pool)
	
	# === КАМ'ЯНІ КОЛОНИ (4 шт, з мохом) ===
	var col_pos := [Vector3(-2.5,2.5,-3), Vector3(2.5,2.5,-3), Vector3(-2.5,2.5,2), Vector3(2.5,2.5,2)]
	for cp in col_pos:
		var col := _cyl(0.3, 5.0, stone_light); col.position = cp; root.add_child(col)
		# Мох на колонах
		for i in 3:
			var moss := _box(Vector3(0.25,0.15,0.15), moss_green)
			moss.position = cp + Vector3(randf()*0.3-0.15, 1.0+i*1.2, randf()*0.3-0.15); root.add_child(moss)
	
	# === АРКОВІ СТІНИ ===
	var wall_pos := [Vector3(0,2.2,-4.2), Vector3(0,2.2,3.2)]
	for wp in wall_pos:
		var wall := _box(Vector3(5.5,4.4,0.4), stone_dark); wall.position = wp; root.add_child(wall)
	
	# === МАСИВНІ ДЕРЕВ'ЯНІ ДВЕРІ (задня стіна) ===
	var door_l := _box(Vector3(1.0,3.0,0.2), wood_dark); door_l.position = Vector3(-0.6,2.0,-4.0); root.add_child(door_l)
	var door_r := _box(Vector3(1.0,3.0,0.2), wood_dark); door_r.position = Vector3(0.6,2.0,-4.0); root.add_child(door_r)
	# Залізні скоби
	var hinge := _box(Vector3(0.08,0.8,0.06), stone_dark)
	hinge.position = Vector3(-1.05,1.8,-3.9); root.add_child(hinge)
	
	# === СВІЧКИ НА ПІДЛОЗІ (відблиски у воді) ===
	for i in 6:
		var ang := deg_to_rad(i*60.0)
		var c := _cyl(0.05,0.18, candle)
		c.position = Vector3(cos(ang)*1.8, 0.12, -1+sin(ang)*1.8); root.add_child(c)
		var l := _omni(Color(1,0.35,0.06), 1.0, 3.5)
		l.position = Vector3(cos(ang)*1.8, 0.35, -1+sin(ang)*1.8); root.add_child(l)
	
	# === ЗОЛОТЕ СЯЙВО (від циліндра Алтеї) ===
	var glow_orb := _cyl(0.08,0.25, gold_glow)
	glow_orb.position = Vector3(0, 1.25, -1.35); root.add_child(glow_orb)
	var artifact_light := _omni(Color(0.9,0.5,0.05), 1.5, 6.0)
	artifact_light.position = Vector3(0, 1.25, -1.35); root.add_child(artifact_light)
	
	# === ТУМАН (об'ємний) ===
	var fog_particles: Array[Node3D] = []
	for i in 10:
		var fog := _box(Vector3(1.5,1.0,0.02), _mat(Color(0.08,0.10,0.12,0.15), 0.01))
		fog.position = Vector3(-2+randf()*4, 0.3+randf()*1.5, -3+randf()*5); root.add_child(fog)
	
	# === МОХ НА СТІНАХ ===
	for i in 5:
		var wall_moss := _box(Vector3(0.8,0.3,0.05), moss_green)
		wall_moss.position = Vector3(-2+randf()*4, 1.5+randf()*2, -4.15); root.add_child(wall_moss)

func _mat(c: Color, r: float, _em:=false, _met:=0.0) -> StandardMaterial3D:
	var m := StandardMaterial3D.new(); m.albedo_color = c; m.roughness = r
	m.metallic = _met; return m

func _box(size: Vector3, mat: Material) -> MeshInstance3D:
	var mi := MeshInstance3D.new(); var m := BoxMesh.new()
	m.size = size; m.material = mat; mi.mesh = m; return mi

func _cyl(r: float, h: float, mat: Material) -> MeshInstance3D:
	var mi := MeshInstance3D.new(); var m := CylinderMesh.new()
	m.top_radius = r; m.bottom_radius = r; m.height = h
	m.material = mat; mi.mesh = m; return mi

func _omni(col: Color, energy: float, range: float) -> OmniLight3D:
	var l := OmniLight3D.new(); l.light_color = col
	l.light_energy = energy; l.omni_range = range; return l
