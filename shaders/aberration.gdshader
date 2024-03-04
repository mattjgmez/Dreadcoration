shader_type spatial;

render_mode depth_draw_always, depth_prepass_alpha;

const vec2 SCROLL_DIRECTION = vec2(-0.05, 0.25);
uniform float speed : hint_range(0.0, 20.0, 0.1) = 20;

uniform vec3 base_color : source_color;
uniform float fade_threshold : hint_range(-1.0, 2.0);
uniform float static_radius : hint_range(0.0, 1.0, 0.1);
uniform sampler2D static_texture : repeat_enable;

void fragment( ){
	vec4 texture_data = texture(static_texture, UV);
	vec4 final_color = texture_data;
	
	// Get the Red value of the fragment location
	float sample = texture_data.r;
	
	if (sample < fade_threshold - static_radius){
		final_color.rgb = base_color;
		final_color.a = 1.0;
	} else if (sample > fade_threshold + static_radius){
		final_color.a = 0.0;
	} else {
		vec4 static_texture_1 = texture(static_texture, UV + (SCROLL_DIRECTION * TIME * speed));
		vec4 static_texture_2 = texture(static_texture, UV + (-SCROLL_DIRECTION * TIME * speed));
		
		final_color.rgb = (static_texture_1 - static_texture_2).rgb;
		final_color.a = 1.0;
	}
	
	ALBEDO = final_color.rgb;
	ALPHA = final_color.a;
	EMISSION = vec3(0.0);
}