extends Node3D
# BuildPatron — п'яний відвідувач за столом

func _ready() -> void:
	var skin:=_mat(Color(0.75,0.58,0.42),0.75); var hair:=_mat(Color(0.35,0.22,0.10),0.88)
	var tunic:=_mat(Color(0.20,0.28,0.18),0.82); var pants:=_mat(Color(0.15,0.12,0.10),0.90)
	
	var head:=_sphere(0.16,skin); head.position=Vector3(0,1.45,0); add_child(head)
	var h:=_box(Vector3(0.18,0.22,0.20),hair); h.position=Vector3(0,1.55,-0.05); add_child(h)
	var body:=_cyl(0.15,0.6,tunic); body.position=Vector3(0,1.1,0); add_child(body)
	for s in[-1,1]: var arm:=_cyl(0.04,0.5,skin); arm.position=Vector3(s*0.16,1.3,0); add_child(arm)
	for s in[-1,1]: var leg:=_cyl(0.05,0.45,pants); leg.position=Vector3(s*0.06,0.5,0); add_child(leg)
	# Голова нахилена (п'яний)
	rotation_degrees.z = 12

func _mat(c:Color,r:float)->StandardMaterial3D: var m:=StandardMaterial3D.new(); m.albedo_color=c; m.roughness=r; return m
func _box(s:Vector3,mat:Material)->MeshInstance3D: var mi:=MeshInstance3D.new(); var m:=BoxMesh.new(); m.size=s; m.material=mat; mi.mesh=m; return mi
func _cyl(r:float,h:float,mat:Material)->MeshInstance3D: var mi:=MeshInstance3D.new(); var m:=CylinderMesh.new(); m.top_radius=r; m.bottom_radius=r; m.height=h; m.material=mat; mi.mesh=m; return mi
func _sphere(r:float,mat:Material)->MeshInstance3D: var mi:=MeshInstance3D.new(); var m:=SphereMesh.new(); m.radius=r; m.height=r*2; m.material=mat; mi.mesh=m; return mi
