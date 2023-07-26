// NOTE: Shader automatically converted from Godot Engine 3.5.1.stable's CanvasItemMaterial.

shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D scrolling_tex;
uniform sampler2D scrolling_tex2;

uniform vec4 u_to: hint_color = vec4(1,1,0,1);

uniform vec2 u_textureSize = vec2(1,1);

uniform float u_progress = .4;
uniform float u_visualProgress = .25;
uniform float u_fadeMargin = .05;

void fragment() {
	vec4 col;
	col = vec4(vec3(.7),1);
	vec2 uv = UV;
	
	float fade_margin = u_progress - u_visualProgress;
	
	vec2 tex_size = u_textureSize;
	float ratio = tex_size.x / tex_size.y;
	uv.x *= ratio;
	vec2 uv2 = uv;
	uv.x -= TIME * .2;
	uv2.x += TIME * 1.2;
	vec4 tex_col = texture(scrolling_tex, uv);
//	vec4 tex_col = (texture(scrolling_tex, uv) + texture(scrolling_tex2, uv2)) / 2.;
	
	float influence = tex_col.r + .2;
//	col = mix(u_from, u_to, influence);
	col = mix(texture(SCREEN_TEXTURE, SCREEN_UV), u_to, influence);
	
	
	if (UV.x > u_progress - fade_margin) {
		float diff = UV.x - (u_progress - fade_margin);
		col.a = 1. - pow((diff / fade_margin), 1.);
	}
	
//	if (UV.x > u_progress) {
//		col.a = 0.;
//	}
	
	COLOR = col;
}