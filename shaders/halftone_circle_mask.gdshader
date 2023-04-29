shader_type canvas_item;

uniform float circle_size : hint_range(0.0, 1.0) = 0.4;
uniform float size_ratio : hint_range(0.0, 3.0) = 1.0;
uniform float location_x : hint_range(-1.0, 2.0) = 0.5;
uniform float location_y : hint_range(-1.0, 2.0) = 0.5;
uniform bool invert_mask = false;

uniform float highlight_size : hint_range(0.0, 0.05) = 0.0;
uniform float smoothness_size : hint_range(0.0, 0.5) = 0.3;

vec4 get_mask(vec2 uv) {
	vec4 color = vec4(0,0,0,1);
	float ratio = 1.0 / size_ratio;
	float dist = distance(vec2(location_x, location_y), vec2(mix(0.5, uv.x, ratio), uv.y)) * 2.0;
	
	float circle = distance(vec2(0, 0), vec2(circle_size * ratio, circle_size));
	float alpha_total = (1.0 - 
		smoothstep(
			(circle - smoothness_size) * (1.0 + smoothness_size),
			(circle) * (1.0 + smoothness_size),
			dist
		)
	);
	
	if (invert_mask == true) {
		alpha_total = 1.0 - alpha_total;
	}
	
	color = vec4(vec3(alpha_total), 1);
	
	float highlight = (1.0 - step(circle * (1.0 + highlight_size), dist));
	//if (highlight > 0.0) {
		//color.rgb = vec3(1,1,1);
	//}
	
	return color;
}

vec3 rgb2hsv(vec3 tex) {
	vec3 hsv;
	{
		vec3 c = tex;
		vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
		vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
		vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
		float d = q.x - min(q.w, q.y);
		float e = 1.0e-10;
		return tex = vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
	}
}

void fragment() {
	int size = int(32.0 / size_ratio); // amount of dots
	float dot_size = 1.0; // dots are multiplied by dot_size
	float value_multiplier = 1.0; // reduce or increase value, useful when its too bright
	bool invert = false;
	
	vec4 mask = get_mask(UV);
	vec2 ratio = vec2(1.0, size_ratio);
	
	float fSize = float(size);
	vec2 pixelated_uv = floor(UV * fSize * ratio) / (fSize * ratio);
	float dots = length(fract(UV * fSize * ratio) - vec2(0.5)) * dot_size;
	float value = mask.r;
	
	dots = mix(dots, 1.0 - dots, float(invert)); // choose between original dots and inverted dots using "invert" since bool are only 0 (false) and 1 (true)
	dots += value * value_multiplier; // add dots with pixels value which will shrink them. Also multiply with value mutliplier because sometimes its too bright
	dots = pow(dots, 100.0); // make the dots harder but with anti-aliasing (you can use floor function but the edge will be hard)
	dots = clamp(dots, 0.0, 1.0);
	
	COLOR.a = dots;
}