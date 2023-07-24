// NOTE: Shader automatically converted from Godot Engine 3.5.2.stable's CanvasItemMaterial.

shader_type canvas_item;
render_mode blend_mix;

const float PI = 3.14159265358979323846;
const float HALF_PI = PI / 2.;

uniform float u_pin = .3;
uniform float u_pinMargin = .02;
uniform float u_target = .2;
uniform float u_targetMargin = .1;

void vertex() {
	
//	VERTEX.y += sin(VERTEX.x) * 100.0;
	
}

void fragment() {
	vec4 col = vec4(0,0,0,1);
	vec2 screen_size = 1.0 / SCREEN_PIXEL_SIZE;
//	vec2 tex_size = 1.0 / TEXTURE_PIXEL_SIZE;
	
//	float ratio = tex_size.x / tex_size.y;
	vec2 point_coord = SCREEN_UV * screen_size;
	vec2 uv = vec2(UV.x, UV.y);
	uv = vec2(uv.x - .5, 1. - uv.y);
	
	float d = distance(uv, vec2(0,0));
	if (d < .3 || d > .5) {
		col.a = 0.;
	}
	
	// from 0 to pi (right to left)
	float angle = atan(uv.y, uv.x);
	float normalized_angle = 1. - angle / PI;
	
	// center it
	angle -= PI / 2.;
	angle = HALF_PI * pow(1.1, 3) - abs(angle);
	angle = angle / PI;
	col.r = angle;
	
	// abs diff between angle target and the current angle
	float diff = abs(normalized_angle - u_target);
	if (diff < u_targetMargin) {
		float diff_normalized = 1. - pow(diff, 1.05) / u_targetMargin;
		col.g = diff_normalized;

	}
	
	// pin
	diff = abs(normalized_angle - u_pin);
	if (diff < u_pinMargin) {
		col.rgb = vec3(0);
	}
	
	COLOR = col;
}