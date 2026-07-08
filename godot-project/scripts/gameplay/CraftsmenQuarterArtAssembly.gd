extends Node3D
# CraftsmenQuarterArtAssembly — п'ять майстерень, дерев'яні фасади, вивіски, тирса, горно.
# Референс: квартал ремісників з D:/артефакти.

func _ready() -> void:
	var wood := _mat(Color(0.18,0.12,0.07), 0.90)
	var plaster := _mat(Color(0.28,0.26,0.24), 0.88)
	var timber := _mat(Color(0.14,0.10,0.05), 0.92)
	var iron := _mat(Color(0.15,0.13,0.11), 0.65, false, 0.8)
	var shavings := _mat(Color(0.35,0.28,0.18), 0.98)
	var forge := _mat(Color(0.9,0.25,0.04), 0.2)
	forge.emission_enabled = true; forge.emission = Color(0.8,0.18,0.02); forge.emission_energy_multiplier = 2.0
	var sign_wood := _mat(Color(0.12,0.08,0.04), 0.85)
	
	var root := Node3D.new(); root.name = "CraftsmenDressing"; add_child(root)
	
	# === 5 МАЙСТЕРЕНЬ (фасади вздовж вулиці) ===
	var shops := [
		{name:"Різьбяр", pos:Vector3(-4,2,3), tool:"chisel"},
		{name:"Кушнір", pos:Vector3(0,2,3), tool:"fur"},
		{name:"Коваль", pos:Vector3(4,2,3), tool:"hammer"},
		{name:"Гончар", pos:Vector3(-2,2,-2), tool:"clay"},
		{name:"Столяр", pos:Vector3(3,2,-2), tool:"saw"},
	]
	
	for shop in shops:
		var p := shop.pos
		# Фасад
		var facade := _box(Vector3(3,3.5,0.3), plaster if shop.name in ["Різьбяр","Кушнір","Столяр"] else timber)
		facade.position = p; root.add_child(facade)
		# Двері
		var door := _box(Vector3(0.8,2.2,0.1), wood)
		door.position = p + Vector3(0,0,0.2); root.add_child(door)
		# Вивіска
		var sign := _box(Vector3(1.5,0.3,0.08), sign_wood)
		sign.position = p + Vector3(0,1.6,0.2); root.add_child(sign)
		# Інструмент біля входу
		if shop.tool == "chisel":
			var ch := _box(Vector3(0.03,0.03,0.4), iron); ch.position = p+Vector3(0.5,0.3,0.3); root.add_child(ch)
		elif shop.tool == "hammer":
			var hm := _box(Vector3(0.1,0.08,0.4), iron); hm.position = p+Vector3(0.4,0.4,0.3); root.add_child(hm)
		# Тирса/стружка біля дверей
		for i in 10:
			var chip := _box(Vector3(0.04,0.01,0.1+randf()*0.1), shavings)
			chip.position = p + Vector3(randf()*2-1, 0.02, 0.4+randf()*0.5); root.add_child(chip)
	
	# === ГОРНО (коваль) — жевріючий вогонь ===
	var furnace := _box(Vector3(1.2,1.0,0.8), iron)
	furnace.position = Vector3(4, 0.5, 3.5); root.add_child(furnace)
	var fire := _cyl(0.15,0.4, forge)
	fire.position = Vector3(4, 1.2, 3.5); root.add_child(fire)
	var f_light := _omni(Color(1,0.3,0.04), 2.5, 8.0)
	f_light.position = Vector3(4, 1.2, 3.5); root.add_child(f_light)
	
	# === БРУКІВКА ===
	var ground := _box(Vector3(18,0.05,12), _mat(Color(0.18,0.16,0.14), 0.93))
	ground.position = Vector3(0,0.02,0); root.add_child(ground)
	
	# === ЛІХТАР НА СТОВПІ ===
	var post := _cyl(0.06,2.5, iron); post.position = Vector3(0,2.0,0); root.add_child(post)
	var lantern := _box(Vector3(0.3,0.4,0.3), forge)
	lantern.position = Vector3(0,2.6,0); root.add_child(lantern)
	var l_light := _omni(Color(1,0.4,0.08), 2.0, 10.0)
	l_light.position = Vector3(0,2.6,0); root.add_child(l_light)

func _mat(c: Color, r: float, _em:=false, _met:=0.0) -> StandardMaterial3D:
	var m := StandardMaterial3D.new(); m.albedo_color = c; m.roughness = r; m.metallic = _met; return m
func _box(size: Vector3, mat: Material) -> MeshInstance3D:
	var mi := MeshInstance3D.new(); var m := BoxMesh.new(); m.size = size; m.material = mat; mi.mesh = m; return mi
func _cyl(r: float, h: float, mat: Material) -> MeshInstance3D:
	var mi := MeshInstance3D.new(); var m := CylinderMesh.new(); m.top_radius = r; m.bottom_radius = r; m.height = h; m.material = mat; mi.mesh = m; return mi
func _omni(col: Color, energy: float, range: float) -> OmniLight3D:
	var l := OmniLight3D.new(); l.light_color = col; l.light_energy = energy; l.omni_range = range; return l
