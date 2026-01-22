shader_type canvas_item;

uniform sampler2D noise_texture;
uniform float threshold : hint_range(0.0, 1.0) = 0.0;


void fragment() {
	float noise_value = texture(noise_texture, UV).r;
	float alpha = step(noise_value, threshold);
	COLOR = vec4(0.0, 0.0, 0.0, alpha);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
