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
12|2|## TykhyShelistArtAssembly — procedural placement of Muri huts on stilts
13|3|## Follows the map: huts cluster around platforms, all on piles over sacred waters.
14|4|
15|5|const HUT_SCENE: String = "res://scenes/environment/muri_hut.tscn"
16|6|
17|7|# Hut clusters: North, Central-East, Fishing (South), scattered
18|8|const HUT_POSITIONS: Array = [
19|9|	# Північний район (North — near Varrik's tower approach)
20|10|	Vector3(18, 0.15, -24), Vector3(14, 0.15, -24), Vector3(16, 0.15, -20),
21|11|	# Схід (East of Central platform)
22|12|	Vector3(6, 0.15, -18), Vector3(9, 0.15, -20), Vector3(5, 0.15, -22),
23|13|	# Рибальський район (Fishing — South, near water)
24|14|	Vector3(-2, 0.15, -18), Vector3(-4, 0.15, -21), Vector3(-2, 0.15, -24),
25|15|	# Лікарський район (Medical — near Kaen's house)
26|16|	Vector3(-12, 0.15, -22), Vector3(-15, 0.15, -20), Vector3(-14, 0.15, -25),
27|17|	# Захід (West — outskirts)
28|18|	Vector3(-22, 0.15, -14), Vector3(-26, 0.15, -18), Vector3(-20, 0.15, -20),
29|19|	# Південь (South — near sacred waters)
30|20|	Vector3(8, 0.15, -26), Vector3(4, 0.15, -28), Vector3(0, 0.15, -26),
31|21|]
32|22|
33|23|func _ready() -> void:
34|24|	_spawn_huts()
35|25|	_place_piles()
36|26|
37|27|func _spawn_huts() -> void:
38|28|	var hut_resource := load(HUT_SCENE) as PackedScene
39|29|	if hut_resource == null:
40|30|		push_warning("Muri hut scene not found: " + HUT_SCENE)
41|31|		return
42|32|
43|33|	for i: int in range(HUT_POSITIONS.size()):
44|34|		var hut: Node3D = hut_resource.instantiate()
45|35|		hut.name = "Hut_" + str(i + 1)
46|36|		hut.position = HUT_POSITIONS[i]
47|37|		add_child(hut)
48|38|
49|39|func _place_piles() -> void:
50|40|	# Each hut gets a small platform on piles — handled by muri_hut.tscn
51|41|	# This ensures every structure stands above the sacred waters
52|42|	pass
53|43|