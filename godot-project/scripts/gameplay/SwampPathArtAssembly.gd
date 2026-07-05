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
13|3|# Runtime visual assembly for the Swamp Path (Ash Trails) art dressing.
14|4|# Builds boardwalk with chains, cracked mud flats, still black pools,
15|5|# dry reeds, ancient menhirs with runes, and fallen columns.
16|6|# Does NOT create or modify lights/environment.
17|7|
18|8|var mat_cracked_mud: StandardMaterial3D
19|9|var mat_mud_dark: StandardMaterial3D
20|10|var mat_black_water: StandardMaterial3D
21|11|var mat_plank: StandardMaterial3D
22|12|var mat_plank_dark: StandardMaterial3D
23|13|var mat_chain: StandardMaterial3D
24|14|var mat_reed_dry: StandardMaterial3D
25|15|var mat_reed_pale: StandardMaterial3D
26|16|var mat_stone_ancient: StandardMaterial3D
27|17|var mat_rune: StandardMaterial3D
28|18|
29|19|func _ready() -> void:
30|20|	print("SWAMP_ART_READY_FIRED")
31|21|	var root: Node3D = Node3D.new()
32|22|	root.name = "SwampArtDressing"
33|23|	add_child(root)
34|24|	_create_materials()
35|25|	_build_boardwalk(root)
36|26|	_build_cracked_flats(root)
37|27|	_build_still_pools(root)
38|28|	_build_dry_reeds(root)
39|29|	_build_menhirs(root)
40|30|	_build_fallen_columns(root)
41|31|
42|32|func _create_materials() -> void:
43|33|	mat_cracked_mud = _mat(Color(0.32, 0.29, 0.25), 0.9)
44|34|	mat_mud_dark = _mat(Color(0.22, 0.20, 0.17), 0.9)
45|35|	mat_black_water = _mat(Color(0.05, 0.06, 0.07), 0.08)
46|36|	mat_black_water.metallic = 0.1
47|37|	mat_plank = _mat(Color(0.24, 0.18, 0.11), 0.88)
48|38|	mat_plank_dark = _mat(Color(0.16, 0.12, 0.08), 0.88)
49|39|	mat_chain = _mat(Color(0.18, 0.18, 0.19), 0.55)
50|40|	mat_chain.metallic = 0.6
51|41|	mat_reed_dry = _mat(Color(0.52, 0.44, 0.26), 0.95)
52|42|	mat_reed_pale = _mat(Color(0.58, 0.52, 0.34), 0.95)
53|43|	mat_stone_ancient = _mat(Color(0.36, 0.35, 0.32), 0.92)
54|44|	mat_rune = _mat(Color(0.30, 0.34, 0.30), 0.92)
55|45|	mat_rune.emission_enabled = true
56|46|	mat_rune.emission = Color(0.35, 0.5, 0.4)
57|47|	mat_rune.emission_energy_multiplier = 0.25
58|48|
59|49|func _mat(color: Color, roughness: float) -> StandardMaterial3D:
60|50|	var m: StandardMaterial3D = StandardMaterial3D.new()
61|51|	m.albedo_color = color
62|52|	m.roughness = roughness
63|53|	return m
64|54|
65|55|func _box(parent: Node3D, bb_name: String, pos: Vector3, size: Vector3, material: Material, rot_deg: Vector3 = Vector3.ZERO) -> MeshInstance3D:
66|56|	var mesh: BoxMesh = BoxMesh.new()
67|57|	mesh.size = size
68|58|	var mi: MeshInstance3D = MeshInstance3D.new()
69|59|	mi.name = bb_name
70|60|	mi.mesh = mesh
71|61|	mi.material_override = material
72|62|	mi.position = pos
73|63|	mi.rotation_degrees = rot_deg
74|64|	parent.add_child(mi)
75|65|	return mi
76|66|
77|67|func _build_boardwalk(parent: Node3D) -> void:
78|68|	var bw: Node3D = Node3D.new()
79|69|	bw.name = "Boardwalk"
80|70|	parent.add_child(bw)
81|71|
82|72|	# Deck planks from z = 22 to z = -22
83|73|	var z_start: float = 21.55
84|74|	var plank_spacing: float = 0.95
85|75|	var plank_count: int = 46
86|76|	for i in plank_count:
87|77|		var z: float = z_start - float(i) * plank_spacing
88|78|		var pm: StandardMaterial3D = mat_plank if i % 2 == 0 else mat_plank_dark
89|79|		var rot_x: float = randf_range(-3.0, 3.0)
90|80|		var rot_z: float = randf_range(-3.0, 3.0)
91|81|		var y_off: float = randf_range(-0.03, 0.03)
92|82|		_box(bw, "Plank_%02d" % i, Vector3(0, 0.55 + y_off, z), Vector3(2.2, 0.08, 0.9), pm, Vector3(rot_x, 0, rot_z))
93|83|
94|84|	# Support piles every ~2 m under the deck
95|85|	var zp: float = 21.0
96|86|	while zp >= -21.0:
97|87|		_box(bw, "Pile_%.0f" % zp, Vector3(0, 0.20, zp), Vector3(0.16, 0.7, 0.16), mat_plank_dark)
98|88|		_box(bw, "Lath_%.0f" % zp, Vector3(0, 0.46, zp), Vector3(2.4, 0.06, 0.08), mat_plank_dark)
99|89|		zp -= 2.0
100|90|
101|91|	# Edge posts every ~4 m
102|92|	var post_zs: Array[float] = []
103|93|	var zpost: float = 20.0
104|94|	while zpost >= -20.0:
105|95|		post_zs.append(zpost)
106|96|		for sx in [-1.1, 1.1]:
107|97|			_box(bw, "Post_%.1f_%.0f" % [sx, zpost], Vector3(sx, 1.0, zpost), Vector3(0.12, 0.9, 0.12), mat_plank_dark)
108|98|		zpost -= 4.0
109|99|
110|100|	# Sagging chains between adjacent posts
111|101|	for i in range(post_zs.size() - 1):
112|102|		var za: float = post_zs[i]
113|103|		var zb: float = post_zs[i + 1]
114|104|		var span: float = abs(zb - za)
115|105|		var seg_count: int = 3 if span < 4.5 else 4
116|106|		for sx in [-1.1, 1.1]:
117|107|			for j in range(seg_count):
118|108|				var t_ratio: float = float(j + 1) / float(seg_count + 1)
119|109|				var chain_z: float = lerp(za, zb, t_ratio)
120|110|				# Parabolic sag 0.35 m at midpoint
121|111|				var sag: float = -0.35 * sin(PI * t_ratio)
122|112|				var angle_deg: float = rad_to_deg(atan(-0.35 * PI * cos(PI * t_ratio) / span))
123|113|				_box(bw, "Chain_%.0f_%.0f_%d" % [za, zb, j], Vector3(sx, 1.35 + sag, chain_z), Vector3(0.05, 0.18, 0.05), mat_chain, Vector3(angle_deg, 0, 0))
124|114|
125|115|func _build_cracked_flats(parent: Node3D) -> void:
126|116|	var cf: Node3D = Node3D.new()
127|117|	cf.name = "CrackedFlats"
128|118|	parent.add_child(cf)
129|119|
130|120|	# Solid dark mud base underneath everything
131|121|	_box(cf, "MudBase", Vector3(0, -0.02, 0), Vector3(40, 0.04, 50), mat_mud_dark)
132|122|
133|123|	# 9 cracked mud plates on both sides of the boardwalk
134|124|	var plates: Array = [
135|125|		[-6.0, 18.0, 4.2, 4.5, 12.0],
136|126|		[5.5, 15.0, 3.8, 4.0, -25.0],
137|127|		[-5.0, 10.0, 4.8, 3.5, 45.0],
138|128|		[6.0, 6.0, 3.5, 4.5, 8.0],
139|129|		[-7.0, 3.0, 4.5, 4.0, -35.0],
140|130|		[5.0, -2.0, 4.0, 5.0, 60.0],
141|131|		[-6.5, -6.0, 5.0, 4.0, -15.0],
142|132|		[6.5, -10.0, 3.5, 4.5, 30.0],
143|133|		[-5.0, -14.0, 4.0, 4.0, -50.0],
144|134|	]
145|135|	for d in plates:
146|136|		var x: float = d[0] as float
147|137|		var pz: float = d[1] as float
148|138|		var sx: float = d[2] as float
149|139|		var sz: float = d[3] as float
150|140|		var ry: float = d[4] as float
151|141|		_box(cf, "Plate_%.0f_%.0f" % [x, pz], Vector3(x, 0.06, pz), Vector3(sx, 0.12, sz), mat_cracked_mud, Vector3(0, ry, 0))
152|142|
153|143|func _build_still_pools(parent: Node3D) -> void:
154|144|	var sp: Node3D = Node3D.new()
155|145|	sp.name = "StillPools"
156|146|	parent.add_child(sp)
157|147|
158|148|	var pools: Array = [
159|149|		[3.5, 16.0, 4.0, 5.0],
160|150|		[-3.0, 9.0, 3.0, 4.0],
161|151|		[4.0, -2.0, 4.0, 5.0],
162|152|		[-3.5, -10.0, 3.0, 4.0],
163|153|	]
164|154|	for d in pools:
165|155|		var x: float = d[0] as float
166|156|		var pz: float = d[1] as float
167|157|		var sx: float = d[2] as float
168|158|		var sz: float = d[3] as float
169|159|		_box(sp, "Pool_%.0f_%.0f" % [x, pz], Vector3(x, 0.09, pz), Vector3(sx, 0.03, sz), mat_black_water)
170|160|
171|161|func _build_dry_reeds(parent: Node3D) -> void:
172|162|	var dr: Node3D = Node3D.new()
173|163|	dr.name = "DryReeds"
174|164|	parent.add_child(dr)
175|165|
176|166|	var clusters: Array = [
177|167|		Vector3(4.8, 0, 17.5),
178|168|		Vector3(2.2, 0, 14.5),
179|169|		Vector3(-4.5, 0, 10.5),
180|170|		Vector3(-1.8, 0, 8.0),
181|171|		Vector3(5.5, 0, -1.0),
182|172|		Vector3(2.8, 0, -3.5),
183|173|		Vector3(-5.0, 0, -9.0),
184|174|	]
185|175|	for c_idx in clusters.size():
186|176|		var base: Vector3 = clusters[c_idx]
187|177|		var stem_count: int = randi_range(6, 9)
188|178|		for s_idx in stem_count:
189|179|			var spread: float = 0.6
190|180|			var x_off: float = randf_range(-spread, spread)
191|181|			var z_off: float = randf_range(-spread, spread)
192|182|			var height: float = randf_range(1.4, 1.9)
193|183|			var tilt_x: float = randf_range(-8.0, 8.0)
194|184|			var tilt_z: float = randf_range(-8.0, 8.0)
195|185|			var rm: StandardMaterial3D = mat_reed_dry if s_idx % 2 == 0 else mat_reed_pale
196|186|			_box(dr, "Reed_%02d_%02d" % [c_idx, s_idx], base + Vector3(x_off, height * 0.5, z_off), Vector3(0.04, height, 0.04), rm, Vector3(tilt_x, 0, tilt_z))
197|187|
198|188|func _build_menhirs(parent: Node3D) -> void:
199|189|	var mh: Node3D = Node3D.new()
200|190|	mh.name = "Menhirs"
201|191|	parent.add_child(mh)
202|192|
203|193|	# 1 — Large menhir with rune panel
204|194|	var m1: Node3D = Node3D.new()
205|195|	m1.name = "LargeMenhir"
206|196|	m1.position = Vector3(-3.5, 0, 8)
207|197|	m1.rotation_degrees = Vector3(0, 0, 4)
208|198|	mh.add_child(m1)
209|199|	_box(m1, "StoneBody", Vector3.ZERO, Vector3(0.9, 3.4, 0.7), mat_stone_ancient)
210|200|	_box(m1, "RunePanel", Vector3(0.46, -0.2, 0), Vector3(0.06, 1.2, 0.5), mat_rune)
211|201|
212|202|	# 2 — Medium menhir, tilted the other way
213|203|	var m2: Node3D = Node3D.new()
214|204|	m2.name = "MediumMenhir"
215|205|	m2.position = Vector3(4, 0, -6)
216|206|	m2.rotation_degrees = Vector3(0, 0, -7)
217|207|	mh.add_child(m2)
218|208|	_box(m2, "StoneBody", Vector3.ZERO, Vector3(0.7, 2.6, 0.6), mat_stone_ancient)
219|209|	_box(m2, "RunePanel", Vector3(0.36, -0.1, 0), Vector3(0.05, 0.8, 0.35), mat_rune)
220|210|
221|211|	# 3 — Fallen menhir (lying on its side)
222|212|	var m3: Node3D = Node3D.new()
223|213|	m3.name = "FallenMenhir"
224|214|	m3.position = Vector3(-4, 0.3, -14)
225|215|	m3.rotation_degrees = Vector3(90, 20, 0)
226|216|	mh.add_child(m3)
227|217|	_box(m3, "StoneBody", Vector3.ZERO, Vector3(0.6, 0.6, 2.8), mat_stone_ancient)
228|218|
229|219|	# Debris chunks near the fallen menhir
230|220|	var r1x: float = randf_range(-30, 30)
231|221|	var r1y: float = randf_range(-30, 30)
232|222|	var r1z: float = randf_range(-30, 30)
233|223|	_box(mh, "Debris_01", Vector3(-3.4, 0.08, -13.2), Vector3(0.35, 0.2, 0.3), mat_stone_ancient,
234|224|			Vector3(r1x, r1y, r1z))
235|225|	var r2x: float = randf_range(-30, 30)
236|226|	var r2y: float = randf_range(-30, 30)
237|227|	var r2z: float = randf_range(-30, 30)
238|228|	_box(mh, "Debris_02", Vector3(-4.6, 0.06, -15.0), Vector3(0.25, 0.15, 0.4), mat_stone_ancient,
239|229|			Vector3(r2x, r2y, r2z))
240|230|
241|231|func _build_fallen_columns(parent: Node3D) -> void:
242|232|	var fc: Node3D = Node3D.new()
243|233|	fc.name = "FallenColumns"
244|234|	parent.add_child(fc)
245|235|
246|236|	_box(fc, "ColumnLeft", Vector3(-7, 0.25, 12), Vector3(0.5, 0.5, 2.2), mat_stone_ancient, Vector3(0, 0, 25))
247|237|	_box(fc, "ColumnRight", Vector3(7, 0.25, -15), Vector3(0.5, 0.5, 2.2), mat_stone_ancient, Vector3(0, 0, -35))
248|238|	_box(fc, "Chip_01", Vector3(-7.3, 0.06, 11.5), Vector3(0.2, 0.12, 0.2), mat_stone_ancient)
249|239|	_box(fc, "Chip_02", Vector3(7.3, 0.06, -14.3), Vector3(0.25, 0.1, 0.25), mat_stone_ancient)
250|240|