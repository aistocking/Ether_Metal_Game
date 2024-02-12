shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 spriteTex = texture(TEXTURE, UV);
	vec3 blueSpriteTex = mix(spriteTex.rgb, vec3(0,0,1), 1);
	COLOR.rgb = blueSpriteTex;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
