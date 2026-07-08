extends Node3D
# RufinRoomArtAssembly — кабінет картографа: мапи, сувої, глобус, чорнильниці, дорожнє спорядження.

func _ready() -> void:
	var wood := _mat(Color(0.16,0.11,0.06), 0.90)
	var paper := _mat(Color(0.5,0.44,0.35), 0.80)
	var ink := _mat(Color(0.05,0.06,0.08), 0.5)
	var leather := _mat(Color(0.2,0.12,0.06), 0.88)
	var brass := _mat(Color(0.5,0.35,0.12), 0.4, false, 0.7)
	var candle_m := _mat(Color(0.9,0.45,0.10), 0.2)
	candle_m.emission_enabled=true; candle_m.emission=Color(0.7,0.22,0.03); candle_m.emission_energy_multiplier=0.8
	
	var root := Node3D.new(); root.name = "RufinDressing"; add_child(root)
	
	# === РОБОЧИЙ СТІЛ (карти, сувої) ===
	var desk := _box(Vector3(2.5,0.8,1.2), wood); desk.position=Vector3(0,0.4,-1); root.add_child(desk)
	# Мапи на столі
	var map1 := _box(Vector3(0.6,0.02,0.8), paper); map1.position=Vector3(-0.3,0.82,-0.8); root.add_child(map1)
	var map2 := _box(Vector3(0.5,0.02,0.6), paper); map2.position=Vector3(0.4,0.82,-1.1); root.add_child(map2)
	# Сувої
	for i in 4:
		var scroll := _cyl(0.04,0.3, paper); scroll.rotation_degrees.x=90
		scroll.position=Vector3(-0.5+i*0.3,0.82,-0.5); root.add_child(scroll)
	# Чорнильниця
	var inkwell := _cyl(0.06,0.1, ink); inkwell.position=Vector3(0.6,0.85,-0.8); root.add_child(inkwell)
	# Перо
	var quill := _box(Vector3(0.02,0.02,0.15), _mat(Color(0.1,0.08,0.05),0.7))
	quill.position=Vector3(0.6,0.9,-0.8); quill.rotation_degrees.z=25; root.add_child(quill)
	
	# === ГЛОБУС ===
	var globe_stand := _cyl(0.04,0.5, wood); globe_stand.position=Vector3(1.5,0.6,-0.5); root.add_child(globe_stand)
	var globe := _cyl(0.2,0.2, _mat(Color(0.15,0.25,0.15),0.5))
	globe.position=Vector3(1.5,0.95,-0.5); root.add_child(globe)
	
	# === КАРТИ НА СТІНАХ ===
	for i in 3:
		var wall_map := _box(Vector3(1.0,0.7,0.02), paper)
		wall_map.position=Vector3(-2+i*2,1.5,-3.2); root.add_child(wall_map)
	
	# === СКРИНЯ З РЕЧАМИ ===
	var chest := _box(Vector3(1.0,0.6,0.6), leather)
	chest.position=Vector3(-1.8,0.3,1.5); root.add_child(chest)
	# Металеві застібки
	var latch := _box(Vector3(0.15,0.04,0.06), brass)
	latch.position=Vector3(-1.8,0.6,1.25); root.add_child(latch)
	
	# === ДОРОЖНІЙ ПОСОХ ===
	var staff := _cyl(0.03,1.8, wood); staff.rotation_degrees.z=10
	staff.position=Vector3(2.2,1.2,1.0); root.add_child(staff)
	
	# === СВІЧКИ ===
	for i in 2:
		var c := _cyl(0.04,0.15, candle_m)
		c.position=Vector3(-0.5+i,0.85,-0.5); root.add_child(c)
		var cl := _omni(Color(1,0.4,0.06),1.0,4.0)
		cl.position=Vector3(-0.5+i,1.0,-0.5); root.add_child(cl)

func _mat(c:Color,r:float,_em:=false,_met:=0.0)->StandardMaterial3D: var m:=StandardMaterial3D.new(); m.albedo_color=c; m.roughness=r; m.metallic=_met; return m
func _box(s:Vector3,mat:Material)->MeshInstance3D: var mi:=MeshInstance3D.new(); var m:=BoxMesh.new(); m.size=s; m.material=mat; mi.mesh=m; return mi
func _cyl(r:float,h:float,mat:Material)->MeshInstance3D: var mi:=MeshInstance3D.new(); var m:=CylinderMesh.new(); m.top_radius=r; m.bottom_radius=r; m.height=h; m.material=mat; mi.mesh=m; return mi
func _omni(col:Color,energy:float,range:float)->OmniLight3D: var l:=OmniLight3D.new(); l.light_color=col; l.light_energy=energy; l.omni_range=range; return l
