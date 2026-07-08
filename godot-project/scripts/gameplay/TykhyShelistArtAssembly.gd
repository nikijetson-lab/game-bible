extends Node3D
# TykhyShelistArtAssembly — село Мурі на палях над темною водою, вогнища, навіси.

func _ready() -> void:
	var w := _mat(Color(0.12,0.09,0.05), 0.92)
	var dark := _mat(Color(0.06,0.05,0.04), 0.96)
	var water := _mat(Color(0.02,0.05,0.06), 0.04, false, 0.4)
	var fire_m := _mat(Color(0.9,0.35,0.06), 0.2)
	fire_m.emission_enabled=true; fire_m.emission=Color(0.7,0.18,0.02); fire_m.emission_energy_multiplier=1.5
	var reed := _mat(Color(0.15,0.22,0.08), 0.75)
	
	var root := Node3D.new(); root.name = "TykhyDressing"; add_child(root)
	
	# === ВОДА (основа) ===
	var pool := _box(Vector3(50,0.05,40), water); pool.position = Vector3(5,-0.15,0); root.add_child(pool)
	
	# === ХАТИНИ НА ПАЛЯХ (5 шт) ===
	for i in 5:
		var x := -18.0 + i*9; var z := -8.0 + (i%3)*8
		# Палі
		for j in [-1,1]:
			for k in [-1,1]:
				var s:=_cyl(0.1,2.8,w); s.position=Vector3(x+j*1.5,1.4,z+k*1.5); root.add_child(s)
		# Платформа
		var plat:=_box(Vector3(3.5,0.1,3.5),w); plat.position=Vector3(x,2.8,z); root.add_child(plat)
		# Стіни
		var hut:=_box(Vector3(3,2.2,3),w); hut.position=Vector3(x,4,z); root.add_child(hut)
		# Дах (очеретяний)
		var roof:=_box(Vector3(3.5,0.4,3.5),reed); roof.position=Vector3(x,5.2,z); root.add_child(roof)
		# Вогнище на платформі
		var fire:=_cyl(0.08,0.3,fire_m); fire.position=Vector3(x,3.1,z+1.5); root.add_child(fire)
		var fl:=_omni(Color(1,0.3,0.04),1.8,7.0); fl.position=Vector3(x,3.1,z+1.5); root.add_child(fl)
	
	# === МІСТКИ МІЖ ХАТИНАМИ ===
	for i in 4:
		var bridge:=_box(Vector3(7.5,0.06,0.8),w)
		bridge.position=Vector3(-10+i*8,2.85,-4); root.add_child(bridge)
	
	# === ОЧЕРЕТ (по краях) ===
	for i in 25:
		var r:=_cyl(0.02,0.8+randf()*1.2,reed)
		r.position=Vector3(-25+randf()*50,-0.1,-18+randf()*5); root.add_child(r)

func _mat(c:Color,r:float,_em:=false,_met:=0.0)->StandardMaterial3D:
	var m:=StandardMaterial3D.new();m.albedo_color=c;m.roughness=r;m.metallic=_met;return m
func _box(s:Vector3,mat:Material)->MeshInstance3D:
	var mi:=MeshInstance3D.new();var m:=BoxMesh.new();m.size=s;m.material=mat;mi.mesh=m;return mi
func _cyl(r:float,h:float,mat:Material)->MeshInstance3D:
	var mi:=MeshInstance3D.new();var m:=CylinderMesh.new();m.top_radius=r;m.bottom_radius=r;m.height=h;m.material=mat;mi.mesh=m;return mi
func _omni(col:Color,energy:float,range:float)->OmniLight3D:
	var l:=OmniLight3D.new();l.light_color=col;l.light_energy=energy;l.omni_range=range;return l
