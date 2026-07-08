extends Node3D
# BuildTrader — торговець з капюшоном

func _ready() -> void:
	var skin:=_mat(Color(0.80,0.62,0.45),0.75); var cloak:=_mat(Color(0.30,0.22,0.12),0.88)
	var tunic:=_mat(Color(0.35,0.30,0.22),0.80)
	
	var head:=_sphere(0.16,skin); head.position=Vector3(0,1.5,0); add_child(head)
	var hood:=_box(Vector3(0.20,0.24,0.22),cloak); hood.position=Vector3(0,1.55,-0.02); add_child(hood)
	var body:=_cyl(0.16,0.7,cloak); body.position=Vector3(0,1.05,0); add_child(body)
	for s in[-1,1]: var arm:=_cyl(0.04,0.5,skin); arm.position=Vector3(s*0.18,1.3,0); add_child(arm)
	# Мішок біля ніг
	var bag:=_box(Vector3(0.2,0.25,0.2),tunic); bag.position=Vector3(0.25,0.2,0.15); add_child(bag)

func _mat(c:Color,r:float)->StandardMaterial3D: var m:=StandardMaterial3D.new(); m.albedo_color=c; m.roughness=r; return m
func _box(s:Vector3,mat:Material)->MeshInstance3D: var mi:=MeshInstance3D.new(); var m:=BoxMesh.new(); m.size=s; m.material=mat; mi.mesh=m; return mi
func _cyl(r:float,h:float,mat:Material)->MeshInstance3D: var mi:=MeshInstance3D.new(); var m:=CylinderMesh.new(); m.top_radius=r; m.bottom_radius=r; m.height=h; m.material=mat; mi.mesh=m; return mi
func _sphere(r:float,mat:Material)->MeshInstance3D: var mi:=MeshInstance3D.new(); var m:=SphereMesh.new(); m.radius=r; m.height=r*2; m.material=mat; mi.mesh=m; return mi
