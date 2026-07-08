extends Node3D
# GreyfordGateArtAssembly — кам'яна брама з порткулісом, вартовий пост, дощ, туман.
# Референс: середньовічна міська брама, мокра бруківка, смолоскипи.

func _ready() -> void:
	var stone_wall := _mat(Color(0.22,0.23,0.24), 0.90)
	var stone_arch := _mat(Color(0.18,0.19,0.20), 0.88)
	var iron := _mat(Color(0.12,0.11,0.10), 0.70, false, 0.85)
	var wood := _mat(Color(0.15,0.10,0.06), 0.92)
	var cobble := _mat(Color(0.16,0.14,0.12), 0.95)
	var torch_fire := _mat(Color(0.9,0.35,0.06), 0.2)
	torch_fire.emission_enabled = true; torch_fire.emission = Color(0.8,0.22,0.03); torch_fire.emission_energy_multiplier = 1.5
	var wet_ground := _mat(Color(0.08,0.09,0.10), 0.11, false, 0.15)
	
	var root := Node3D.new(); root.name = "GateDressing"; add_child(root)
	
	# === ДВІ МАСИВНІ БАШТИ (ліва + права) ===
	for side in [-1, 1]:
		var tower := _box(Vector3(2.5, 8, 3), stone_wall)
		tower.position = Vector3(side*4.5, 4, 0); root.add_child(tower)
		# Зубці на верхівці
		for i in 4:
			var battlement := _box(Vector3(0.5, 0.6, 0.5), stone_wall)
			battlement.position = Vector3(side*4.5, 8.3, -1+i*0.7); root.add_child(battlement)
		# Смолоскип на башті
		var torch := _cyl(0.06, 0.3, torch_fire)
		torch.position = Vector3(side*3.5, 7.5, side*1.0); root.add_child(torch)
		var t_light := _omni(Color(1,0.35,0.05), 2.0, 8.0)
		t_light.position = Vector3(side*3.5, 7.5, side*1.0); root.add_child(t_light)
	
	# === АРКА (кам'яна, над проходом) ===
	var arch_top := _box(Vector3(4.5, 0.6, 3), stone_arch)
	arch_top.position = Vector3(0, 5.5, 0); root.add_child(arch_top)
	var arch_l := _box(Vector3(0.6, 3, 3), stone_arch)
	arch_l.position = Vector3(-2.25, 4, 0); root.add_child(arch_l)
	var arch_r := _box(Vector3(0.6, 3, 3), stone_arch)
	arch_r.position = Vector3(2.25, 4, 0); root.add_child(arch_r)
	
	# === ПОРТКУЛІС (залізна решітка, піднята) ===
	for i in 5:
		var bar_v := _box(Vector3(0.06, 4.5, 0.06), iron)
		bar_v.position = Vector3(-0.8+i*0.4, 3.5, 0); root.add_child(bar_v)
	for i in 3:
		var bar_h := _box(Vector3(1.8, 0.06, 0.06), iron)
		bar_h.position = Vector3(0, 2.5+i*1.3, 0); root.add_child(bar_h)
	
	# === ВАРТОВИЙ ПОСТ (дерев'яний стіл + журнал) ===
	var post := _box(Vector3(1.5, 1.2, 0.8), wood)
	post.position = Vector3(-2.5, 0.6, -1.5); root.add_child(post)
	var ledger := _box(Vector3(0.6, 0.06, 0.4), wood)
	ledger.position = Vector3(-2.5, 1.25, -1.5); root.add_child(ledger)
	
	# === МОКРА БРУКІВКА ===
	var road := _box(Vector3(8, 0.05, 12), wet_ground)
	road.position = Vector3(0, 0.02, 0); root.add_child(road)
	
	# === БІЧНІ СТІНИ (кріпосні) ===
	for side in [-1, 1]:
		var wall := _box(Vector3(6, 5, 1.5), stone_wall)
		wall.position = Vector3(side*7, 2.5, 0); root.add_child(wall)
	
	# === СМОЛОСКИПИ ВЗДОВЖ СТІНИ ===
	for side in [-1, 1]:
		for i in 2:
			var t := _cyl(0.05,0.25, torch_fire)
			t.position = Vector3(side*4.5 + side*2*i, 4.5, side*1.2); root.add_child(t)
			var tl := _omni(Color(1,0.3,0.04), 1.5, 6.0)
			tl.position = Vector3(side*4.5 + side*2*i, 4.5, side*1.2); root.add_child(tl)

func _mat(c: Color, r: float, _em:=false, _met:=0.0) -> StandardMaterial3D:
	var m := StandardMaterial3D.new(); m.albedo_color = c; m.roughness = r; m.metallic = _met; return m
func _box(size: Vector3, mat: Material) -> MeshInstance3D:
	var mi := MeshInstance3D.new(); var m := BoxMesh.new(); m.size = size; m.material = mat; mi.mesh = m; return mi
func _cyl(r: float, h: float, mat: Material) -> MeshInstance3D:
	var mi := MeshInstance3D.new(); var m := CylinderMesh.new(); m.top_radius = r; m.bottom_radius = r; m.height = h; m.material = mat; mi.mesh = m; return mi
func _omni(col: Color, energy: float, range: float) -> OmniLight3D:
	var l := OmniLight3D.new(); l.light_color = col; l.light_energy = energy; l.omni_range = range; return l
