extends Node3D
# PortTavernArtAssembly — портова таверна: рибальські сіті, морські карти, дощ за вікнами, тьмяне світло.

func _ready() -> void:
	var dark_wood := _mat(Color(0.14,0.10,0.06), 0.92)
	var plaster := _mat(Color(0.25,0.24,0.22), 0.88)
	var net := _mat(Color(0.18,0.16,0.14), 0.85)
	var map_paper := _mat(Color(0.45,0.38,0.25), 0.82)
	var bottle := _mat(Color(0.08,0.20,0.06), 0.45)
	var lantern := _mat(Color(0.9,0.45,0.10), 0.2)
	lantern.emission_enabled=true; lantern.emission=Color(0.7,0.22,0.03); lantern.emission_energy_multiplier=1.2
	var candle := _mat(Color(0.95,0.55,0.18), 0.25)
	candle.emission_enabled=true; candle.emission=Color(0.8,0.35,0.06); candle.emission_energy_multiplier=0.8
	
	var root := Node3D.new(); root.name = "PortTavernDressing"; add_child(root)
	
	# === РИБАЛЬСЬКІ СІТІ (звисають зі стелі) ===
	for i in 4:
		var n := _box(Vector3(2+randf()*3, 0.8+randf()*1.2, 0.02), net)
		n.position = Vector3(-3+randf()*6, 2.5-randf()*0.5, -2+randf()*4); root.add_child(n)
	# Поплавки на сітях
	for i in 8:
		var cork := _cyl(0.05,0.12, _mat(Color(0.4,0.3,0.2), 0.8))
		cork.position = Vector3(-3+randf()*6, 2+randf()*1.5, -2+randf()*4); root.add_child(cork)
	
	# === МОРСЬКІ КАРТИ НА СТІНАХ ===
	for i in 3:
		var map := _box(Vector3(1.2,0.8,0.02), map_paper)
		map.position = Vector3(-4+i*4, 1.8, -3.2); root.add_child(map)
	
	# === ПЛЯШКИ НА ПОЛИЦЯХ ===
	for row in 2:
		for col in 4:
			var b := _cyl(0.04,0.15+randf()*0.1, bottle)
			b.position = Vector3(3.5+col*0.5, 1.2+row*0.4, -3.0); root.add_child(b)
	
	# === СВІЧКИ НА СТОЛАХ ===
	for i in 3:
		var c := _cyl(0.04,0.12, candle)
		c.position = Vector3(-2+i*2.5, 0.8, 1.5); root.add_child(c)
		var cl := _omni(Color(1,0.4,0.08), 0.8, 3.5)
		cl.position = Vector3(-2+i*2.5, 1.0, 1.5); root.add_child(cl)
	
	# === ЛІХТАРІ ПІД СТЕЛЕЮ ===
	for i in 2:
		var l := _box(Vector3(0.2,0.3,0.2), lantern)
		l.position = Vector3(-2+i*4, 2.8, -1); root.add_child(l)
		var ll := _omni(Color(1,0.35,0.04), 1.2, 5.0)
		ll.position = Vector3(-2+i*4, 2.8, -1); root.add_child(ll)
	
	# === БОЧКИ ===
	for i in 3:
		var barrel := _cyl(0.3,0.7, dark_wood)
		barrel.position = Vector3(-3+i*3, 0.35, 2.8); root.add_child(barrel)

func _mat(c:Color,r:float)->StandardMaterial3D: var m:=StandardMaterial3D.new(); m.albedo_color=c; m.roughness=r; return m
func _box(s:Vector3,mat:Material)->MeshInstance3D: var mi:=MeshInstance3D.new(); var m:=BoxMesh.new(); m.size=s; m.material=mat; mi.mesh=m; return mi
func _cyl(r:float,h:float,mat:Material)->MeshInstance3D: var mi:=MeshInstance3D.new(); var m:=CylinderMesh.new(); m.top_radius=r; m.bottom_radius=r; m.height=h; m.material=mat; mi.mesh=m; return mi
func _omni(col:Color,energy:float,range:float)->OmniLight3D: var l:=OmniLight3D.new(); l.light_color=col; l.light_energy=energy; l.omni_range=range; return l
