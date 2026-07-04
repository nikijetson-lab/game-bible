extends Node3D

# Runtime visual assembly for Greyford Gate — arch, portcullis, walls,
# sergeant post, cobblestone road, and outer guards.
# Does NOT create or modify any lights/environment.
# All dressing goes under a single "GateArtDressing" node so existing nodes are untouched.

var mat_stone: StandardMaterial3D
var mat_stone_dark: StandardMaterial3D
var mat_oak: StandardMaterial3D
var mat_iron: StandardMaterial3D
var mat_rust: StandardMaterial3D
var mat_cobble: StandardMaterial3D
var mat_lamp: StandardMaterial3D
var mat_paper: StandardMaterial3D
var mat_wood_desk: StandardMaterial3D


func _ready() -> void:
	var dressing := Node3D.new()
	dressing.name = "GateArtDressing"
	add_child(dressing)

	_create_materials()
	_build_gate_arch(dressing)
	_build_portcullis(dressing)
	_build_walls(dressing)
	_build_sergeant_post(dressing)
	_build_cobblestone_road(dressing)
	_build_outer_guards(dressing)


func _create_materials() -> void:
	mat_stone = _mat(Color(0.32, 0.30, 0.27), "", 0.95)
	mat_stone_dark = _mat(Color(0.24, 0.22, 0.20), "", 0.95)
	mat_oak = _mat(Color(0.14, 0.09, 0.05), "", 0.9)

	mat_iron = _mat(Color(0.20, 0.20, 0.21), "", 0.65)
	mat_iron.metallic = 0.5

	mat_rust = _mat(Color(0.30, 0.20, 0.14), "", 0.65)
	mat_rust.metallic = 0.3

	# Wet cobblestone — slightly reflective
	mat_cobble = _mat(Color(0.20, 0.20, 0.21), "", 0.5)

	# Warm lantern glass with self-emission
	mat_lamp = _mat(Color(0.95, 0.62, 0.28, 0.8), "", 0.5)
	mat_lamp.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat_lamp.emission_enabled = true
	mat_lamp.emission = Color(0.95, 0.5, 0.15)
	mat_lamp.emission_energy_multiplier = 1.3

	mat_paper = _mat(Color(0.60, 0.56, 0.46), "", 0.8)
	mat_wood_desk = _mat(Color(0.20, 0.13, 0.08), "", 0.85)


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


func _box(
	parent: Node3D, name: String, pos: Vector3, size: Vector3,
	material: Material, rot_deg: Vector3 = Vector3.ZERO
) -> MeshInstance3D:
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


# ---------------------------------------------------------------------------
# 3. Massive stone gate arch around the existing wooden gate (center z = -6)
# ---------------------------------------------------------------------------
func _build_gate_arch(parent: Node3D) -> void:
	var arch := Node3D.new()
	arch.name = "GateArch"
	parent.add_child(arch)

	# Two stone pylons flanking the gate
	_box(arch, "LeftPylon", Vector3(-3.4, 2.6, -6), Vector3(1.4, 5.2, 1.4), mat_stone)
	_box(arch, "RightPylon", Vector3(3.4, 2.6, -6), Vector3(1.4, 5.2, 1.4), mat_stone)

	# Arch lintel / bridge
	_box(arch, "ArchLintel", Vector3(0, 5.4, -6), Vector3(8.2, 1.2, 1.4), mat_stone)

	# Merlons (crenellations / зубчастий верх) on top of the arch
	var merlon_xs := [-3.0, -1.5, 0.0, 1.5, 3.0]
	for i in 5:
		_box(
			arch, "Merlon_%d" % i,
			Vector3(merlon_xs[i], 6.3, -6),
			Vector3(0.8, 0.6, 1.2),
			mat_stone
		)


# ---------------------------------------------------------------------------
# 4. Raised iron portcullis with spikes at the bottom
# ---------------------------------------------------------------------------
func _build_portcullis(parent: Node3D) -> void:
	var pc := Node3D.new()
	pc.name = "Portcullis"
	parent.add_child(pc)

	# 7 vertical bars at y = 4.2 (lower third visible inside the arch opening)
	var bar_xs := [-2.25, -1.5, -0.75, 0.0, 0.75, 1.5, 2.25]
	for i in 7:
		_box(
			pc, "VerticalBar_%d" % i,
			Vector3(bar_xs[i], 4.2, -5.8),
			Vector3(0.08, 1.6, 0.08),
			mat_iron
		)
		# Spike at the bottom end of each bar
		_box(
			pc, "Spike_%d" % i,
			Vector3(bar_xs[i], 3.4 - 0.11, -5.8),
			Vector3(0.06, 0.22, 0.06),
			mat_rust
		)

	# 2 horizontal bars spanning the full width
	_box(pc, "HorizontalBarTop", Vector3(0, 4.8, -5.8), Vector3(5.6, 0.08, 0.08), mat_iron)
	_box(pc, "HorizontalBarBottom", Vector3(0, 3.6, -5.8), Vector3(5.6, 0.08, 0.08), mat_iron)


# ---------------------------------------------------------------------------
# 5. Fortress walls with grated windows
# ---------------------------------------------------------------------------
func _build_walls(parent: Node3D) -> void:
	var walls := Node3D.new()
	walls.name = "GateWalls"
	parent.add_child(walls)

	# Left wall segment
	_box(walls, "LeftWall", Vector3(-7.5, 2.3, -6), Vector3(5.5, 4.6, 1.1), mat_stone)
	# Window niche recessed into the wall
	_box(walls, "LeftWindowNiche", Vector3(-7.5, 2.6, -5.35), Vector3(0.7, 1.1, 0.15), mat_stone_dark)
	# 3 vertical iron bars in the window
	for i in 3:
		_box(
			walls, "LeftWindowBar_%d" % i,
			Vector3(-7.5 - 0.23 + 0.23 * i, 2.6, -5.25),
			Vector3(0.05, 1.05, 0.05),
			mat_iron
		)

	# Right wall segment
	_box(walls, "RightWall", Vector3(7.5, 2.3, -6), Vector3(5.5, 4.6, 1.1), mat_stone)
	# Window niche
	_box(walls, "RightWindowNiche", Vector3(7.5, 2.6, -5.35), Vector3(0.7, 1.1, 0.15), mat_stone_dark)
	# 3 vertical iron bars
	for i in 3:
		_box(
			walls, "RightWindowBar_%d" % i,
			Vector3(7.5 - 0.23 + 0.23 * i, 2.6, -5.25),
			Vector3(0.05, 1.05, 0.05),
			mat_iron
		)


# ---------------------------------------------------------------------------
# 6. Sergeant registration post — desk, journal, wall lantern
# ---------------------------------------------------------------------------
func _build_sergeant_post(parent: Node3D) -> void:
	var post := Node3D.new()
	post.name = "SergeantPost"
	parent.add_child(post)

	# Desk stand / vertical leg
	_box(post, "DeskStand", Vector3(1.5, 0.525, -4), Vector3(0.12, 1.05, 0.12), mat_oak)

	# Slanted desk top at y = 1.15, tilted forward
	_box(
		post, "DeskTop",
		Vector3(1.5, 1.15, -4),
		Vector3(0.55, 0.05, 0.4),
		mat_wood_desk,
		Vector3(-18, 0, 0)
	)

	# Open journal on the desk (same tilt)
	_box(
		post, "Journal",
		Vector3(1.5, 1.24, -4),
		Vector3(0.42, 0.02, 0.3),
		mat_paper,
		Vector3(-18, 0, 0)
	)

	# Wall lantern on the inner face of the right pylon
	_box(post, "LanternBracket", Vector3(2.85, 2.6, -4.0), Vector3(0.05, 0.05, 0.3), mat_iron)
	_box(post, "LanternBody", Vector3(2.85, 2.6, -4.15), Vector3(0.18, 0.24, 0.18), mat_lamp)


# ---------------------------------------------------------------------------
# 7. Wet cobblestone road through the gate with scattered edge stones
# ---------------------------------------------------------------------------
func _build_cobblestone_road(parent: Node3D) -> void:
	var road := Node3D.new()
	road.name = "CobblestoneRoad"
	parent.add_child(road)

	# Main wet cobblestone strip
	_box(road, "CobbleStrip", Vector3(0, 0.03, -2), Vector3(4.6, 0.06, 14), mat_cobble)

	# 8 deterministic edge stones (both sides)
	var edge_stones := [
		Vector3(-2.4, 0.04, -7.0),
		Vector3(2.4, 0.04, -6.5),
		Vector3(-2.4, 0.04, -4.0),
		Vector3(2.4, 0.04, -3.5),
		Vector3(-2.4, 0.04, -1.0),
		Vector3(2.4, 0.04, -0.5),
		Vector3(-2.4, 0.04, 2.0),
		Vector3(2.4, 0.04, 2.5),
	]
	for i in edge_stones.size():
		_box(
			road, "EdgeStone_%d" % i,
			edge_stones[i],
			Vector3(0.25, 0.08, 0.3),
			mat_stone_dark
		)


# ---------------------------------------------------------------------------
# 8. Two stylised guard silhouettes beyond the gate
# ---------------------------------------------------------------------------
func _build_outer_guards(parent: Node3D) -> void:
	var guards := Node3D.new()
	guards.name = "OuterGuards"
	parent.add_child(guards)

	# --- Left guard ---
	_box(
		guards, "LeftGuardTorso",
		Vector3(-1.5, 0.425, -7.5),
		Vector3(0.42, 0.85, 0.28),
		mat_stone_dark
	)
	# Head as a sphere
	var head_l := MeshInstance3D.new()
	head_l.name = "LeftGuardHead"
	var sphere_l := SphereMesh.new()
	sphere_l.radius = 0.2
	sphere_l.height = 0.4
	sphere_l.radial_segments = 16
	head_l.mesh = sphere_l
	head_l.material_override = mat_stone_dark
	head_l.position = Vector3(-1.5, 0.95, -7.5)
	guards.add_child(head_l)
	# Spear
	_box(
		guards, "LeftGuardSpear",
		Vector3(-1.72, 0.95, -7.5),
		Vector3(0.04, 1.9, 0.04),
		mat_iron
	)

	# --- Right guard ---
	_box(
		guards, "RightGuardTorso",
		Vector3(1.5, 0.425, -7.5),
		Vector3(0.42, 0.85, 0.28),
		mat_stone_dark
	)
	var head_r := MeshInstance3D.new()
	head_r.name = "RightGuardHead"
	var sphere_r := SphereMesh.new()
	sphere_r.radius = 0.2
	sphere_r.height = 0.4
	sphere_r.radial_segments = 16
	head_r.mesh = sphere_r
	head_r.material_override = mat_stone_dark
	head_r.position = Vector3(1.5, 0.95, -7.5)
	guards.add_child(head_r)
	_box(
		guards, "RightGuardSpear",
		Vector3(1.72, 0.95, -7.5),
		Vector3(0.04, 1.9, 0.04),
		mat_iron
	)
