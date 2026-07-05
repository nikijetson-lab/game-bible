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
13|3|# Art assembly for Craftsmen Quarter — workshop facades, workstation dressing, courtyard props.
14|4|# Builds visual-only MeshInstance3D nodes. Does NOT create/modify lights or environment.
15|5|# Does NOT touch existing nodes (NPCs, workbench, Label3D placeholders).
16|6|# Canon: bogwood (willow-root from deep Hazemuir), old bog-protection signs above carver's door.
17|7|# Palette: earthy timber, grey plaster, cold high-window light, warm forge glow, grey-brown furs.
18|8|
19|9|var mat_timber: StandardMaterial3D
20|10|var mat_plaster: StandardMaterial3D
21|11|var mat_stone: StandardMaterial3D
22|12|var mat_window: StandardMaterial3D
23|13|var mat_fur_grey: StandardMaterial3D
24|14|var mat_fur_dark: StandardMaterial3D
25|15|var mat_leather: StandardMaterial3D
26|16|var mat_tool_metal: StandardMaterial3D
27|17|var mat_bogwood: StandardMaterial3D
28|18|var mat_shavings: StandardMaterial3D
29|19|var mat_forge: StandardMaterial3D
30|20|var mat_sign: StandardMaterial3D
31|21|
32|22|func _ready() -> void:
33|23|	_create_materials()
34|24|	var root := Node3D.new()
35|25|	root.name = "CraftsmenArtDressing"
36|26|	add_child(root)
37|27|	_build_workshop_facades(root)
38|28|	_build_high_windows(root)
39|29|	_build_woodcarver_station(root)
40|30|	_build_furrier_station(root)
41|31|	_build_courtyard_props(root)
42|32|
43|33|# ---------------------------------------------------------------------------
44|34|# Material helpers
45|35|# ---------------------------------------------------------------------------
46|36|
47|37|func _create_materials() -> void:
48|38|	mat_timber = _mat(Color(0.20, 0.14, 0.08), "", 0.92)
49|39|	mat_plaster = _mat(Color(0.34, 0.33, 0.30), "", 0.95)
50|40|	mat_stone = _mat(Color(0.28, 0.27, 0.25), "", 0.75)
51|41|	mat_window = _mat(Color(0.45, 0.58, 0.66, 0.85), "", 0.6)
52|42|	mat_window.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
53|43|	mat_window.emission_enabled = true
54|44|	mat_window.emission = Color(0.5, 0.65, 0.75)
55|45|	mat_window.emission_energy_multiplier = 0.7
56|46|	mat_fur_grey = _mat(Color(0.38, 0.35, 0.30), "", 1.0)
57|47|	mat_fur_dark = _mat(Color(0.24, 0.20, 0.16), "", 1.0)
58|48|	mat_leather = _mat(Color(0.30, 0.20, 0.12), "", 0.7)
59|49|	mat_tool_metal = _mat(Color(0.32, 0.33, 0.35), "", 0.5)
60|50|	mat_tool_metal.metallic = 0.6
61|51|	mat_bogwood = _mat(Color(0.10, 0.08, 0.06), "", 0.85)
62|52|	mat_shavings = _mat(Color(0.45, 0.35, 0.22), "", 0.7)
63|53|	mat_forge = _mat(Color(0.9, 0.45, 0.12), "", 0.5)
64|54|	mat_forge.emission_enabled = true
65|55|	mat_forge.emission = Color(0.95, 0.4, 0.1)
66|56|	mat_forge.emission_energy_multiplier = 1.6
67|57|	mat_sign = _mat(Color(0.16, 0.20, 0.15), "", 0.6)
68|58|	mat_sign.emission_enabled = true
69|59|	mat_sign.emission = Color(0.25, 0.45, 0.3)
70|60|	mat_sign.emission_energy_multiplier = 0.35
71|61|
72|62|func _mat(color: Color, _texture_path: String, roughness: float) -> StandardMaterial3D:
73|63|	var m := StandardMaterial3D.new()
74|64|	m.albedo_color = color
75|65|	m.roughness = roughness
76|66|	return m
77|67|
78|68|# ---------------------------------------------------------------------------
79|69|# Workshop facades — two timber-frame buildings along the back wall (z = -6)
80|70|# ---------------------------------------------------------------------------
81|71|
82|72|func _build_workshop_facades(parent: Node3D) -> void:
83|73|	var facades := Node3D.new()
84|74|	facades.name = "ArtWorkshopFacades"
85|75|	parent.add_child(facades)
86|76|
87|77|	_var_woodcarver_facade(facades)
88|78|	_var_furrier_facade(facades)
89|79|
90|80|func _var_woodcarver_facade(parent: Node3D) -> void:
91|81|	var f := Node3D.new()
92|82|	f.name = "WoodcarverFacade"
93|83|	parent.add_child(f)
94|84|
95|85|	var cx := -4.0  # centre x
96|86|	var fz := -6.0  # facade z
97|87|	var post_z := fz  # posts flush with plaster
98|88|
99|89|	# Plaster infill 4.6 x 3.2 x 0.22
100|90|	_box(f, "PlasterFill", Vector3(cx, 1.6, fz), Vector3(4.6, 3.2, 0.22), mat_plaster)
101|91|
102|92|	# Corner posts 0.18 x 3.2
103|93|	_box(f, "LeftPost", Vector3(cx - 2.3, 1.6, post_z), Vector3(0.18, 3.2, 0.26), mat_timber)
104|94|	_box(f, "RightPost", Vector3(cx + 2.3, 1.6, post_z), Vector3(0.18, 3.2, 0.26), mat_timber)
105|95|
106|96|	# Diagonal cross brace
107|97|	_box(f, "DiagonalBrace", Vector3(cx, 1.6, fz + 0.12), Vector3(4.8, 0.12, 0.08), mat_timber, Vector3(0, 0, 28))
108|98|
109|99|	# Door at x = -2.8
110|100|	var door_x := -2.8
111|101|	_box(f, "Door", Vector3(door_x, 1.0, fz + 0.12), Vector3(1.0, 2.0, 0.12), mat_timber)
112|102|
113|103|	# Three old bog-protection signs above the door (canon: old bog signs of protection)
114|104|	var sign_y := 2.32
115|105|	var sign_z := fz + 0.14
116|106|	var angles := [10.0, -6.0, 14.0]
117|107|	for i in 3:
118|108|		var sx := door_x + float(i - 1) * 0.18
119|109|		_box(f, "BogSign_%d" % i, Vector3(sx, sign_y, sign_z), Vector3(0.12, 0.18, 0.03), mat_sign, Vector3(0, angles[i], 0))
120|110|
121|111|func _var_furrier_facade(parent: Node3D) -> void:
122|112|	var f := Node3D.new()
123|113|	f.name = "FurrierFacade"
124|114|	parent.add_child(f)
125|115|
126|116|	var cx := 3.6
127|117|	var fz := -6.0
128|118|	var post_z := fz
129|119|
130|120|	# Plaster infill
131|121|	_box(f, "PlasterFill", Vector3(cx, 1.6, fz), Vector3(4.6, 3.2, 0.22), mat_plaster)
132|122|
133|123|	# Corner posts
134|124|	_box(f, "LeftPost", Vector3(cx - 2.3, 1.6, post_z), Vector3(0.18, 3.2, 0.26), mat_timber)
135|125|	_box(f, "RightPost", Vector3(cx + 2.3, 1.6, post_z), Vector3(0.18, 3.2, 0.26), mat_timber)
136|126|
137|127|	# Diagonal cross brace
138|128|	_box(f, "DiagonalBrace", Vector3(cx, 1.6, fz + 0.12), Vector3(4.8, 0.12, 0.08), mat_timber, Vector3(0, 0, -28))
139|129|
140|130|	# Door at x = 4.4 (right side)
141|131|	_box(f, "Door", Vector3(4.4, 1.0, fz + 0.12), Vector3(1.0, 2.0, 0.12), mat_timber)
142|132|
143|133|	# Wide shop window at y = 1.6
144|134|	_box(f, "DisplayWindow", Vector3(cx, 1.6, fz + 0.12), Vector3(1.6, 1.0, 0.06), mat_window)
145|135|
146|136|# ---------------------------------------------------------------------------
147|137|# High narrow windows — cold light from above (canon: like in woodcarver art)
148|138|# ---------------------------------------------------------------------------
149|139|
150|140|func _build_high_windows(parent: Node3D) -> void:
151|141|	var hw := Node3D.new()
152|142|	hw.name = "ArtHighWindows"
153|143|	parent.add_child(hw)
154|144|
155|145|	var fz := -6.0
156|146|	var wz := fz + 0.12
157|147|
158|148|	# 2 windows on woodcarver facade
159|149|	_box_window(hw, "CarverWin_L", Vector3(-4.8, 2.6, wz))
160|150|	_box_window(hw, "CarverWin_R", Vector3(-3.2, 2.6, wz))
161|151|
162|152|	# 2 windows on furrier facade
163|153|	_box_window(hw, "FurrierWin_L", Vector3(2.8, 2.6, wz))
164|154|	_box_window(hw, "FurrierWin_R", Vector3(4.4, 2.6, wz))
165|155|
166|156|func _box_window(parent: Node3D, name: String, pos: Vector3) -> void:
167|157|	var w := Node3D.new()
168|158|	w.name = name
169|159|	w.position = pos
170|160|	parent.add_child(w)
171|161|
172|162|	var ws := Vector3(0.5, 0.8, 0.06)  # window glass size
173|163|	var fw := 0.05  # frame width
174|164|	var fd := 0.04  # frame depth
175|165|
176|166|	_box(w, "Glass", Vector3.ZERO, ws, mat_window)
177|167|	# Frames
178|168|	_box(w, "TopFrame", Vector3(0, ws.y * 0.5 + fw * 0.5, 0), Vector3(ws.x + fw * 2.0, fw, fd), mat_timber)
179|169|	_box(w, "BottomFrame", Vector3(0, -ws.y * 0.5 - fw * 0.5, 0), Vector3(ws.x + fw * 2.0, fw, fd), mat_timber)
180|170|	_box(w, "LeftFrame", Vector3(-ws.x * 0.5 - fw * 0.5, 0, 0), Vector3(fw, ws.y + fw * 2.0, fd), mat_timber)
181|171|	_box(w, "RightFrame", Vector3(ws.x * 0.5 + fw * 0.5, 0, 0), Vector3(fw, ws.y + fw * 2.0, fd), mat_timber)
182|172|
183|173|# ---------------------------------------------------------------------------
184|174|# Woodcarver station — shelf, bogwood blanks, willow-root, tools, shavings
185|175|# Canon: bogwood (willow-root from deep Hazemuir) — key to Pathfinder branch
186|176|# ---------------------------------------------------------------------------
187|177|
188|178|func _build_woodcarver_station(parent: Node3D) -> void:
189|179|	var s := Node3D.new()
190|180|	s.name = "ArtWoodcarverStation"
191|181|	parent.add_child(s)
192|182|
193|183|	# Shelf unit near workbench (workbench centre ~ -1.6, 0.65, -1.95)
194|184|	var sp := Vector3(-2.4, 0.9, -2.8)
195|185|
196|186|	# Frame 1.4 x 1.8 x 0.35
197|187|	_box(s, "ShelfFrame", sp, Vector3(1.4, 1.8, 0.35), mat_timber)
198|188|
199|189|	# 3 shelves inside the frame
200|190|	var shelf_y := [-0.55, 0.0, 0.55]
201|191|	for i in 3:
202|192|		_box(s, "Shelf_%d" % i, sp + Vector3(0.0, shelf_y[i], 0.08), Vector3(1.3, 0.05, 0.30), mat_timber)
203|193|
204|194|	# 5 bogwood blanks scattered across shelves
205|195|	var bz := -2.68
206|196|	_box(s, "BogBlank1", Vector3(-2.3, 0.43, bz), Vector3(0.5, 0.12, 0.12), mat_bogwood, Vector3(0, 5, 2))
207|197|	_box(s, "BogBlank2", Vector3(-2.6, 0.40, bz), Vector3(0.35, 0.10, 0.10), mat_bogwood, Vector3(0, -8, -1))
208|198|	_box(s, "BogBlank3", Vector3(-2.2, 0.98, bz), Vector3(0.45, 0.12, 0.12), mat_bogwood, Vector3(0, 12, 3))
209|199|	_box(s, "BogBlank4", Vector3(-2.65, 0.95, bz), Vector3(0.30, 0.08, 0.10), mat_bogwood, Vector3(0, -4, 0))
210|200|	_box(s, "BogBlank5", Vector3(-2.35, 1.53, bz), Vector3(0.40, 0.10, 0.12), mat_bogwood, Vector3(0, 7, -2))
211|201|
212|202|	# LONG willow-root leaning on the shelf (canon: willow-root from deep Hazemuir)
213|203|	_box(s, "WillowRoot", Vector3(-1.55, 0.55, -2.95), Vector3(0.22, 0.22, 1.7), mat_bogwood, Vector3(0, 25, 35))
214|204|
215|205|	# 3 chisels on the workbench (tool_metal)
216|206|	for i in 3:
217|207|		var tx := -1.4 + float(i - 1) * 0.12
218|208|		_box(s, "Chisel_%d" % i, Vector3(tx, 0.82, -1.82), Vector3(0.04, 0.03, 0.28), mat_tool_metal, Vector3(0, 5.0 + float(i) * 8.0, 0))
219|209|
220|210|	# 3 flat shavings at angles
221|211|	for i in 3:
222|212|		var sx := -1.7 + float(i) * 0.12
223|213|		var srot := float(i) * 18.0 - 18.0
224|214|		_box(s, "Shaving_%d" % i, Vector3(sx, 0.78, -1.68), Vector3(0.3, 0.03, 0.25), mat_shavings, Vector3(0, 0, srot))
225|215|
226|216|# ---------------------------------------------------------------------------
227|217|# Furrier station — drying frame with hanging furs, counter with rolled pelts
228|218|# ---------------------------------------------------------------------------
229|219|
230|220|func _build_furrier_station(parent: Node3D) -> void:
231|221|	var s := Node3D.new()
232|222|	s.name = "ArtFurrierStation"
233|223|	parent.add_child(s)
234|224|
235|225|	var fx := 3.0
236|226|	var fz := -2.8
237|227|
238|228|	# Drying frame — 2 posts + crossbar
239|229|	_box(s, "FramePostL", Vector3(fx - 1.2, 1.1, fz), Vector3(0.1, 2.2, 0.1), mat_timber)
240|230|	_box(s, "FramePostR", Vector3(fx + 1.2, 1.1, fz), Vector3(0.1, 2.2, 0.1), mat_timber)
241|231|	_box(s, "FrameCrossbar", Vector3(fx, 2.2, fz), Vector3(2.4, 0.08, 0.08), mat_timber)
242|232|
243|233|	# 4 hanging furs with slight tilt and ragged bottom edge
244|234|	var furs := [
245|235|		[-0.9, 3.0, mat_fur_grey],
246|236|		[-0.3, -5.0, mat_fur_dark],
247|237|		[0.3, 8.0, mat_fur_grey],
248|238|		[0.9, -3.0, mat_fur_dark]
249|239|	]
250|240|	for data in furs:
251|241|		var ox := data[0] as float
252|242|		var rot := data[1] as float
253|243|		var fm := data[2] as StandardMaterial3D
254|244|		var fp := Vector3(fx + ox, 1.65, fz)
255|245|
256|246|		# Main fur body
257|247|		_box(s, "FurMain_%.1f" % ox, fp, Vector3(0.55, 1.1, 0.06), fm, Vector3(0, 0, rot))
258|248|		# Ragged lower edge — a shorter box offset downward
259|249|		_box(s, "FurRag_%.1f" % ox, fp + Vector3(0.06, -0.48, 0.01), Vector3(0.40, 0.22, 0.05), fm, Vector3(0, 0, rot + 5.0))
260|250|
261|251|	# Counter in front of the drying frame
262|252|	_box(s, "Counter", Vector3(fx, 0.475, fz + 1.0), Vector3(1.8, 0.95, 0.6), mat_timber)
263|253|
264|254|	# 3 rolled furs on the counter
265|255|	var rolls := [
266|256|		[-0.4, mat_fur_grey],
267|257|		[0.1, mat_fur_dark],
268|258|		[0.55, mat_fur_grey]
269|259|	]
270|260|	for data in rolls:
271|261|		var ox := data[0] as float
272|262|		var rm := data[1] as StandardMaterial3D
273|263|		_box(s, "RolledFur_%.1f" % ox, Vector3(fx + ox, 0.96, fz + 1.0), Vector3(0.5, 0.18, 0.18), rm)
274|264|
275|265|# ---------------------------------------------------------------------------
276|266|# Courtyard props — forge, barrels, plank stack, cart
277|267|# ---------------------------------------------------------------------------
278|268|
279|269|func _build_courtyard_props(parent: Node3D) -> void:
280|270|	var p := Node3D.new()
281|271|	p.name = "ArtCourtyardProps"
282|272|	parent.add_child(p)
283|273|
284|274|	# --- Small forge between workshops ---
285|275|	# Stone base
286|276|	_box(p, "ForgeBase", Vector3(0, 0.35, -5.0), Vector3(0.8, 0.7, 0.8), mat_stone)
287|277|	# Fire opening (front face)
288|278|	_box(p, "ForgeFire", Vector3(0, 0.55, -4.58), Vector3(0.35, 0.3, 0.05), mat_forge)
289|279|	# Chimney
290|280|	_box(p, "ForgeChimney", Vector3(0, 1.15, -5.0), Vector3(0.3, 1.6, 0.3), mat_stone)
291|281|
292|282|	# --- 2 barrels (cylindrical approx with box) ---
293|283|	_box(p, "Barrel1", Vector3(-1.2, 0.35, -4.5), Vector3(0.5, 0.7, 0.5), mat_timber)
294|284|	_box(p, "Barrel2", Vector3(1.2, 0.35, -4.8), Vector3(0.5, 0.7, 0.5), mat_timber)
295|285|
296|286|	# --- Stack of planks ---
297|287|	for i in 4:
298|288|		var off := Vector3(float(i) * 0.03, float(i) * 0.055, float(i) * 0.02)
299|289|		_box(p, "Plank_%d" % i, Vector3(-2.4, 0.03, -4.0) + off, Vector3(1.6, 0.06, 0.25), mat_timber)
300|290|
301|291|	# --- Hand cart ---
302|292|	var cx := 2.0
303|293|	var cz := -4.2
304|294|	# Platform
305|295|	_box(p, "CartPlatform", Vector3(cx, 0.075, cz), Vector3(1.2, 0.15, 0.8), mat_timber)
306|296|	# Wheels (wide flat disc on each side)
307|297|	_box(p, "CartWheelL", Vector3(cx - 0.65, 0.45, cz), Vector3(0.5, 0.5, 0.08), mat_timber)
308|298|	_box(p, "CartWheelR", Vector3(cx + 0.65, 0.45, cz), Vector3(0.5, 0.5, 0.08), mat_timber)
309|299|
310|300|# ---------------------------------------------------------------------------
311|301|# Mesh helpers
312|302|# ---------------------------------------------------------------------------
313|303|
314|304|func _box(parent: Node3D, name: String, pos: Vector3, size: Vector3, material: Material,
315|305|	rot_deg: Vector3 = Vector3.ZERO) -> MeshInstance3D:
316|306|	var mesh := BoxMesh.new()
317|307|	mesh.size = size
318|308|	var mi := MeshInstance3D.new()
319|309|	mi.name = name
320|310|	mi.mesh = mesh
321|311|	mi.material_override = material
322|312|	mi.position = pos
323|313|	mi.rotation_degrees = rot_deg
324|314|	parent.add_child(mi)
325|315|	return mi
326|316|