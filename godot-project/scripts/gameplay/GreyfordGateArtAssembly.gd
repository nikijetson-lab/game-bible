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
13|3|# Runtime visual assembly for Greyford Gate — arch, portcullis, walls,
14|4|# sergeant post, cobblestone road, and outer guards.
15|5|# Does NOT create or modify any lights/environment.
16|6|# All dressing goes under a single "GateArtDressing" node so existing nodes are untouched.
17|7|
18|8|var mat_stone: StandardMaterial3D
19|9|var mat_stone_dark: StandardMaterial3D
20|10|var mat_oak: StandardMaterial3D
21|11|var mat_iron: StandardMaterial3D
22|12|var mat_rust: StandardMaterial3D
23|13|var mat_cobble: StandardMaterial3D
24|14|var mat_lamp: StandardMaterial3D
25|15|var mat_paper: StandardMaterial3D
26|16|var mat_wood_desk: StandardMaterial3D
27|17|
28|18|
29|19|func _ready() -> void:
30|20|	var dressing := Node3D.new()
31|21|	dressing.name = "GateArtDressing"
32|22|	add_child(dressing)
33|23|
34|24|	_create_materials()
35|25|	_build_gate_arch(dressing)
36|26|	_build_portcullis(dressing)
37|27|	_build_walls(dressing)
38|28|	_build_sergeant_post(dressing)
39|29|	_build_cobblestone_road(dressing)
40|30|	_build_outer_guards(dressing)
41|31|
42|32|
43|33|func _create_materials() -> void:
44|34|	mat_stone = _mat(Color(0.32, 0.30, 0.27), "", 0.95)
45|35|	mat_stone_dark = _mat(Color(0.24, 0.22, 0.20), "", 0.95)
46|36|	mat_oak = _mat(Color(0.14, 0.09, 0.05), "", 0.9)
47|37|
48|38|	mat_iron = _mat(Color(0.20, 0.20, 0.21), "", 0.65)
49|39|	mat_iron.metallic = 0.5
50|40|
51|41|	mat_rust = _mat(Color(0.30, 0.20, 0.14), "", 0.65)
52|42|	mat_rust.metallic = 0.3
53|43|
54|44|	# Wet cobblestone — slightly reflective
55|45|	mat_cobble = _mat(Color(0.20, 0.20, 0.21), "", 0.5)
56|46|
57|47|	# Warm lantern glass with self-emission
58|48|	mat_lamp = _mat(Color(0.95, 0.62, 0.28, 0.8), "", 0.5)
59|49|	mat_lamp.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
60|50|	mat_lamp.emission_enabled = true
61|51|	mat_lamp.emission = Color(0.95, 0.5, 0.15)
62|52|	mat_lamp.emission_energy_multiplier = 1.3
63|53|
64|54|	mat_paper = _mat(Color(0.60, 0.56, 0.46), "", 0.8)
65|55|	mat_wood_desk = _mat(Color(0.20, 0.13, 0.08), "", 0.85)
66|56|
67|57|
68|58|func _mat(color: Color, texture_path: String, roughness: float) -> StandardMaterial3D:
69|59|	var m := StandardMaterial3D.new()
70|60|	m.albedo_color = color
71|61|	m.roughness = roughness
72|62|	m.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
73|63|	if texture_path != "":
74|64|		var tex := load(texture_path)
75|65|		if tex is Texture2D:
76|66|			m.albedo_texture = tex
77|67|	return m
78|68|
79|69|
80|70|func _box(
81|71|	parent: Node3D, name: String, pos: Vector3, size: Vector3,
82|72|	material: Material, rot_deg: Vector3 = Vector3.ZERO
83|73|) -> MeshInstance3D:
84|74|	var mesh := BoxMesh.new()
85|75|	mesh.size = size
86|76|	var mi := MeshInstance3D.new()
87|77|	mi.name = name
88|78|	mi.mesh = mesh
89|79|	mi.material_override = material
90|80|	mi.position = pos
91|81|	mi.rotation_degrees = rot_deg
92|82|	parent.add_child(mi)
93|83|	return mi
94|84|
95|85|
96|86|# ---------------------------------------------------------------------------
97|87|# 3. Massive stone gate arch around the existing wooden gate (center z = -6)
98|88|# ---------------------------------------------------------------------------
99|89|func _build_gate_arch(parent: Node3D) -> void:
100|90|	var arch := Node3D.new()
101|91|	arch.name = "GateArch"
102|92|	parent.add_child(arch)
103|93|
104|94|	# Two stone pylons flanking the gate
105|95|	_box(arch, "LeftPylon", Vector3(-3.4, 2.6, -6), Vector3(1.4, 5.2, 1.4), mat_stone)
106|96|	_box(arch, "RightPylon", Vector3(3.4, 2.6, -6), Vector3(1.4, 5.2, 1.4), mat_stone)
107|97|
108|98|	# Arch lintel / bridge
109|99|	_box(arch, "ArchLintel", Vector3(0, 5.4, -6), Vector3(8.2, 1.2, 1.4), mat_stone)
110|100|
111|101|	# Merlons (crenellations / зубчастий верх) on top of the arch
112|102|	var merlon_xs := [-3.0, -1.5, 0.0, 1.5, 3.0]
113|103|	for i in 5:
114|104|		_box(
115|105|			arch, "Merlon_%d" % i,
116|106|			Vector3(merlon_xs[i], 6.3, -6),
117|107|			Vector3(0.8, 0.6, 1.2),
118|108|			mat_stone
119|109|		)
120|110|
121|111|
122|112|# ---------------------------------------------------------------------------
123|113|# 4. Raised iron portcullis with spikes at the bottom
124|114|# ---------------------------------------------------------------------------
125|115|func _build_portcullis(parent: Node3D) -> void:
126|116|	var pc := Node3D.new()
127|117|	pc.name = "Portcullis"
128|118|	parent.add_child(pc)
129|119|
130|120|	# 7 vertical bars at y = 4.2 (lower third visible inside the arch opening)
131|121|	var bar_xs := [-2.25, -1.5, -0.75, 0.0, 0.75, 1.5, 2.25]
132|122|	for i in 7:
133|123|		_box(
134|124|			pc, "VerticalBar_%d" % i,
135|125|			Vector3(bar_xs[i], 4.2, -5.8),
136|126|			Vector3(0.08, 1.6, 0.08),
137|127|			mat_iron
138|128|		)
139|129|		# Spike at the bottom end of each bar
140|130|		_box(
141|131|			pc, "Spike_%d" % i,
142|132|			Vector3(bar_xs[i], 3.4 - 0.11, -5.8),
143|133|			Vector3(0.06, 0.22, 0.06),
144|134|			mat_rust
145|135|		)
146|136|
147|137|	# 2 horizontal bars spanning the full width
148|138|	_box(pc, "HorizontalBarTop", Vector3(0, 4.8, -5.8), Vector3(5.6, 0.08, 0.08), mat_iron)
149|139|	_box(pc, "HorizontalBarBottom", Vector3(0, 3.6, -5.8), Vector3(5.6, 0.08, 0.08), mat_iron)
150|140|
151|141|
152|142|# ---------------------------------------------------------------------------
153|143|# 5. Fortress walls with grated windows
154|144|# ---------------------------------------------------------------------------
155|145|func _build_walls(parent: Node3D) -> void:
156|146|	var walls := Node3D.new()
157|147|	walls.name = "GateWalls"
158|148|	parent.add_child(walls)
159|149|
160|150|	# Left wall segment
161|151|	_box(walls, "LeftWall", Vector3(-7.5, 2.3, -6), Vector3(5.5, 4.6, 1.1), mat_stone)
162|152|	# Window niche recessed into the wall
163|153|	_box(walls, "LeftWindowNiche", Vector3(-7.5, 2.6, -5.35), Vector3(0.7, 1.1, 0.15), mat_stone_dark)
164|154|	# 3 vertical iron bars in the window
165|155|	for i in 3:
166|156|		_box(
167|157|			walls, "LeftWindowBar_%d" % i,
168|158|			Vector3(-7.5 - 0.23 + 0.23 * i, 2.6, -5.25),
169|159|			Vector3(0.05, 1.05, 0.05),
170|160|			mat_iron
171|161|		)
172|162|
173|163|	# Right wall segment
174|164|	_box(walls, "RightWall", Vector3(7.5, 2.3, -6), Vector3(5.5, 4.6, 1.1), mat_stone)
175|165|	# Window niche
176|166|	_box(walls, "RightWindowNiche", Vector3(7.5, 2.6, -5.35), Vector3(0.7, 1.1, 0.15), mat_stone_dark)
177|167|	# 3 vertical iron bars
178|168|	for i in 3:
179|169|		_box(
180|170|			walls, "RightWindowBar_%d" % i,
181|171|			Vector3(7.5 - 0.23 + 0.23 * i, 2.6, -5.25),
182|172|			Vector3(0.05, 1.05, 0.05),
183|173|			mat_iron
184|174|		)
185|175|
186|176|
187|177|# ---------------------------------------------------------------------------
188|178|# 6. Sergeant registration post — desk, journal, wall lantern
189|179|# ---------------------------------------------------------------------------
190|180|func _build_sergeant_post(parent: Node3D) -> void:
191|181|	var post := Node3D.new()
192|182|	post.name = "SergeantPost"
193|183|	parent.add_child(post)
194|184|
195|185|	# Desk stand / vertical leg
196|186|	_box(post, "DeskStand", Vector3(1.5, 0.525, -4), Vector3(0.12, 1.05, 0.12), mat_oak)
197|187|
198|188|	# Slanted desk top at y = 1.15, tilted forward
199|189|	_box(
200|190|		post, "DeskTop",
201|191|		Vector3(1.5, 1.15, -4),
202|192|		Vector3(0.55, 0.05, 0.4),
203|193|		mat_wood_desk,
204|194|		Vector3(-18, 0, 0)
205|195|	)
206|196|
207|197|	# Open journal on the desk (same tilt)
208|198|	_box(
209|199|		post, "Journal",
210|200|		Vector3(1.5, 1.24, -4),
211|201|		Vector3(0.42, 0.02, 0.3),
212|202|		mat_paper,
213|203|		Vector3(-18, 0, 0)
214|204|	)
215|205|
216|206|	# Wall lantern on the inner face of the right pylon
217|207|	_box(post, "LanternBracket", Vector3(2.85, 2.6, -4.0), Vector3(0.05, 0.05, 0.3), mat_iron)
218|208|	_box(post, "LanternBody", Vector3(2.85, 2.6, -4.15), Vector3(0.18, 0.24, 0.18), mat_lamp)
219|209|
220|210|
221|211|# ---------------------------------------------------------------------------
222|212|# 7. Wet cobblestone road through the gate with scattered edge stones
223|213|# ---------------------------------------------------------------------------
224|214|func _build_cobblestone_road(parent: Node3D) -> void:
225|215|	var road := Node3D.new()
226|216|	road.name = "CobblestoneRoad"
227|217|	parent.add_child(road)
228|218|
229|219|	# Main wet cobblestone strip
230|220|	_box(road, "CobbleStrip", Vector3(0, 0.03, -2), Vector3(4.6, 0.06, 14), mat_cobble)
231|221|
232|222|	# 8 deterministic edge stones (both sides)
233|223|	var edge_stones := [
234|224|		Vector3(-2.4, 0.04, -7.0),
235|225|		Vector3(2.4, 0.04, -6.5),
236|226|		Vector3(-2.4, 0.04, -4.0),
237|227|		Vector3(2.4, 0.04, -3.5),
238|228|		Vector3(-2.4, 0.04, -1.0),
239|229|		Vector3(2.4, 0.04, -0.5),
240|230|		Vector3(-2.4, 0.04, 2.0),
241|231|		Vector3(2.4, 0.04, 2.5),
242|232|	]
243|233|	for i in edge_stones.size():
244|234|		_box(
245|235|			road, "EdgeStone_%d" % i,
246|236|			edge_stones[i],
247|237|			Vector3(0.25, 0.08, 0.3),
248|238|			mat_stone_dark
249|239|		)
250|240|
251|241|
252|242|# ---------------------------------------------------------------------------
253|243|# 8. Two stylised guard silhouettes beyond the gate
254|244|# ---------------------------------------------------------------------------
255|245|func _build_outer_guards(parent: Node3D) -> void:
256|246|	var guards := Node3D.new()
257|247|	guards.name = "OuterGuards"
258|248|	parent.add_child(guards)
259|249|
260|250|	# --- Left guard ---
261|251|	_box(
262|252|		guards, "LeftGuardTorso",
263|253|		Vector3(-1.5, 0.425, -7.5),
264|254|		Vector3(0.42, 0.85, 0.28),
265|255|		mat_stone_dark
266|256|	)
267|257|	# Head as a sphere
268|258|	var head_l := MeshInstance3D.new()
269|259|	head_l.name = "LeftGuardHead"
270|260|	var sphere_l := SphereMesh.new()
271|261|	sphere_l.radius = 0.2
272|262|	sphere_l.height = 0.4
273|263|	sphere_l.radial_segments = 16
274|264|	head_l.mesh = sphere_l
275|265|	head_l.material_override = mat_stone_dark
276|266|	head_l.position = Vector3(-1.5, 0.95, -7.5)
277|267|	guards.add_child(head_l)
278|268|	# Spear
279|269|	_box(
280|270|		guards, "LeftGuardSpear",
281|271|		Vector3(-1.72, 0.95, -7.5),
282|272|		Vector3(0.04, 1.9, 0.04),
283|273|		mat_iron
284|274|	)
285|275|
286|276|	# --- Right guard ---
287|277|	_box(
288|278|		guards, "RightGuardTorso",
289|279|		Vector3(1.5, 0.425, -7.5),
290|280|		Vector3(0.42, 0.85, 0.28),
291|281|		mat_stone_dark
292|282|	)
293|283|	var head_r := MeshInstance3D.new()
294|284|	head_r.name = "RightGuardHead"
295|285|	var sphere_r := SphereMesh.new()
296|286|	sphere_r.radius = 0.2
297|287|	sphere_r.height = 0.4
298|288|	sphere_r.radial_segments = 16
299|289|	head_r.mesh = sphere_r
300|290|	head_r.material_override = mat_stone_dark
301|291|	head_r.position = Vector3(1.5, 0.95, -7.5)
302|292|	guards.add_child(head_r)
303|293|	_box(
304|294|		guards, "RightGuardSpear",
305|295|		Vector3(1.72, 0.95, -7.5),
306|296|		Vector3(0.04, 1.9, 0.04),
307|297|		mat_iron
308|298|	)
309|299|