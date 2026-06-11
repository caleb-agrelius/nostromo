shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform vec3 screen_color = vec3(0.1, 0.4, 0.1);
uniform float screen_intensity : hint_range(0.0, 1.0) = 0.1;
uniform float fizzle_amount : hint_range(0.0, 1.0) = 0.15;
uniform float scanline_intensity : hint_range(0.0, 1.0) = 0.3;
uniform float time_scale : hint_range(0.0, 10.0) = 1.0;
uniform float opacity : hint_range(0.0, 1.0) = 1.0;

float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 uv) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

void fragment() {
    vec3 screen = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
    
    // Dark green base with intensity
    vec3 green_screen = mix(screen * vec3(0.2, 0.5, 0.2), screen_color, screen_intensity);
    
    // Scanlines (horizontal lines like old CRT screens)
    float scanlines = sin(SCREEN_UV.y * 600.0) * scanline_intensity;
    green_screen *= (1.0 - scanlines * 0.5);
    
    // Screen fizzles/noise artifacts
    float fizzle = noise(SCREEN_UV * 100.0 + TIME * time_scale) * fizzle_amount;
    fizzle += noise(SCREEN_UV * 50.0 - TIME * time_scale * 0.7) * (fizzle_amount * 0.5);
    green_screen += vec3(fizzle) * 0.3;
    
    // Occasional static bursts
    float burst = random(vec2(TIME * time_scale, SCREEN_UV.y)) * fizzle_amount * 0.5;
    green_screen += vec3(burst);
    
    COLOR = vec4(green_screen, opacity);
}