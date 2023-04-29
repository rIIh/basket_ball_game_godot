shader_type canvas_item;

uniform float circle_size : hint_range(0.0, 1.0) = 0.4;
uniform float size_ratio : hint_range(0.0, 3.0) = 1.0;
uniform float location_x : hint_range(-1.0, 2.0) = 0.5;
uniform float location_y : hint_range(-1.0, 2.0) = 0.5;
uniform bool invert_mask = false;

uniform float highlight_size : hint_range(0.0, 0.05) = 0.0;

void fragment() {
	float ratio = 1.0 / size_ratio;
	float dist = distance(vec2(location_x, location_y), vec2(mix(0.5, UV.x, ratio), UV.y)) * 2.0;
	vec4 orig_color = texture(TEXTURE, UV) * COLOR;
	
	COLOR.rgb = orig_color.rgb;
	
	float circle = distance(vec2(0, 0), vec2(circle_size * ratio, circle_size));
	float alpha_total = (1.0 - step((circle - highlight_size) * (1.0 + highlight_size), dist));
	if (invert_mask == true) {
		alpha_total = 1.0 - alpha_total;
	}
	COLOR.a = alpha_total * orig_color.a;
	
	float highlight = (1.0 - step(circle * (1.0 + highlight_size), dist));
	if (highlight > 0.0) {
		COLOR.rgb = vec3(1,1,1);
	}
}