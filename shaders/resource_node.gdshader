shader_type spatial;
render_mode unshaded, cull_back, depth_draw_opaque;

uniform vec4 base_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float rim_power : hint_range(0.1, 5.0) = 2.0;
uniform float rim_strength : hint_range(0.0, 3.0) = 2.5;
uniform vec3 outline_color = vec3(1.0, 1.0, 1.0);
uniform float glimmer_speed : hint_range(0.1, 10.0) = 2.0;
uniform float glimmer_intensity : hint_range(0.0, 2.0) = 0.8;

void fragment() {
    // Rim/silhouette effect: bright white on edges
    float rim = pow(1.0 - dot(normalize(NORMAL), normalize(VIEW)), rim_power);
    rim *= rim_strength;
    
    // Animated glimmer
    float pulse = sin(TIME * glimmer_speed) * 0.5 + 0.5;
    float wave = sin(TIME * glimmer_speed * 0.5 + VERTEX.x * 3.0) * 0.3;
    float glimmer = clamp(pulse + wave, 0.0, 1.0);
    
    // Base color
    ALBEDO = base_color.rgb;
    
    // White rim outline + glimmer
    EMISSION = (outline_color * rim) + (vec3(1.0) * glimmer * glimmer_intensity);
}