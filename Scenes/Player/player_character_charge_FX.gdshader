shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform bool charging = false;
uniform vec3 charge_color;
uniform float mix_factor = 0.5;

void fragment() {
	vec4 _texture = textureLod(screen_texture, SCREEN_UV, 0.0);

	if (_texture.a > 0.0001) {
		_texture.rgb /= _texture.a;
	}
	
	vec4 _final_texture = _texture;
	
	if (charging == true) {
		_final_texture.rgb = mix(_texture.rgb, charge_color, mix_factor);
	}
	
	COLOR *= _final_texture;
}
