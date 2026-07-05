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
12|2|## GuildWarehouseArtAssembly — Trade Guild warehouse interior, crates, shelves
13|3|
14|4|@export var build_on_ready: bool = true
15|5|
16|6|func _ready() -> void:
17|7|	if build_on_ready:
18|8|		await get_tree().process_frame
19|9|		build_warehouse()
20|10|
21|11|func build_warehouse() -> void:
22|12|	var n := Node3D.new(); n.name = "Architecture"; add_child(n); var p = n
23|13|	var wood := Color(0.2, 0.12, 0.06, 1)
24|14|	# Walls
25|15|	_box(p, Vector3(8, 3.5, 0.3), Vector3(0, 1.8, -4), wood)
26|16|	_box(p, Vector3(8, 3.5, 0.3), Vector3(0, 1.8, 4), wood)
27|17|	_box(p, Vector3(0.3, 3.5, 8), Vector3(-4, 1.8, 0), wood)
28|18|	_box(p, Vector3(0.3, 3.5, 8), Vector3(4, 1.8, 0), wood)
29|19|	# Floor
30|20|	_box(p, Vector3(8, 0.1, 8), Vector3(0, -0.05, 0), Color(0.15, 0.09, 0.05, 1))
31|21|	# Shelves
32|22|	for row in range(3):
33|23|		var z := -2.5 + row * 2.5
34|24|		_box(p, Vector3(3, 2.5, 0.15), Vector3(2, 1.3, z), wood)
35|25|		for shelf in range(3):
36|26|			_box(p, Vector3(2.8, 0.05, 0.3), Vector3(2, 0.7 + shelf * 0.8, z), Color(0.25, 0.15, 0.08, 1))
37|27|	# Crates
38|28|	for i in range(5):
39|29|		_box(p, Vector3(0.5, 0.5, 0.5), Vector3(randf_range(-2.5, 2.5), 0.25, randf_range(-2, 2)), Color(0.35, 0.22, 0.12, 1))
40|30|
41|31|func _box(parent: Node3D, size: Vector3, pos: Vector3, color: Color) -> void:
42|32|	var mi := MeshInstance3D.new(); var mat := StandardMaterial3D.new()
43|33|	mat.albedo_color = color; mat.roughness = 0.9
44|34|	var bm := BoxMesh.new(); bm.size = size; bm.material = mat
45|35|	mi.mesh = bm; mi.position = pos; parent.add_child(mi)
46|36|