shader_type spatial;
render_mode cull_front, unshaded, blend_add;

uniform float outline_width : hint_range(0.0, 0.1) = 0.01;
uniform vec3 outline_color = vec3(0.0, 1.0, 0.0);

void vertex() {
    VERTEX += NORMAL * outline_width;
}

void fragment() {
    ALBEDO = outline_color;
}
