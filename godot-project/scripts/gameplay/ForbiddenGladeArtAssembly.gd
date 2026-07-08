extends Node3D
# ForbiddenGladeArtAssembly — священна галявина Мурі, вівтар, камені, вогнище.

func _ready() -> void:
	var stone := _mat(Color(0.18,0.17,0.15), 0.90)
	var moss := _mat(Color(0.08,0.18,0.06), 0.72)
	var fire_m := _mat(Color(0.9,0.35,0.06), 0.2)
	fire_m.emission_enabled=true; fire_m.emission=Color(0.7,0.18,0.02); fire_m.emission_energy_multiplier=1.8
	var gold := _mat(Color(0.8,0.5,0.05), 0.1)
	gold.emission_enabled=true; gold.emission=Color(0.6,0.3,0.02); gold.emission_energy_multiplier=1.5
	var wood := _mat(Color(0.12,0.09,0.05), 0.90)
	
	var root := Node3D.new(); root.name = "GladeDressing"; add_child(root)
	
	# === КАМ'ЯНИЙ ВІВТАР ===
	var altar := _box(Vector3(1.5,1.0,1.0), stone); altar.position=Vector3(0,0.5,-2); root.add_child(altar)
	
	# === РИТУАЛЬНІ КАМЕНІ ПО КОЛУ ===
	for i in 7:
		var ang := deg_to_rad(i*360.0/7)
		var s := _box(Vector3(0.5,2.0+randf()*0.8,0.5), stone)
		s.position=Vector3(cos(ang)*3.5,1.0,-2+sin(ang)*3.5); root.add_child(s)
		# Мох
		for j in 3:
			var m := _box(Vector3(0.3,0.15,0.1), moss)
			m.position=s.position+Vector3(0,0.8+j*0.6,0.3); root.add_child(m)
	
	# === ВОГНИЩЕ ===
	var fire := _cyl(0.12,0.4, fire_m); fire.position=Vector3(0,0.2,-2); root.add_child(fire)
	var fl := _omni(Color(1,0.3,0.04),2.5,8.0); fl.position=Vector3(0,0.6,-2); root.add_child(fl)
	
	# === ЗОЛОТЕ СЯЙВО НАД ВІВТАРЕМ ===
	var glow := _cyl(0.15,0.3, gold); glow.position=Vector3(0,1.5,-2); root.add_child(glow)
	var gl := _omni(Color(0.8,0.4,0.02),1.5,5.0); gl.position=Vector3(0,1.5,-2); root.add_child(gl)
	
	# === АМУЛЕТИ НА ДЕРЕВАХ (підвішені обереги) ===
	for i in 6:
		var a := _box(Vector3(0.08,0.15,0.08), wood)
		a.position=Vector3(-3+randf()*6,2+randf()*2,-5+randf()*6); root.add_child(a)

func _mat(c:Color,r:float)->StandardMaterial3D: var m:=StandardMaterial3D.new(); m.albedo_color=c; m.roughness=r; return m
func _box(s:Vector3,mat:Material)->MeshInstance3D: var mi:=MeshInstance3D.new(); var m:=BoxMesh.new(); m.size=s; m.material=mat; mi.mesh=m; return mi
func _cyl(r:float,h:float,mat:Material)->MeshInstance3D: var mi:=MeshInstance3D.new(); var m:=CylinderMesh.new(); m.top_radius=r; m.bottom_radius=r; m.height=h; m.material=mat; mi.mesh=m; return mi
func _omni(col:Color,energy:float,range:float)->OmniLight3D: var l:=OmniLight3D.new(); l.light_color=col; l.light_energy=energy; l.omni_range=range; return l
