shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	vec4 spriteTex = textureLod(screen_texture, SCREEN_UV, 0.0);

	if (spriteTex.a > 0.0001) {
		spriteTex.rgb /= spriteTex.a;
	}
	COLOR *= spriteTex;
	vec3 blueSpriteTex = mix(spriteTex.rgb, vec3(1,1,1), 0.5);
	COLOR.rgb = blueSpriteTex;
}
