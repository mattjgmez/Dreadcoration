shader_type canvas_item;

// Handles the resolution changes, color depth, and dithering
group_uniforms resolution_and_colors;
uniform bool change_color_depth = false;
uniform int target_color_depth : hint_range(1, 8) = 5;
uniform bool dithering = false;
uniform bool scale_resolution = false;
uniform int target_resolution_scale = 3;

// Handles the LUTish recoloring
group_uniforms gradient_recoloring;
uniform bool enable_recolor = false;
uniform sampler2D to_gradient: hint_default_black;

group_uniforms scanlines;
uniform bool enable_scanlines = false;
uniform float scanline_count : hint_range(0, 240, 10) = 50.0;
uniform float scanline_brightness : hint_range(0, 10, 0.01) = 5;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

int dithering_pattern(ivec2 fragcoord) {
	const int pattern[] = {
		-4, +0, -3, +1, 
		+2, -2, +3, -1, 
		-3, +1, -4, +0, 
		+3, -1, +2, -2
	};
	
	int x = fragcoord.x % 4;
	int y = fragcoord.y % 4;
	
	return pattern[y * 4 + x];
}

vec3 rgb2hsv(vec3 rgb) { //Converts RGB values to HSV
	float r = rgb.r;
	float g = rgb.g;
	float b = rgb.b;
	
	float cmax = max(r,max(g,b));
	float cmin = min(r,min(g,b));
	float delta = cmax - cmin;
	
	float h = 0.f; //hue
	
	if (delta > 0.f){
		if (cmax == r){
			h = (g-b)/delta;
			h = mod(h,6.f);
		} else if (cmax == g){
			h = ((b - r) / delta) + 2.f;
		} else {
			h = ((r-g)/delta) + 4.f;
		}
		h = h * 60.f;
	}
	
	float s = 0.f; //saturation
	if (cmax > 0.f){
		s = delta / cmax;
	}
	
	return vec3(h,s,cmax); // Keep original alpha value 
	
}

vec3 hsv2rgb(vec3 hsv) { //Converts HSV values to RGB
	float h = hsv.r;
	float s = hsv.g;
	float v = hsv.b;
	float c = v * s;
	//X = C × (1 - |(H / 60°) mod 2 - 1|)
	float x = h / 60.f;
	x = mod(x,2.f);
	x = abs(x - 1.f);
	x = c * (1.f - x);
	
	float m = v - c;
	
	vec3 rgb = vec3(0.f,0.f,0.f);
	
	if (h < 60.f) {
		rgb = vec3(c,x,0.f);
	} else if (h < 120.f){
		rgb = vec3(x,c,0.f);
	} else if (h < 180.f){
		rgb = vec3(0.f,c,x);
	} else if (h < 240.f){
		rgb = vec3(0.f,x,c);
	} else if (h < 300.f){
		rgb = vec3(x,0.f,c);
	} else if (h < 360.f){
		rgb = vec3(c,0.f,x);
	}
	rgb[0] = rgb[0] + m;
	rgb[1] = rgb[1] + m;
	rgb[2] = rgb[2] + m;
	
	return rgb; 
}

vec2 uv_curve(vec2 uv)
{
	uv = (uv - 0.5) * 2.0;
	
	//You can modify the numbers and try different values
	uv.x *= 1.0 + pow(abs(uv.y) / 3.0, 2.0);
	uv.y *= 1.0 + pow(abs(uv.x) / 3.0, 2.0);
	
	//The scale part (you can delete it when you want)
	uv /= 1.2;
	
	uv = (uv/2.0) + 0.5;
	return uv;
}

void fragment() {
	ivec2 uv;
	vec3 color;
	
	if(scale_resolution){
		uv = ivec2(FRAGCOORD.xy / float(target_resolution_scale));
		color = texelFetch(TEXTURE, uv * target_resolution_scale, 0).rgb;
	} else {
		uv = ivec2(FRAGCOORD.xy);
		color = texelFetch(TEXTURE, uv, 0).rgb;
	}
	
	if(enable_recolor){
		vec3 hsv = rgb2hsv(color);
		float color_pos = (hsv.x / 360.0);
		vec3 new_color = texture(to_gradient, vec2((color_pos), 0.5)).rgb;
		vec3 new_hsv = rgb2hsv(new_color);
		hsv.x = new_hsv.x;
		vec3 final_rgb = hsv2rgb(hsv);
		
		color.rgb = final_rgb;
	}
	
	
	// Convert from [0.0, 1.0] range to [0, 255] range
	ivec3 c = ivec3(round(color * 255.0));
	
	// Apply the dithering pattern
	if (dithering) {
		c += ivec3(dithering_pattern(uv));
	}
	
	vec3 final_color;
	if(change_color_depth){
		// Truncate from 8 bits to color_depth bits
		c >>= (8 - target_color_depth);
		final_color = vec3(c) / float(1 << target_color_depth);
	} else {
		final_color = vec3(c) / float(1 << 8);
	}
	
	if (enable_scanlines){
		//You can modify the *3.0, *-3.0 for a bigger or smaller 
		float r = texture(SCREEN_TEXTURE, uv_curve(SCREEN_UV) + vec2(SCREEN_PIXEL_SIZE.x * 0.0), 0.0).r;
		float g = texture(SCREEN_TEXTURE, uv_curve(SCREEN_UV) + vec2(SCREEN_PIXEL_SIZE.x * 3.0), 0.0).g;
		float b = texture(SCREEN_TEXTURE, uv_curve(SCREEN_UV) + vec2(SCREEN_PIXEL_SIZE.x * -3.0), 0.0).b;
		
		float s = sin(uv_curve(SCREEN_UV).y * scanline_count * PI * 2.0);
		s = (s * 0.5 + 0.5) * 0.9 + 0.1;
		vec4 scan_line = vec4(vec3(pow(s * scanline_brightness, 0.25)), 1.0);
		final_color +=  (vec4(r, g, b, 1.0) * scan_line).xyz;
	}
	
	// Convert back to [0.0, 1.0] range
	COLOR.rgb = final_color;
}