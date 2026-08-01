extends Node3D
# Bonfire — замінює кубик на справжнє вогнище

func _ready() -> void:
	# Основа — каміння
	for i: int in 6:
		var angle: float = deg_to_rad(i * 60.0)
		var r: float = 0.5
		var stone: MeshInstance3D = MeshInstance3D.new()
		var m: SphereMesh = SphereMesh.new()
		m.radius = 0.15; m.height = 0.25
		var mat: StandardMaterial3D = StandardMaterial3D.new()
		mat.albedo_color = Color(0.2, 0.15, 0.1)
		mat.roughness = 0.9
		stone.mesh = m; stone.material_override = mat
		stone.position = Vector3(cos(angle) * r, 0.05, sin(angle) * r)
		add_child(stone)

	# Дрова
	for i: int in 4:
		var angle: float = deg_to_rad(i * 90.0 + 45)
		var log: MeshInstance3D = MeshInstance3D.new()
		var cm: CylinderMesh = CylinderMesh.new()
		cm.top_radius = 0.05; cm.bottom_radius = 0.05; cm.height = 0.8
		var mat2: StandardMaterial3D = StandardMaterial3D.new()
		mat2.albedo_color = Color(0.35, 0.2, 0.08)
		mat2.roughness = 0.7
		log.mesh = cm; log.material_override = mat2
		log.position = Vector3(cos(angle) * 0.25, 0.15, sin(angle) * 0.25)
		log.rotation = Vector3(0, angle + PI/2, PI/2)
		add_child(log)

	# Вугілля (емісія)
	var ember_mat: StandardMaterial3D = StandardMaterial3D.new()
	ember_mat.albedo_color = Color(1.0, 0.3, 0.02)
	ember_mat.emission_enabled = true
	ember_mat.emission = Color(1.0, 0.25, 0.02)
	ember_mat.emission_energy_multiplier = 2.0

	var embers: MeshInstance3D = MeshInstance3D.new()
	var sm: SphereMesh = SphereMesh.new()
	sm.radius = 0.25; sm.height = 0.35
	embers.mesh = sm; embers.material_override = ember_mat
	embers.position = Vector3(0, 0.15, 0)
	add_child(embers)

	# Світло
	var light: OmniLight3D = OmniLight3D.new()
	light.light_color = Color(1.0, 0.35, 0.08)
	light.light_energy = 3.5
	light.omni_range = 10.0
	light.position = Vector3(0, 0.8, 0)
	add_child(light)

	# Партикли полум'я
	var particles: GPUParticles3D = GPUParticles3D.new()
	particles.amount = 40
	particles.lifetime = 1.2
	particles.one_shot = false
	particles.explosiveness = 0.0
	particles.emitting = true

	var particle_mat: ParticleProcessMaterial = ParticleProcessMaterial.new()
	particle_mat.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_SPHERE
	particle_mat.emission_sphere_radius = 0.2
	particle_mat.direction = Vector3(0, 1, 0)
	particle_mat.spread = 15.0
	particle_mat.initial_velocity_min = 0.3
	particle_mat.initial_velocity_max = 0.8
	particle_mat.gravity = Vector3(0, 0.3, 0)
	particle_mat.scale_min = 0.05
	particle_mat.scale_max = 0.2
	particle_mat.color = Color(1.0, 0.5, 0.05, 1)
	particle_mat.color_ramp = _fire_gradient()
	particles.process_material = particle_mat

	var quad: QuadMesh = QuadMesh.new()
	quad.size = Vector2(0.15, 0.15)

	var particles_draw: MeshInstance3D = MeshInstance3D.new()
	particles_draw.mesh = quad

	var particle_mat_visual: StandardMaterial3D = StandardMaterial3D.new()
	particle_mat_visual.albedo_color = Color(1.0, 0.5, 0.05)
	particle_mat_visual.emission_enabled = true
	particle_mat_visual.emission = Color(1.0, 0.4, 0.02)
	particle_mat_visual.emission_energy_multiplier = 1.5
	particle_mat_visual.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	particle_mat_visual.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	particles_draw.material_override = particle_mat_visual

	particles.add_child(particles_draw)
	particles.position = Vector3(0, 0.25, 0)
	add_child(particles)

func _fire_gradient() -> GradientTexture1D:
	var grad: Gradient = Gradient.new()
	grad.set_color(0, Color(1, 0.9, 0.1, 1))
	grad.set_color(1, Color(1, 0.1, 0, 0))
	var tex: GradientTexture1D = GradientTexture1D.new()
	tex.gradient = grad
	return tex
