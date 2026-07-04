extends Node3D

# Art assembly for Craftsmen Quarter — workshop facades, workstation dressing, courtyard props.
# Builds visual-only MeshInstance3D nodes. Does NOT create/modify lights or environment.
# Does NOT touch existing nodes (NPCs, workbench, Label3D placeholders).
# Canon: bogwood (willow-root from deep Hazemuir), old bog-protection signs above carver's door.
# Palette: earthy timber, grey plaster, cold high-window light, warm forge glow, grey-brown furs.

var mat_timber: StandardMaterial3D
var mat_plaster: StandardMaterial3D
var mat_stone: StandardMaterial3D
var mat_window: StandardMaterial3D
var mat_fur_grey: StandardMaterial3D
var mat_fur_dark: StandardMaterial3D
var mat_leather: StandardMaterial3D
var mat_tool_metal: StandardMaterial3D
var mat_bogwood: StandardMaterial3D
var mat_shavings: StandardMaterial3D
var mat_forge: StandardMaterial3D
var mat_sign: StandardMaterial3D

func _ready() -> void:
	_create_materials()
	var root := Node3D.new()
	root.name = "CraftsmenArtDressing"
	add_child(root)
	_build_workshop_facades(root)
	_build_high_windows(root)
	_build_woodcarver_station(root)
	_build_furrier_station(root)
	_build_courtyard_props(root)

# ---------------------------------------------------------------------------
# Material helpers
# ---------------------------------------------------------------------------

func _create_materials() -> void:
	mat_timber = _mat(Color(0.20, 0.14, 0.08), "", 0.92)
	mat_plaster = _mat(Color(0.34, 0.33, 0.30), "", 0.95)
	mat_stone = _mat(Color(0.28, 0.27, 0.25), "", 0.75)
	mat_window = _mat(Color(0.45, 0.58, 0.66, 0.85), "", 0.6)
	mat_window.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat_window.emission_enabled = true
	mat_window.emission = Color(0.5, 0.65, 0.75)
	mat_window.emission_energy_multiplier = 0.7
	mat_fur_grey = _mat(Color(0.38, 0.35, 0.30), "", 1.0)
	mat_fur_dark = _mat(Color(0.24, 0.20, 0.16), "", 1.0)
	mat_leather = _mat(Color(0.30, 0.20, 0.12), "", 0.7)
	mat_tool_metal = _mat(Color(0.32, 0.33, 0.35), "", 0.5)
	mat_tool_metal.metallic = 0.6
	mat_bogwood = _mat(Color(0.10, 0.08, 0.06), "", 0.85)
	mat_shavings = _mat(Color(0.45, 0.35, 0.22), "", 0.7)
	mat_forge = _mat(Color(0.9, 0.45, 0.12), "", 0.5)
	mat_forge.emission_enabled = true
	mat_forge.emission = Color(0.95, 0.4, 0.1)
	mat_forge.emission_energy_multiplier = 1.6
	mat_sign = _mat(Color(0.16, 0.20, 0.15), "", 0.6)
	mat_sign.emission_enabled = true
	mat_sign.emission = Color(0.25, 0.45, 0.3)
	mat_sign.emission_energy_multiplier = 0.35

func _mat(color: Color, _texture_path: String, roughness: float) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = roughness
	return m

# ---------------------------------------------------------------------------
# Workshop facades — two timber-frame buildings along the back wall (z = -6)
# ---------------------------------------------------------------------------

func _build_workshop_facades(parent: Node3D) -> void:
	var facades := Node3D.new()
	facades.name = "ArtWorkshopFacades"
	parent.add_child(facades)

	_var_woodcarver_facade(facades)
	_var_furrier_facade(facades)

func _var_woodcarver_facade(parent: Node3D) -> void:
	var f := Node3D.new()
	f.name = "WoodcarverFacade"
	parent.add_child(f)

	var cx := -4.0  # centre x
	var fz := -6.0  # facade z
	var post_z := fz  # posts flush with plaster

	# Plaster infill 4.6 x 3.2 x 0.22
	_box(f, "PlasterFill", Vector3(cx, 1.6, fz), Vector3(4.6, 3.2, 0.22), mat_plaster)

	# Corner posts 0.18 x 3.2
	_box(f, "LeftPost", Vector3(cx - 2.3, 1.6, post_z), Vector3(0.18, 3.2, 0.26), mat_timber)
	_box(f, "RightPost", Vector3(cx + 2.3, 1.6, post_z), Vector3(0.18, 3.2, 0.26), mat_timber)

	# Diagonal cross brace
	_box(f, "DiagonalBrace", Vector3(cx, 1.6, fz + 0.12), Vector3(4.8, 0.12, 0.08), mat_timber, Vector3(0, 0, 28))

	# Door at x = -2.8
	var door_x := -2.8
	_box(f, "Door", Vector3(door_x, 1.0, fz + 0.12), Vector3(1.0, 2.0, 0.12), mat_timber)

	# Three old bog-protection signs above the door (canon: old bog signs of protection)
	var sign_y := 2.32
	var sign_z := fz + 0.14
	var angles := [10.0, -6.0, 14.0]
	for i in 3:
		var sx := door_x + float(i - 1) * 0.18
		_box(f, "BogSign_%d" % i, Vector3(sx, sign_y, sign_z), Vector3(0.12, 0.18, 0.03), mat_sign, Vector3(0, angles[i], 0))

func _var_furrier_facade(parent: Node3D) -> void:
	var f := Node3D.new()
	f.name = "FurrierFacade"
	parent.add_child(f)

	var cx := 3.6
	var fz := -6.0
	var post_z := fz

	# Plaster infill
	_box(f, "PlasterFill", Vector3(cx, 1.6, fz), Vector3(4.6, 3.2, 0.22), mat_plaster)

	# Corner posts
	_box(f, "LeftPost", Vector3(cx - 2.3, 1.6, post_z), Vector3(0.18, 3.2, 0.26), mat_timber)
	_box(f, "RightPost", Vector3(cx + 2.3, 1.6, post_z), Vector3(0.18, 3.2, 0.26), mat_timber)

	# Diagonal cross brace
	_box(f, "DiagonalBrace", Vector3(cx, 1.6, fz + 0.12), Vector3(4.8, 0.12, 0.08), mat_timber, Vector3(0, 0, -28))

	# Door at x = 4.4 (right side)
	_box(f, "Door", Vector3(4.4, 1.0, fz + 0.12), Vector3(1.0, 2.0, 0.12), mat_timber)

	# Wide shop window at y = 1.6
	_box(f, "DisplayWindow", Vector3(cx, 1.6, fz + 0.12), Vector3(1.6, 1.0, 0.06), mat_window)

# ---------------------------------------------------------------------------
# High narrow windows — cold light from above (canon: like in woodcarver art)
# ---------------------------------------------------------------------------

func _build_high_windows(parent: Node3D) -> void:
	var hw := Node3D.new()
	hw.name = "ArtHighWindows"
	parent.add_child(hw)

	var fz := -6.0
	var wz := fz + 0.12

	# 2 windows on woodcarver facade
	_box_window(hw, "CarverWin_L", Vector3(-4.8, 2.6, wz))
	_box_window(hw, "CarverWin_R", Vector3(-3.2, 2.6, wz))

	# 2 windows on furrier facade
	_box_window(hw, "FurrierWin_L", Vector3(2.8, 2.6, wz))
	_box_window(hw, "FurrierWin_R", Vector3(4.4, 2.6, wz))

func _box_window(parent: Node3D, name: String, pos: Vector3) -> void:
	var w := Node3D.new()
	w.name = name
	w.position = pos
	parent.add_child(w)

	var ws := Vector3(0.5, 0.8, 0.06)  # window glass size
	var fw := 0.05  # frame width
	var fd := 0.04  # frame depth

	_box(w, "Glass", Vector3.ZERO, ws, mat_window)
	# Frames
	_box(w, "TopFrame", Vector3(0, ws.y * 0.5 + fw * 0.5, 0), Vector3(ws.x + fw * 2.0, fw, fd), mat_timber)
	_box(w, "BottomFrame", Vector3(0, -ws.y * 0.5 - fw * 0.5, 0), Vector3(ws.x + fw * 2.0, fw, fd), mat_timber)
	_box(w, "LeftFrame", Vector3(-ws.x * 0.5 - fw * 0.5, 0, 0), Vector3(fw, ws.y + fw * 2.0, fd), mat_timber)
	_box(w, "RightFrame", Vector3(ws.x * 0.5 + fw * 0.5, 0, 0), Vector3(fw, ws.y + fw * 2.0, fd), mat_timber)

# ---------------------------------------------------------------------------
# Woodcarver station — shelf, bogwood blanks, willow-root, tools, shavings
# Canon: bogwood (willow-root from deep Hazemuir) — key to Pathfinder branch
# ---------------------------------------------------------------------------

func _build_woodcarver_station(parent: Node3D) -> void:
	var s := Node3D.new()
	s.name = "ArtWoodcarverStation"
	parent.add_child(s)

	# Shelf unit near workbench (workbench centre ~ -1.6, 0.65, -1.95)
	var sp := Vector3(-2.4, 0.9, -2.8)

	# Frame 1.4 x 1.8 x 0.35
	_box(s, "ShelfFrame", sp, Vector3(1.4, 1.8, 0.35), mat_timber)

	# 3 shelves inside the frame
	var shelf_y := [-0.55, 0.0, 0.55]
	for i in 3:
		_box(s, "Shelf_%d" % i, sp + Vector3(0.0, shelf_y[i], 0.08), Vector3(1.3, 0.05, 0.30), mat_timber)

	# 5 bogwood blanks scattered across shelves
	var bz := -2.68
	_box(s, "BogBlank1", Vector3(-2.3, 0.43, bz), Vector3(0.5, 0.12, 0.12), mat_bogwood, Vector3(0, 5, 2))
	_box(s, "BogBlank2", Vector3(-2.6, 0.40, bz), Vector3(0.35, 0.10, 0.10), mat_bogwood, Vector3(0, -8, -1))
	_box(s, "BogBlank3", Vector3(-2.2, 0.98, bz), Vector3(0.45, 0.12, 0.12), mat_bogwood, Vector3(0, 12, 3))
	_box(s, "BogBlank4", Vector3(-2.65, 0.95, bz), Vector3(0.30, 0.08, 0.10), mat_bogwood, Vector3(0, -4, 0))
	_box(s, "BogBlank5", Vector3(-2.35, 1.53, bz), Vector3(0.40, 0.10, 0.12), mat_bogwood, Vector3(0, 7, -2))

	# LONG willow-root leaning on the shelf (canon: willow-root from deep Hazemuir)
	_box(s, "WillowRoot", Vector3(-1.55, 0.55, -2.95), Vector3(0.22, 0.22, 1.7), mat_bogwood, Vector3(0, 25, 35))

	# 3 chisels on the workbench (tool_metal)
	for i in 3:
		var tx := -1.4 + float(i - 1) * 0.12
		_box(s, "Chisel_%d" % i, Vector3(tx, 0.82, -1.82), Vector3(0.04, 0.03, 0.28), mat_tool_metal, Vector3(0, 5.0 + float(i) * 8.0, 0))

	# 3 flat shavings at angles
	for i in 3:
		var sx := -1.7 + float(i) * 0.12
		var srot := float(i) * 18.0 - 18.0
		_box(s, "Shaving_%d" % i, Vector3(sx, 0.78, -1.68), Vector3(0.3, 0.03, 0.25), mat_shavings, Vector3(0, 0, srot))

# ---------------------------------------------------------------------------
# Furrier station — drying frame with hanging furs, counter with rolled pelts
# ---------------------------------------------------------------------------

func _build_furrier_station(parent: Node3D) -> void:
	var s := Node3D.new()
	s.name = "ArtFurrierStation"
	parent.add_child(s)

	var fx := 3.0
	var fz := -2.8

	# Drying frame — 2 posts + crossbar
	_box(s, "FramePostL", Vector3(fx - 1.2, 1.1, fz), Vector3(0.1, 2.2, 0.1), mat_timber)
	_box(s, "FramePostR", Vector3(fx + 1.2, 1.1, fz), Vector3(0.1, 2.2, 0.1), mat_timber)
	_box(s, "FrameCrossbar", Vector3(fx, 2.2, fz), Vector3(2.4, 0.08, 0.08), mat_timber)

	# 4 hanging furs with slight tilt and ragged bottom edge
	var furs := [
		[-0.9, 3.0, mat_fur_grey],
		[-0.3, -5.0, mat_fur_dark],
		[0.3, 8.0, mat_fur_grey],
		[0.9, -3.0, mat_fur_dark]
	]
	for data in furs:
		var ox := data[0] as float
		var rot := data[1] as float
		var fm := data[2] as StandardMaterial3D
		var fp := Vector3(fx + ox, 1.65, fz)

		# Main fur body
		_box(s, "FurMain_%.1f" % ox, fp, Vector3(0.55, 1.1, 0.06), fm, Vector3(0, 0, rot))
		# Ragged lower edge — a shorter box offset downward
		_box(s, "FurRag_%.1f" % ox, fp + Vector3(0.06, -0.48, 0.01), Vector3(0.40, 0.22, 0.05), fm, Vector3(0, 0, rot + 5.0))

	# Counter in front of the drying frame
	_box(s, "Counter", Vector3(fx, 0.475, fz + 1.0), Vector3(1.8, 0.95, 0.6), mat_timber)

	# 3 rolled furs on the counter
	var rolls := [
		[-0.4, mat_fur_grey],
		[0.1, mat_fur_dark],
		[0.55, mat_fur_grey]
	]
	for data in rolls:
		var ox := data[0] as float
		var rm := data[1] as StandardMaterial3D
		_box(s, "RolledFur_%.1f" % ox, Vector3(fx + ox, 0.96, fz + 1.0), Vector3(0.5, 0.18, 0.18), rm)

# ---------------------------------------------------------------------------
# Courtyard props — forge, barrels, plank stack, cart
# ---------------------------------------------------------------------------

func _build_courtyard_props(parent: Node3D) -> void:
	var p := Node3D.new()
	p.name = "ArtCourtyardProps"
	parent.add_child(p)

	# --- Small forge between workshops ---
	# Stone base
	_box(p, "ForgeBase", Vector3(0, 0.35, -5.0), Vector3(0.8, 0.7, 0.8), mat_stone)
	# Fire opening (front face)
	_box(p, "ForgeFire", Vector3(0, 0.55, -4.58), Vector3(0.35, 0.3, 0.05), mat_forge)
	# Chimney
	_box(p, "ForgeChimney", Vector3(0, 1.15, -5.0), Vector3(0.3, 1.6, 0.3), mat_stone)

	# --- 2 barrels (cylindrical approx with box) ---
	_box(p, "Barrel1", Vector3(-1.2, 0.35, -4.5), Vector3(0.5, 0.7, 0.5), mat_timber)
	_box(p, "Barrel2", Vector3(1.2, 0.35, -4.8), Vector3(0.5, 0.7, 0.5), mat_timber)

	# --- Stack of planks ---
	for i in 4:
		var off := Vector3(float(i) * 0.03, float(i) * 0.055, float(i) * 0.02)
		_box(p, "Plank_%d" % i, Vector3(-2.4, 0.03, -4.0) + off, Vector3(1.6, 0.06, 0.25), mat_timber)

	# --- Hand cart ---
	var cx := 2.0
	var cz := -4.2
	# Platform
	_box(p, "CartPlatform", Vector3(cx, 0.075, cz), Vector3(1.2, 0.15, 0.8), mat_timber)
	# Wheels (wide flat disc on each side)
	_box(p, "CartWheelL", Vector3(cx - 0.65, 0.45, cz), Vector3(0.5, 0.5, 0.08), mat_timber)
	_box(p, "CartWheelR", Vector3(cx + 0.65, 0.45, cz), Vector3(0.5, 0.5, 0.08), mat_timber)

# ---------------------------------------------------------------------------
# Mesh helpers
# ---------------------------------------------------------------------------

func _box(parent: Node3D, name: String, pos: Vector3, size: Vector3, material: Material,
	rot_deg: Vector3 = Vector3.ZERO) -> MeshInstance3D:
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
