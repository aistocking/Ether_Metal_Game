shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 spriteTex = texture(TEXTURE, UV);
	vec3 whiteSpriteTex = mix(spriteTex.rgb, vec3(1,1,1), 1.0);
	COLOR.rgb = whiteSpriteTex;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
