extends Node3D
# DeepBogArtAssembly — темне болото, мертві дерева, туман, кістки, болотяний газ.

func _ready() -> void:
	var mud := _mat(Color(0.06,0.07,0.05), 0.97)
	var bark := _mat(Color(0.08,0.07,0.05), 0.95)
	var bone := _mat(Color(0.5,0.45,0.38), 0.85)
	var gas := _mat(Color(0.1,0.4,0.1), 0.1)
	gas.emission_enabled=true; gas.emission=Color(0.05,0.3,0.05); gas.emission_energy_multiplier=2.0
	var plank := _mat(Color(0.15,0.12,0.08), 0.92)
	var fog := _mat(Color(0.04,0.06,0.04,0.08), 0.01)
	
	var root := Node3D.new(); root.name = "DeepBogDressing"; add_child(root)
	
	# === БАГНО ===
	var ground := _box(Vector3(40,0.06,30), mud); ground.position=Vector3(0,0.03,-2); root.add_child(ground)
	
	# === МЕРТВІ ДЕРЕВА ===
	for i in 12:
		var t:=_cyl(0.15,3+randf()*4, bark)
		t.position=Vector3(-18+randf()*36,1.5,-15+randf()*25); t.rotation_degrees.z=-25+randf()*50; t.rotation_degrees.x=-15+randf()*30; root.add_child(t)
	
	# === КІСТКИ ===
	for i in 15:
		var b:=_box(Vector3(0.06,0.04,0.3+randf()*0.3), bone)
		b.position=Vector3(-15+randf()*30,0.05,-12+randf()*20); root.add_child(b)
	
	# === БОЛОТЯНИЙ ГАЗ ===
	for i in 8:
		var g:=_cyl(0.08+randf()*0.08,0.2+randf()*0.2, gas)
		g.position=Vector3(-15+randf()*30,0.3+randf()*1.5,-10+randf()*18); root.add_child(g)
		var gl:=_omni(Color(0.05,0.4,0.05),1.0,4.0); gl.position=g.position; root.add_child(gl)
	
	# === ДОШКИ МІСТКА ===
	for i in 8:
		var p:=_box(Vector3(0.8,0.04,0.25), plank)
		p.position=Vector3(-10+randf()*20,0.08,-5+randf()*15); root.add_child(p)
	
	# === ТУМАН ===
	for i in 10:
		var f:=_box(Vector3(4,1.5,0.02), fog)
		f.position=Vector3(-16+randf()*32,0.8+randf()*2,-12+randf()*22); root.add_child(f)

func _mat(c:Color,r:float)->StandardMaterial3D: var m:=StandardMaterial3D.new(); m.albedo_color=c; m.roughness=r; return m
func _box(s:Vector3,mat:Material)->MeshInstance3D: var mi:=MeshInstance3D.new(); var m:=BoxMesh.new(); m.size=s; m.material=mat; mi.mesh=m; return mi
func _cyl(r:float,h:float,mat:Material)->MeshInstance3D: var mi:=MeshInstance3D.new(); var m:=CylinderMesh.new(); m.top_radius=r; m.bottom_radius=r; m.height=h; m.material=mat; mi.mesh=m; return mi
func _omni(col:Color,energy:float,range:float)->OmniLight3D: var l:=OmniLight3D.new(); l.light_color=col; l.light_energy=energy; l.omni_range=range; return l
