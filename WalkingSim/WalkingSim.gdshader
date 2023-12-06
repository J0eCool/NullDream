shader_type spatial;



float wave(float s) {
	return 0.5 + 0.5*sin(TAU*s);
}

void fragment() {
	// Place fragment code here.
	vec3 c = vec3(1.0, 0, 0);
//	vec3 pos = (vec4(VERTEX, 1) * INV_VIEW_MATRIX).xyz;
	vec3 pos = (INV_VIEW_MATRIX * vec4(VERTEX, 1)).xyz;
//	c.r = 0.5 + 0.5*sin(0.3*TAU*TIME);
	c.r = wave(pos.x + TIME);
	c.g = wave(2.*pos.y + TIME);
	c.b = wave(pos.z + 3.*TIME);
//	c = pos;
//	c.r = VERTEX.x
	ALBEDO = c;
}
