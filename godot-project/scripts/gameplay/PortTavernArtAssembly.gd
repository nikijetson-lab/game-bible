1|1|extends Node3D
2|
3|const TEX_WOOD := "res://assets/textures/greyford_tavern/dark_wood_planks.png"
4|const TEX_FLOOR := "res://assets/textures/greyford_tavern/wet_floor_planks.png"
5|const TEX_PLASTER := "res://assets/textures/greyford_tavern/smoked_plaster.png"
6|const TEX_BEAMS := "res://assets/textures/greyford_tavern/soot_beams.png"
7|const TEX_BARREL := "res://assets/textures/greyford_tavern/barrel_staves.png"
8|const TEX_CRATE := "res://assets/textures/greyford_tavern/crate_boards.png"
9|const TEX_WINDOW := "res://assets/textures/greyford_tavern/rainy_cold_window.png"
10|const TEX_CLOTH := "res://assets/textures/greyford_tavern/dirty_towel_cloth.png"
11|const TEX_PAPER := "res://assets/textures/greyford_tavern/aged_paper.png"
12|2|
13|3|# Runtime visual assembly for the port tavern decoration.
14|4|# Adds fishing nets, wall charts, bar dressing, stools, and a sleeping patron.
15|5|# Does NOT create or modify any lights/environment.
16|6|# Does NOT hide any existing scene nodes — adds only the "PortArtDressing" subtree.
17|7|
18|8|var mat_net: StandardMaterial3D
19|9|var mat_cork: StandardMaterial3D
20|10|var mat_paper: StandardMaterial3D
21|11|var mat_dark_wood: StandardMaterial3D
22|12|var mat_stool: StandardMaterial3D
23|13|var mat_lamp_glass: StandardMaterial3D
24|14|var mat_bottle_green: StandardMaterial3D
25|15|var mat_cloth: StandardMaterial3D
26|16|
27|17|func _ready() -> void:
28|18|	_create_materials()
29|19|	_build_fishing_nets()
30|20|	_build_wall_charts()
31|21|	_build_bar_dressing()
32|22|	_build_stools()
33|23|	_build_sleeping_patron()
34|24|
35|25|func _create_materials() -> void:
36|26|	mat_net = _mat(Color(0.25, 0.28, 0.24), "", 0.95)
37|27|	mat_cork = _mat(Color(0.55, 0.42, 0.28), "", 0.9)
38|28|	mat_paper = _mat(Color(0.62, 0.58, 0.48), "", 0.85)
39|29|	mat_dark_wood = _mat(Color(0.16, 0.11, 0.07), "", 0.9)
40|30|	mat_stool = _mat(Color(0.22, 0.15, 0.09), "", 0.9)
41|31|	mat_lamp_glass = _mat(Color(0.95, 0.62, 0.28, 0.75), "", 0.72)
42|32|	mat_lamp_glass.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
43|33|	mat_lamp_glass.emission_enabled = true
44|34|	mat_lamp_glass.emission = Color(0.95, 0.5, 0.15)
45|35|	mat_lamp_glass.emission_energy_multiplier = 1.2
46|36|	mat_bottle_green = _mat(Color(0.18, 0.32, 0.22, 0.85), "", 0.65)
47|37|	mat_bottle_green.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
48|38|	mat_cloth = _mat(Color(0.45, 0.42, 0.36), "", 0.95)
49|39|
50|40|func _mat(color: Color, texture_path: String, roughness: float) -> StandardMaterial3D:
51|41|	var m := StandardMaterial3D.new()
52|42|	m.albedo_color = color
53|43|	m.roughness = roughness
54|44|	m.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
55|45|	if texture_path != "":
56|46|		var tex := load(texture_path)
57|47|		if tex is Texture2D:
58|48|			m.albedo_texture = tex
59|49|	return m
60|50|
61|51|func _build_fishing_nets() -> void:
62|52|	var nets := Node3D.new()
63|53|	nets.name = "FishingNets"
64|54|	add_child(nets)
65|55|
66|56|	var net_rots := [12.0, -8.0]
67|57|	for i in range(2):
68|58|		var net_panel := _box(nets, "NetPanel_%s" % i, \
69|59|			Vector3(-6.85, 1.7 + i * -0.2, -1.8 + i * 3.4), \
70|60|			Vector3(2.2, 1.6, 0.04), mat_net, Vector3(0, 0, net_rots[i]))
71|61|		var cork_count := 4 + i
72|62|		for j in range(cork_count):
73|63|			var cx := lerpf(-0.85, 0.85, float(j) / float(cork_count - 1)) if cork_count > 1 else 0.0
74|64|			var cy := 0.6 + fmod(float(j) * 0.4, 0.8)
75|65|			_box(net_panel, "CorkFloat_%s_%s" % [i, j], \
76|66|				Vector3(cx, cy, 0.02), Vector3(0.07, 0.07, 0.07), mat_cork)
77|67|
78|68|func _build_wall_charts() -> void:
79|69|	var charts := Node3D.new()
80|70|	charts.name = "WallCharts"
81|71|	add_child(charts)
82|72|
83|73|	var positions := [
84|74|		Vector3(-6.88, 2.0, -3.5),
85|75|		Vector3(-6.88, 1.6, 0.8),
86|76|		Vector3(1.5, 1.8, -4.95),
87|77|		Vector3(-2.0, 2.05, -4.95)
88|78|	]
89|79|	for i in range(positions.size()):
90|80|		_box(charts, "WallChart_%s" % i, positions[i], \
91|81|			Vector3(0.7, 0.5, 0.02), mat_paper)
92|82|
93|83|func _build_bar_dressing() -> void:
94|84|	var dressing := Node3D.new()
95|85|	dressing.name = "BarDressing"
96|86|	add_child(dressing)
97|87|
98|88|	# Kerosene lamp on the right side of the bar counter (x = 2.2)
99|89|	var lamp := Node3D.new()
100|90|	lamp.name = "KeroseneLamp"
101|91|	lamp.position = Vector3(2.2, 1.05, -3.5)
102|92|	dressing.add_child(lamp)
103|93|
104|94|	_box(lamp, "LampBase", Vector3(0, -0.06, 0), Vector3(0.12, 0.08, 0.12), mat_dark_wood)
105|95|	_box(lamp, "LampGlass", Vector3(0, 0.05, 0), Vector3(0.16, 0.22, 0.16), mat_lamp_glass)
106|96|
107|97|	# 3 green bottles on the shelf behind the bar
108|98|	for i in range(3):
109|99|		var bx := -1.0 + float(i) * 0.5
110|100|		_box(dressing, "Bottle_%s" % i, Vector3(bx, 1.3, -4.3), \
111|101|			Vector3(0.12, 0.4, 0.12), mat_bottle_green)
112|102|
113|103|	# Folded cloth on the bar
114|104|	_box(dressing, "FoldedCloth", Vector3(0.5, 1.07, -3.5), \
115|105|		Vector3(0.3, 0.04, 0.2), mat_cloth)
116|106|
117|107|func _build_stools() -> void:
118|108|	var stools := Node3D.new()
119|109|	stools.name = "BarStools"
120|110|	add_child(stools)
121|111|
122|112|	for i in range(4):
123|113|		var sx := -2.4 + float(i) * 1.6
124|114|		var stool := Node3D.new()
125|115|		stool.name = "Stool_%s" % i
126|116|		stool.position = Vector3(sx, 0, -2.7)
127|117|		stools.add_child(stool)
128|118|
129|119|		# Seat
130|120|		_box(stool, "Seat", Vector3(0, 0.48, 0), Vector3(0.38, 0.06, 0.38), mat_stool)
131|121|		# 4 legs
132|122|		for leg_x in [-0.14, 0.14]:
133|123|			for leg_z in [-0.14, 0.14]:
134|124|				_box(stool, "Leg_%.0f_%.0f" % [leg_x * 100, leg_z * 100], \
135|125|					Vector3(leg_x, 0.225, leg_z), Vector3(0.05, 0.45, 0.05), mat_stool)
136|126|
137|127|func _build_sleeping_patron() -> void:
138|128|	var patron := Node3D.new()
139|129|	patron.name = "SleepingPatron"
140|130|	patron.position = Vector3(2.6, 0, -3.2)
141|131|	add_child(patron)
142|132|
143|133|	# Torso leaning onto the bar counter
144|134|	_box(patron, "Torso", Vector3(0, 0.6, 0.15), \
145|135|		Vector3(0.5, 0.35, 0.3), mat_cloth, Vector3(15, 0, 0))
146|136|
147|137|	# Head as a sphere
148|138|	var head_mesh := SphereMesh.new()
149|139|	head_mesh.radius = 0.11
150|140|	head_mesh.height = 0.22
151|141|	head_mesh.radial_segments = 16
152|142|	head_mesh.rings = 12
153|143|	var head := MeshInstance3D.new()
154|144|	head.name = "Head"
155|145|	head.mesh = head_mesh
156|146|	head.material_override = mat_cloth
157|147|	head.position = Vector3(0, 0.9, 0.22)
158|148|	patron.add_child(head)
159|149|
160|150|	# Folded arms resting on the bar surface
161|151|	_box(patron, "LeftArm", Vector3(-0.18, 0.45, 0.35), \
162|152|		Vector3(0.08, 0.28, 0.22), mat_cloth, Vector3(0, 0, 20))
163|153|	_box(patron, "RightArm", Vector3(0.18, 0.45, 0.35), \
164|154|		Vector3(0.08, 0.28, 0.22), mat_cloth, Vector3(0, 0, -20))
165|155|
166|156|func _box(parent: Node3D, name: String, pos: Vector3, size: Vector3, \
167|157|		material: Material, rot_deg: Vector3 = Vector3.ZERO) -> MeshInstance3D:
168|158|	var mesh := BoxMesh.new()
169|159|	mesh.size = size
170|160|	var mi := MeshInstance3D.new()
171|161|	mi.name = name
172|162|	mi.mesh = mesh
173|163|	mi.material_override = material
174|164|	mi.position = pos
175|165|	mi.rotation_degrees = rot_deg
176|166|	parent.add_child(mi)
177|167|	return mi
178|168|