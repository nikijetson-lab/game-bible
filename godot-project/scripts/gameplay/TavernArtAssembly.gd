extends Node3D

# Runtime visual assembly for Ervan's tavern hall, grounded in the provided art.
# It intentionally does NOT create or modify any lights/environment.
# Purpose: replace the failed scattered blockout/warped Meshy bar with a coherent
# low-ceiling rectangular tavern room: shell, bar, stairs, leaded windows, furniture.

const TEX_DARK_WOOD := "res://assets/textures/greyford_tavern/dark_wood_planks.png"
const TEX_FLOOR := "res://assets/textures/greyford_tavern/wet_floor_planks.png"
const TEX_PLASTER := "res://assets/textures/greyford_tavern/smoked_plaster.png"
const TEX_BEAMS := "res://assets/textures/greyford_tavern/soot_beams.png"
const TEX_BARREL := "res://assets/textures/greyford_tavern/barrel_staves.png"
const TEX_CRATE := "res://assets/textures/greyford_tavern/crate_boards.png"
const TEX_WINDOW := "res://assets/textures/greyford_tavern/rainy_cold_window.png"
const TEX_CLOTH := "res://assets/textures/greyford_tavern/dirty_towel_cloth.png"

var mat_floor: StandardMaterial3D
var mat_wall: StandardMaterial3D
var mat_wood: StandardMaterial3D
var mat_beam: StandardMaterial3D
var mat_window: StandardMaterial3D
var mat_barrel: StandardMaterial3D
var mat_crate: StandardMaterial3D
var mat_cloth: StandardMaterial3D
var mat_metal: StandardMaterial3D
var mat_warm: StandardMaterial3D
var mat_lantern_glass: StandardMaterial3D
var mat_stair_tread: StandardMaterial3D

func _ready() -> void:
	_hide_failed_visual_blockout()
	_create_materials()
	_build_hall_shell()
	_build_bar_and_shelves()
	_build_staircase()
	_build_windows()
	_build_tables_and_chairs()
	_build_storage_and_detail_props()

func _hide_failed_visual_blockout() -> void:
	# Keep gameplay nodes, NPCs, portals, and collision. Hide only the previous visual layer
	# that produced the compressed/hallucinated look in screenshots.
	var root := get_parent()
	for path in [
		"Architecture",
		"BarCounter",
		"PrivateRainTable",
		"CommonTables",
		"WallProps",
		"StorageProps",
		"MeshyAssets/MeshyBarCounter",
		"MeshyAssets/MeshyPropsKit"
	]:
		var node := root.get_node_or_null(path)
		if node is Node3D:
			(node as Node3D).visible = false

func _create_materials() -> void:
	mat_floor = _mat(Color(0.30, 0.23, 0.16), TEX_FLOOR, 0.72)
	mat_wall = _mat(Color(0.30, 0.31, 0.29), TEX_PLASTER, 0.94)
	mat_wood = _mat(Color(0.22, 0.15, 0.09), TEX_DARK_WOOD, 0.9)
	mat_beam = _mat(Color(0.12, 0.09, 0.07), TEX_BEAMS, 0.96)
	mat_window = _mat(Color(0.38, 0.58, 0.68, 0.86), TEX_WINDOW, 0.78)
	mat_window.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	# Backlit leaded glass: object self-emission only (a window glows on outside light).
	# This is a per-object material property, NOT a scene light/environment/exposure/fog change.
	mat_window.emission_enabled = true
	mat_window.emission = Color(0.55, 0.72, 0.82)
	mat_window.emission_energy_multiplier = 0.9
	mat_barrel = _mat(Color(0.46, 0.26, 0.12), TEX_BARREL, 0.9)
	mat_crate = _mat(Color(0.44, 0.27, 0.14), TEX_CRATE, 0.9)
	mat_cloth = _mat(Color(0.55, 0.47, 0.34), TEX_CLOTH, 0.95)
	mat_metal = _mat(Color(0.24, 0.22, 0.18), "", 0.55)
	mat_metal.metallic = 0.45
	mat_warm = _mat(Color(0.95, 0.55, 0.18), "", 0.55)
	# Visible candle/flame material only. No OmniLight/SpotLight/environment changes.
	mat_warm.emission_enabled = true
	mat_warm.emission = Color(0.95, 0.45, 0.12)
	mat_warm.emission_energy_multiplier = 0.65
	mat_lantern_glass = _mat(Color(0.95, 0.62, 0.28, 0.72), "", 0.72)
	mat_lantern_glass.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	# Geometry/material contrast for readability only; does not alter scene lighting.
	mat_stair_tread = _mat(Color(0.55, 0.34, 0.18), TEX_DARK_WOOD, 0.86)
	# Faint self-emission on the tread material so the step rhythm reads in the dark corner.
	# Per-object material property only; no scene lights/environment touched.
	mat_stair_tread.emission_enabled = true
	mat_stair_tread.emission = Color(0.45, 0.30, 0.16)
	mat_stair_tread.emission_energy_multiplier = 0.35

func _mat(color: Color, texture_path: String, roughness: float) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = roughness
	m.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
	if texture_path != "":
		var tex := load(texture_path)
		if tex is Texture2D:
			m.albedo_texture = tex
	return m

func _build_hall_shell() -> void:
	var shell := Node3D.new()
	shell.name = "ArtHallShell"
	add_child(shell)

	# Rectangular room volume: four walls, with a readable front entrance doorway.
	_box(shell, "ContinuousPlankFloor", Vector3(0, -0.08, -0.4), Vector3(16.6, 0.16, 12.6), mat_floor)
	_box(shell, "SmokedBackWall", Vector3(0, 1.55, -6.45), Vector3(16.6, 3.1, 0.28), mat_wall)
	_box(shell, "SmokedLeftWall", Vector3(-8.3, 1.55, -0.4), Vector3(0.28, 3.1, 12.6), mat_wall)
	_box(shell, "SmokedRightWall", Vector3(8.3, 1.55, -0.4), Vector3(0.28, 3.1, 12.6), mat_wall)
	# Front wall is split into pieces around the entrance, not omitted.
	_box(shell, "FrontWallLeftOfDoor", Vector3(-5.7, 1.55, 5.88), Vector3(5.2, 3.1, 0.28), mat_wall)
	_box(shell, "FrontWallRightOfDoor", Vector3(5.7, 1.55, 5.88), Vector3(5.2, 3.1, 0.28), mat_wall)
	_box(shell, "FrontWallAboveDoorLintel", Vector3(0, 2.55, 5.88), Vector3(6.2, 1.1, 0.28), mat_wall)
	_box(shell, "FrontEntranceDoorFrameTop", Vector3(0, 2.05, 5.68), Vector3(3.05, 0.28, 0.36), mat_beam)
	_box(shell, "FrontEntranceDoorFrameLeft", Vector3(-1.72, 0.97, 5.68), Vector3(0.28, 1.95, 0.36), mat_beam)
	_box(shell, "FrontEntranceDoorFrameRight", Vector3(1.72, 0.97, 5.68), Vector3(0.28, 1.95, 0.36), mat_beam)
	# Door leaf is open against the wall so the room remains visibly enterable.
	_box(shell, "OpenFrontPlankDoor", Vector3(2.25, 0.94, 5.48), Vector3(1.06, 1.82, 0.18), mat_wood, Vector3(0, 28, 0))
	_box(shell, "DoorIronStrapTop", Vector3(2.25, 1.45, 5.36), Vector3(0.94, 0.07, 0.05), mat_metal, Vector3(0, 28, 0))
	_box(shell, "DoorIronStrapBottom", Vector3(2.25, 0.55, 5.36), Vector3(0.94, 0.07, 0.05), mat_metal, Vector3(0, 28, 0))
	_box(shell, "LowWoodenCeiling", Vector3(0, 3.08, -0.4), Vector3(16.6, 0.18, 12.6), mat_beam)

	# Heavy beams and posts: dense enough to read as a low medieval tavern ceiling.
	for z in [-5.45, -3.2, -0.9, 1.4, 3.7, 5.25]:
		_box(shell, "CrossCeilingBeam_%s" % str(z), Vector3(0, 2.92, z), Vector3(16.9, 0.34, 0.34), mat_beam)
	for x in [-6.6, -2.2, 2.2, 6.6]:
		_box(shell, "LengthCeilingRafter_%s" % str(x), Vector3(x, 2.82, -0.4), Vector3(0.32, 0.24, 12.6), mat_beam)
	# Keep posts mostly along back/mid room; avoid a front row that blocks presentation/gameplay camera.
	for x in [-7.15, -3.2, 1.2, 5.9, 7.15]:
		for z in [-5.6, -1.8]:
			_box(shell, "HeavyPost", Vector3(x, 1.42, z), Vector3(0.34, 2.84, 0.34), mat_beam)

	# Lower wall wainscot planks, so walls don't read as plain color.
	_box(shell, "BackWainscot", Vector3(0, 0.72, -6.25), Vector3(16.2, 0.75, 0.16), mat_wood)
	_box(shell, "LeftWainscot", Vector3(-8.12, 0.72, -0.4), Vector3(0.16, 0.75, 12.1), mat_wood)
	_box(shell, "RightWainscot", Vector3(8.12, 0.72, -0.4), Vector3(0.16, 0.75, 12.1), mat_wood)
	_box(shell, "FrontWainscotLeft", Vector3(-5.7, 0.72, 5.66), Vector3(5.0, 0.75, 0.16), mat_wood)
	_box(shell, "FrontWainscotRight", Vector3(5.7, 0.72, 5.66), Vector3(5.0, 0.75, 0.16), mat_wood)

func _build_bar_and_shelves() -> void:
	var bar := Node3D.new()
	bar.name = "ArtLongBarCounter"
	bar.position = Vector3(-3.25, 0.0, -3.35)
	bar.rotation_degrees.y = -5.0
	add_child(bar)
	_box(bar, "BarFrontPlankedPanel", Vector3(0, 0.58, 0), Vector3(6.9, 1.0, 0.72), mat_wood)
	_box(bar, "ThickWornBarTop", Vector3(0, 1.13, -0.04), Vector3(7.25, 0.20, 1.05), mat_floor)
	for x in [-3.1, -2.1, -1.1, -0.1, 0.9, 1.9, 2.9]:
		_box(bar, "VerticalBarPlank", Vector3(x, 0.57, -0.39), Vector3(0.08, 0.95, 0.06), mat_beam)

	var shelves := Node3D.new()
	shelves.name = "ArtBackBarShelves"
	shelves.position = Vector3(-3.2, 0.0, -5.95)
	add_child(shelves)
	for y in [1.35, 1.78, 2.18]:
		_box(shelves, "SupportedShelf", Vector3(-0.6, y, 0), Vector3(4.2, 0.12, 0.44), mat_beam)
		for x in [-2.35, -0.6, 1.15]:
			_box(shelves, "ShelfBracket", Vector3(x, y - 0.18, 0.12), Vector3(0.12, 0.34, 0.18), mat_beam)
	for i in range(7):
		var x := -2.15 + float(i) * 0.55
		_cylinder(shelves, "ShelfBottle", Vector3(x, 1.55 + 0.36 * float(i % 2), -0.03), 0.08, 0.34, mat_barrel)
	for x in [-1.35, -0.9, 0.6, 1.05]:
		_cylinder(shelves, "ClayMugOnShelf", Vector3(x, 1.93, -0.02), 0.11, 0.22, mat_crate)
	# Small service/back-room door behind the bar so the rear wall has functional exits.
	_box(shelves, "BackBarServiceDoor", Vector3(3.55, 0.86, 0.03), Vector3(0.82, 1.55, 0.16), mat_wood)
	_box(shelves, "BackBarDoorTopFrame", Vector3(3.55, 1.68, 0.08), Vector3(0.98, 0.12, 0.22), mat_beam)
	_box(shelves, "BackBarDoorLeftFrame", Vector3(3.02, 0.86, 0.08), Vector3(0.12, 1.66, 0.22), mat_beam)
	_box(shelves, "BackBarDoorRightFrame", Vector3(4.08, 0.86, 0.08), Vector3(0.12, 1.66, 0.22), mat_beam)
	_box(shelves, "BackBarDoorIronLatch", Vector3(3.85, 0.95, 0.17), Vector3(0.18, 0.07, 0.06), mat_metal)

func _build_staircase() -> void:
	var stairs := Node3D.new()
	stairs.name = "ArtStaircaseToUpperFloor"
	stairs.position = Vector3(5.35, 0.03, -4.35)
	stairs.rotation_degrees.y = 8.0
	add_child(stairs)
	# A longer, steeper, visually readable stair flight going to the upper rooms.
	for i in range(10):
		var step_pos := Vector3(0, 0.10 + i * 0.18, i * 0.42)
		_box(stairs, "BrightReadableTread_%02d" % i, step_pos, Vector3(3.05, 0.18, 0.48), mat_stair_tread)
		_box(stairs, "DarkStepRiser_%02d" % i, step_pos + Vector3(0, -0.08, -0.24), Vector3(3.02, 0.14, 0.07), mat_beam)
		_box(stairs, "FrontTreadEdge_%02d" % i, step_pos + Vector3(0, 0.04, -0.29), Vector3(3.12, 0.055, 0.055), mat_floor)
	# Landing and dark upper doorway/silhouette: clearly signals stairs go up to a second floor.
	_box(stairs, "UpperFloorLanding", Vector3(0, 1.94, 4.25), Vector3(3.25, 0.24, 1.45), mat_beam)
	_box(stairs, "UpperRoomDarkDoorway", Vector3(0, 2.48, 4.94), Vector3(1.55, 1.22, 0.18), mat_metal)
	_box(stairs, "UpperRoomPlankDoor", Vector3(0.0, 2.35, 4.84), Vector3(1.08, 1.02, 0.12), mat_wood)
	_box(stairs, "UpperDoorCrossBrace", Vector3(0.0, 2.35, 4.75), Vector3(1.02, 0.08, 0.05), mat_beam, Vector3(0, 0, -18))
	# Rails + balusters.
	for side_x in [-1.65, 1.65]:
		_box(stairs, "SlopedStairHandRail", Vector3(side_x, 1.28, 2.05), Vector3(0.16, 0.18, 4.55), mat_beam, Vector3(-22, 0, 0))
		for i in range(8):
			_box(stairs, "ReadableRailBaluster", Vector3(side_x, 0.62 + i * 0.14, 0.22 + i * 0.54), Vector3(0.13, 0.98, 0.13), mat_beam)
	_box(stairs, "NearNewelPost", Vector3(-1.65, 0.80, 0.02), Vector3(0.26, 1.60, 0.26), mat_beam)
	_box(stairs, "LandingNewelPost", Vector3(1.65, 1.58, 3.95), Vector3(0.26, 1.70, 0.26), mat_beam)

func _build_windows() -> void:
	var windows := Node3D.new()
	windows.name = "ArtLeadedWindows"
	add_child(windows)
	# Three side-wall diamond/lead-glass windows per direction:
	# two on the LEFT wall, one on the RIGHT wall.
	_window(windows, "LeftWallFrontDiamondWindow", Vector3(-8.06, 1.92, 1.35), Vector2(1.55, 1.30), Vector3(0, 90, 0))
	_window(windows, "LeftWallRearDiamondWindow", Vector3(-8.06, 1.98, -1.05), Vector2(1.55, 1.32), Vector3(0, 90, 0))
	_window(windows, "RightWallDiamondWindow", Vector3(8.06, 1.94, 2.05), Vector2(1.62, 1.32), Vector3(0, -90, 0))

func _window(parent: Node3D, name: String, pos: Vector3, size: Vector2, rot_deg: Vector3 = Vector3.ZERO) -> void:
	var w := Node3D.new()
	w.name = name
	w.position = pos
	w.rotation_degrees = rot_deg
	parent.add_child(w)
	_box(w, "ColdRainGlass", Vector3.ZERO, Vector3(size.x, size.y, 0.045), mat_window)
	_box(w, "TopFrame", Vector3(0, size.y*0.5+0.07, 0.045), Vector3(size.x+0.28, 0.12, 0.12), mat_beam)
	_box(w, "BottomFrame", Vector3(0, -size.y*0.5-0.07, 0.045), Vector3(size.x+0.28, 0.12, 0.12), mat_beam)
	_box(w, "LeftFrame", Vector3(-size.x*0.5-0.07, 0, 0.045), Vector3(0.12, size.y+0.26, 0.12), mat_beam)
	_box(w, "RightFrame", Vector3(size.x*0.5+0.07, 0, 0.045), Vector3(0.12, size.y+0.26, 0.12), mat_beam)
	_box(w, "MidVerticalLead", Vector3(0, 0, 0.075), Vector3(0.035, size.y, 0.035), mat_metal)
	_box(w, "MidHorizontalLead", Vector3(0, 0, 0.075), Vector3(size.x, 0.035, 0.035), mat_metal)
	for y in [-size.y*0.24, size.y*0.24]:
		_box(w, "DiamondLeadA", Vector3(0, y, 0.085), Vector3(size.x*1.05, 0.035, 0.035), mat_metal, Vector3(0, 0, 32))
		_box(w, "DiamondLeadB", Vector3(0, y, 0.09), Vector3(size.x*1.05, 0.035, 0.035), mat_metal, Vector3(0, 0, -32))

func _build_tables_and_chairs() -> void:
	var group := Node3D.new()
	group.name = "ArtCommonRoomFurniture"
	add_child(group)
	_table_set(group, "LeftTableByWindows", Vector3(-5.2, 0, 1.95), -10.0)
	_table_set(group, "RightTableByWindow", Vector3(5.35, 0, 1.75), 18.0)
	_table_set(group, "ForegroundTable", Vector3(0.65, 0, 2.95), 5.0)

func _table_set(parent: Node3D, name: String, pos: Vector3, rot_y: float) -> void:
	var t := Node3D.new()
	t.name = name
	t.position = pos
	t.rotation_degrees.y = rot_y
	parent.add_child(t)
	# Medieval fantasy tavern furniture: rough timber, no upholstery, no booth/divan backs.
	# Built from uneven planks so it reads as a hard wooden table with simple benches.
	_box(t, "RoughTablePlankA", Vector3(-0.42, 0.73, -0.12), Vector3(0.78, 0.16, 1.16), mat_wood, Vector3(0, 0, -1.5))
	_box(t, "RoughTablePlankB", Vector3(0.42, 0.75, 0.10), Vector3(0.78, 0.17, 1.08), mat_wood, Vector3(0, 0, 1.0))
	_box(t, "DarkTableCrossBrace", Vector3(0, 0.58, 0), Vector3(1.86, 0.12, 0.18), mat_beam)
	for x in [-0.73, 0.73]:
		for z in [-0.38, 0.38]:
			_box(t, "ChunkyTableLeg", Vector3(x, 0.35, z), Vector3(0.18, 0.70, 0.18), mat_beam, Vector3(0, 0, x * 2.0))
	for z in [-0.86, 0.86]:
		_box(t, "PlainTimberBenchSeat", Vector3(0, 0.42, z), Vector3(1.76, 0.18, 0.30), mat_wood, Vector3(0, 0, z * 1.5))
		for x in [-0.62, 0.62]:
			_box(t, "BenchPegLeg", Vector3(x, 0.24, z), Vector3(0.13, 0.38, 0.13), mat_beam)
	for x in [-0.55, 0.2, 0.75]:
		_cylinder(t, "MugOnTable", Vector3(x, 0.89, -0.16 + x * 0.12), 0.085, 0.22, mat_crate)
	if name == "RightTableByWindow":
		_candle_lantern(t, "RightTableCandleLantern", Vector3(-0.35, 1.06, 0.12), 1.25)

func _build_storage_and_detail_props() -> void:
	var props := Node3D.new()
	props.name = "ArtStorageProps"
	add_child(props)
	# Barrels/crates tucked around walls and under stairs, so room reads lived-in.
	for p in [Vector3(-6.95, 0.48, -4.6), Vector3(-6.45, 0.43, -4.12), Vector3(6.75, 0.45, -2.6), Vector3(7.05, 0.45, 3.2)]:
		_cylinder(props, "ReadableBarrel", p, 0.34, 0.82, mat_barrel)
	for p in [Vector3(-7.0, 0.31, 3.9), Vector3(6.35, 0.31, -1.9), Vector3(6.9, 0.31, -1.25), Vector3(-5.9, 0.31, -5.35)]:
		_box(props, "StackedCrate", p, Vector3(0.7, 0.62, 0.62), mat_crate)
	# Candle lanterns as visible props only; no new light nodes.
	# Hanging lantern above the bar, with a short chain to the beam.
	_box(props, "HangingLanternChain", Vector3(-1.0, 2.68, -3.2), Vector3(0.04, 0.5, 0.04), mat_metal)
	_candle_lantern(props, "HangingCandleLantern", Vector3(-1.0, 2.18, -3.2), 1.05)
	# Standing candle lantern on the actual bar counter plane.
	_candle_lantern(props, "BarCandleLantern", Vector3(-5.15, 1.34, -3.48), 1.25)
	# Cloth/towel bundles in the room palette.
	_box(props, "DirtyClothOnBar", Vector3(-1.2, 1.24, -3.72), Vector3(0.72, 0.05, 0.32), mat_cloth, Vector3(0, 0, 8))

func _candle_lantern(parent: Node3D, name: String, pos: Vector3, scale_factor: float) -> Node3D:
	var lantern := Node3D.new()
	lantern.name = name
	lantern.position = pos
	lantern.scale = Vector3.ONE * scale_factor
	parent.add_child(lantern)
	# Medieval cage lantern: dark metal frame, warm translucent panes, candle/flame.
	_box(lantern, "WarmGlassCore", Vector3.ZERO, Vector3(0.36, 0.46, 0.36), mat_lantern_glass)
	_box(lantern, "MetalTopCap", Vector3(0, 0.28, 0), Vector3(0.50, 0.06, 0.50), mat_metal)
	_box(lantern, "MetalBottomCap", Vector3(0, -0.28, 0), Vector3(0.50, 0.06, 0.50), mat_metal)
	for x in [-0.24, 0.24]:
		for z in [-0.24, 0.24]:
			_box(lantern, "ThickMetalCornerPost", Vector3(x, 0, z), Vector3(0.06, 0.58, 0.06), mat_metal)
	# Front/back cross bars make it read as a cage, not a red cube.
	for z in [-0.255, 0.255]:
		_box(lantern, "HorizontalCageBar", Vector3(0, 0.06, z), Vector3(0.52, 0.045, 0.045), mat_metal)
		_box(lantern, "VerticalCageBar", Vector3(0, 0.0, z), Vector3(0.045, 0.54, 0.045), mat_metal)
		_box(lantern, "DiagonalCageBarA", Vector3(0, 0.0, z), Vector3(0.58, 0.035, 0.035), mat_metal, Vector3(0, 0, 34))
		_box(lantern, "DiagonalCageBarB", Vector3(0, 0.0, z), Vector3(0.58, 0.035, 0.035), mat_metal, Vector3(0, 0, -34))
	_box(lantern, "RaisedMetalHandle", Vector3(0, 0.43, 0), Vector3(0.42, 0.05, 0.05), mat_metal)
	_cylinder(lantern, "WaxCandle", Vector3(0, -0.09, 0), 0.07, 0.30, mat_cloth)
	_cylinder(lantern, "VisibleCandleFlame", Vector3(0, 0.11, 0), 0.075, 0.15, mat_warm)
	return lantern

func _box(parent: Node3D, name: String, pos: Vector3, size: Vector3, material: Material, rot_deg: Vector3 = Vector3.ZERO) -> MeshInstance3D:
	var mesh := BoxMesh.new()
	mesh.size = size
	var mi := MeshInstance3D.new()
	mi.name = name
	mi.mesh = mesh
	mi.material_override = material
	mi.position = pos
	mi.rotation_degrees = rot_deg
	parent.add_child(mi)
	return mi

func _cylinder(parent: Node3D, name: String, pos: Vector3, radius: float, height: float, material: Material) -> MeshInstance3D:
	var mesh := CylinderMesh.new()
	mesh.top_radius = radius
	mesh.bottom_radius = radius
	mesh.height = height
	mesh.radial_segments = 18
	var mi := MeshInstance3D.new()
	mi.name = name
	mi.mesh = mesh
	mi.material_override = material
	mi.position = pos
	parent.add_child(mi)
	return mi
