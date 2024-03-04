shader_type canvas_item;

uniform vec2 direction = vec2(-0.05, 0.25);
uniform float speed : hint_range(0.0, 20.0, 0.1) = 0.5;

uniform float alpha : hint_range(0.0, 1.0, 0.01) = 1.0 ;
uniform float inner_radius : hint_range(0.0, 0.9, 0.01) = 0.0;
uniform float outer_radius : hint_range(0.0, 2.0, 0.01) = 1.0;

uniform sampler2D vignette_noise : repeat_enable;

void fragment() {
	vec4 vignette_texture_1 = texture(vignette_noise, UV + (direction * TIME * speed));
	vec4 vignette_texture_2 = texture(vignette_noise, UV + (-direction * TIME * speed));
	
	float x = abs(UV.r - 0.5) * 2.0;
	float y = abs(UV.g - 0.5) * 2.0;
	float q = 1.0 - (1.0 - sqrt(x * x + y * y) / outer_radius) / (1.0 - inner_radius);
	
	COLOR = vec4(vignette_texture_1.rgb - vignette_texture_2.rgb, q * alpha);
}