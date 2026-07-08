extends Node3D
# BuildOldWoman — старенька з хусткою

func _ready() -> void:
	var skin:=_mat(Color(0.78,0.60,0.44),0.78); var scarf:=_mat(Color(0.50,0.35,0.20),0.85)
	var dress:=_mat(Color(0.18,0.16,0.22),0.82)
	
	var head:=_sphere(0.15,skin); head.position=Vector3(0,1.4,0); add_child(head)
	var s:=_box(Vector3(0.20,0.10,0.22),scarf); s.position=Vector3(0,1.48,0); add_child(s)
	var body:=_cyl(0.14,0.55,dress); body.position=Vector3(0,1.0,0); add_child(body)
	for side in[-1,1]: var arm:=_cyl(0.035,0.45,skin); arm.position=Vector3(side*0.15,1.2,0); add_child(arm)
	# Згорблена
	rotation_degrees.z = -8

func _mat(c:Color,r:float)->StandardMaterial3D: var m:=StandardMaterial3D.new(); m.albedo_color=c; m.roughness=r; return m
func _box(s:Vector3,mat:Material)->MeshInstance3D: var mi:=MeshInstance3D.new(); var m:=BoxMesh.new(); m.size=s; m.material=mat; mi.mesh=m; return mi
func _cyl(r:float,h:float,mat:Material)->MeshInstance3D: var mi:=MeshInstance3D.new(); var m:=CylinderMesh.new(); m.top_radius=r; m.bottom_radius=r; m.height=h; m.material=mat; mi.mesh=m; return mi
func _sphere(r:float,mat:Material)->MeshInstance3D: var mi:=MeshInstance3D.new(); var m:=SphereMesh.new(); m.radius=r; m.height=r*2; m.material=mat; mi.mesh=m; return mi
