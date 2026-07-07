extends Node3D

const TEX_WOOD := "res://assets/textures/greyford_tavern/dark_wood_planks.png"
const TEX_FLOOR := "res://assets/textures/greyford_tavern/wet_floor_planks.png"
const TEX_PLASTER := "res://assets/textures/greyford_tavern/smoked_plaster.png"
const TEX_BEAMS := "res://assets/textures/greyford_tavern/soot_beams.png"
const TEX_BARREL := "res://assets/textures/greyford_tavern/barrel_staves.png"
const TEX_CRATE := "res://assets/textures/greyford_tavern/crate_boards.png"
const TEX_WINDOW := "res://assets/textures/greyford_tavern/rainy_cold_window.png"
const TEX_CLOTH := "res://assets/textures/greyford_tavern/dirty_towel_cloth.png"
const TEX_PAPER := "res://assets/textures/greyford_tavern/aged_paper.png"
## TykhyShelistArtAssembly — procedural placement of Muri huts on stilts
## Follows the map: huts cluster around platforms, all on piles over sacred waters.

const HUT_SCENE: String = "res://scenes/environment/muri_hut.tscn"

# Hut clusters: North, Central-East, Fishing (South), scattered
const HUT_POSITIONS: Array = [
	# Північний район (North — near Varrik's tower approach)
	Vector3(18, 0.15, -24), Vector3(14, 0.15, -24), Vector3(16, 0.15, -20),
	# Схід (East of Central platform)
	Vector3(6, 0.15, -18), Vector3(9, 0.15, -20), Vector3(5, 0.15, -22),
	# Рибальський район (Fishing — South, near water)
	Vector3(-2, 0.15, -18), Vector3(-4, 0.15, -21), Vector3(-2, 0.15, -24),
	# Лікарський район (Medical — near Kaen's house)
	Vector3(-12, 0.15, -22), Vector3(-15, 0.15, -20), Vector3(-14, 0.15, -25),
	# Захід (West — outskirts)
	Vector3(-22, 0.15, -14), Vector3(-26, 0.15, -18), Vector3(-20, 0.15, -20),
	# Південь (South — near sacred waters)
	Vector3(8, 0.15, -26), Vector3(4, 0.15, -28), Vector3(0, 0.15, -26),
]

func _ready() -> void:
	_spawn_huts()
	_place_piles()

func _spawn_huts() -> void:
	var hut_resource := load(HUT_SCENE) as PackedScene
	if hut_resource == null:
		push_warning("Muri hut scene not found: " + HUT_SCENE)
		return

	for i: int in range(HUT_POSITIONS.size()):
		var hut: Node3D = hut_resource.instantiate()
		hut.name = "Hut_" + str(i + 1)
		hut.position = HUT_POSITIONS[i]
		add_child(hut)

func _place_piles() -> void:
	# Each hut gets a small platform on piles — handled by muri_hut.tscn
	# This ensures every structure stands above the sacred waters
	pass
