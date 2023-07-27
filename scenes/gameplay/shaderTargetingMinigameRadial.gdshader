// NOTE: Shader automatically converted from Godot Engine 3.5.2.stable's CanvasItemMaterial.

shader_type canvas_item;
render_mode blend_mix;

const float PI = 3.14159265358979323846;
const float HALF_PI = PI / 2.;

uniform vec4 u_backgroundColor: hint_color = vec4(1,1,0,1);
uniform vec4 u_targetColor: hint_color = vec4(0,0,1,1);

uniform float u_pin = .3;
uniform float u_pinMargin = .02;
uniform float u_target = .2;
uniform float u_targetMargin = .1;

void vertex() {
	
}

void fragment() {
	vec4 col = vec4(0,0,0,1);
	vec2 screen_size = 1.0 / SCREEN_PIXEL_SIZE;
//	vec2 tex_size = 1.0 / TEXTURE_PIXEL_SIZE;
	
//	float ratio = tex_size.x / tex_size.y;
	vec2 point_coord = SCREEN_UV * screen_size;
	vec2 uv = vec2(UV.x, UV.y);
	uv = vec2(uv.x - .5, 1. - uv.y);
	
	// from 0 to pi (right to left)
	float angle = atan(uv.y, uv.x);
	float normalized_angle = 1. - angle / PI;
	
	// center it
	angle -= PI / 2.;
	angle = HALF_PI * 1.1 - abs(angle);
//	angle = HALF_PI - abs(angle);
//	angle = abs(angle);
	angle = angle / HALF_PI;
	col = (u_backgroundColor * angle);
	col = vec4(u_backgroundColor.rgb, angle);
//	col.rgb = (u_backgroundColor * angle).rgb;
	
	// abs diff between angle target and the current angle
	float diff = abs(normalized_angle - u_target);
	if (diff < u_targetMargin / 2.) {
		float diff_normalized = abs(normalized_angle - u_target) / (u_targetMargin / 2.);
		diff_normalized = pow(diff_normalized, 3.);
		
		col.rgb = mix(col, u_targetColor, 1. - diff_normalized).rgb;
	}
	
	// pin
	diff = abs(normalized_angle - u_pin);
	if (diff < u_pinMargin) {
		col.rgb = vec3(0);
	}
	
	float d = distance(uv, vec2(0,0));
	if (d < .3 || d > .5) {
		col.a = 0.;
	}
	
	COLOR = col;
}