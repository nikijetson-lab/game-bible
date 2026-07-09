extends Node3D
# BuildHuman — будує людиноподібну фігуру з циліндрів + сфери (пропорційно)

func _ready() -> void:
	build(0.82, 0.65, 0.48,  # skin
	      0.15, 0.08, 0.04,  # hair
	      0.25, 0.30, 0.45,  # top
	      0.72, 0.68, 0.60,  # apron
	      0.28, 0.18, 0.08)  # tray

func build(skin_r, skin_g, skin_b, hair_r, hair_g, hair_b, top_r, top_g, top_b, apr_r, apr_g, apr_b, tray_r, tray_g, tray_b):
	# === ГОЛОВА ===
	_add_sph(0, 1.62, 0.17, skin_r, skin_g, skin_b)
	# Волосся
	_add_box(0, 1.62, -0.06, 0.24, 0.30, 0.22, hair_r, hair_g, hair_b)
	
	# === ШИЯ ===
	_add_cyl(0, 1.40, 0.06, 0.12, skin_r, skin_g, skin_b)
	
	# === ТОРС ===
	_add_cyl(0, 1.10, 0.18, 0.65, top_r, top_g, top_b)
	
	# === РУКИ ===
	_add_cyl(0.22, 1.40, 0.05, 0.55, skin_r, skin_g, skin_b)
	_add_cyl(-0.22, 1.40, 0.05, 0.55, skin_r, skin_g, skin_b)
	
	# === НОГИ ===
	_add_cyl(0.08, 0.45, 0.06, 0.65, 0.15, 0.12, 0.10)
	_add_cyl(-0.08, 0.45, 0.06, 0.65, 0.15, 0.12, 0.10)
	
	# === ФАРТУХ ===
	_add_box(0, 0.85, 0.14, 0.24, 0.50, 0.06, apr_r, apr_g, apr_b)
	
	# === ТАЦЯ ===
	_add_box(0.28, 0.95, 0.22, 0.30, 0.04, 0.20, tray_r, tray_g, tray_b)

func _add_sph(x, y, r, cr, cg, cb):
	var mi := MeshInstance3D.new()
	var m := SphereMesh.new(); m.radius = r; m.height = r*2
	var mat := StandardMaterial3D.new(); mat.albedo_color = Color(cr,cg,cb); mat.roughness = 0.7
	m.material = mat; mi.mesh = m; mi.position = Vector3(x,y,0); add_child(mi)

func _add_cyl(x, y, r, h, cr, cg, cb):
	var mi := MeshInstance3D.new()
	var m := CylinderMesh.new(); m.top_radius = r; m.bottom_radius = r; m.height = h
	var mat := StandardMaterial3D.new(); mat.albedo_color = Color(cr,cg,cb); mat.roughness = 0.8
	m.material = mat; mi.mesh = m; mi.position = Vector3(x,y,0); add_child(mi)

func _add_box(x, y, z, sx, sy, sz, cr, cg, cb):
	var mi := MeshInstance3D.new()
	var m := BoxMesh.new(); m.size = Vector3(sx, sy, sz)
	var mat := StandardMaterial3D.new(); mat.albedo_color = Color(cr,cg,cb); mat.roughness = 0.85
	m.material = mat; mi.mesh = m; mi.position = Vector3(x,y,z); add_child(mi)
