shader_type fog;

uniform float fog_density : hint_range(0.0, 1.0) = 0.25;
uniform float height_falloff : hint_range(0.05, 3.0) = 0.18;
uniform vec3 fog_albedo : source_color = vec3(0.28, 0.31, 0.27);

void fog() {
	float h = WORLD_POSITION.y;
	float density = fog_density * exp(-height_falloff * h);
	DENSITY = clamp(density, 0.0, 1.0);
	ALBEDO = fog_albedo;
}
