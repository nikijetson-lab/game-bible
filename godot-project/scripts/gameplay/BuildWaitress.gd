extends Node3D
# Створює офіціантку з примітивів + власні матеріали

func _ready():
	var skin = StandardMaterial3D.new(); skin.albedo_color=Color(0.82,0.65,0.48); skin.roughness=0.75
	var hair = StandardMaterial3D.new(); hair.albedo_color=Color(0.15,0.08,0.04); hair.roughness=0.85
	var dress = StandardMaterial3D.new(); dress.albedo_color=Color(0.25,0.30,0.45); dress.roughness=0.80
	var apron = StandardMaterial3D.new(); apron.albedo_color=Color(0.72,0.68,0.60); apron.roughness=0.88
	
	_add_sphere(Vector3(0,1.55,0),0.18,skin)      # голова
	_add_box(Vector3(0,1.55,-0.05),Vector3(0.20,0.28,0.22),hair) # волосся
	_add_cyl(Vector3(0,1.15,0),0.16,0.7,dress)     # тіло
	_add_box(Vector3(0,1.0,0.1),Vector3(0.18,0.45,0.06),apron) # фартух
	for s in[-1,1]: _add_cyl(Vector3(s*0.18,1.4,0),0.04,0.55,skin) # руки
	var tray_m=StandardMaterial3D.new(); tray_m.albedo_color=Color(0.28,0.18,0.08); tray_m.roughness=0.82
	_add_box(Vector3(0.2,1.1,0.25),Vector3(0.25,0.04,0.18),tray_m) # таця
	for s in[-1,1]: _add_cyl(Vector3(0.2+s*0.06,1.13,0.25),0.03,0.08,tray_m)
	for s in[-1,1]: _add_cyl(Vector3(s*0.06,0.55,0),0.05,0.5,StandardMaterial3D.new())

func _add_box(pos,size,mat): var mi=MeshInstance3D.new(); mi.mesh=BoxMesh.new(); mi.mesh.size=size; mi.mesh.material=mat; mi.position=pos; add_child(mi)
func _add_cyl(pos,r,h,mat): var mi=MeshInstance3D.new(); mi.mesh=CylinderMesh.new(); mi.mesh.top_radius=r; mi.mesh.bottom_radius=r; mi.mesh.height=h; mi.mesh.material=mat; mi.position=pos; add_child(mi)
func _add_sphere(pos,r,mat): var mi=MeshInstance3D.new(); mi.mesh=SphereMesh.new(); mi.mesh.radius=r; mi.mesh.height=r*2; mi.mesh.material=mat; mi.position=pos; add_child(mi)
