shader_type spatial;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE;

uniform sampler2D depth_texture : hint_depth_texture;

void vertex() {
    POSITION = vec4(VERTEX, 1.0);
}

void fragment() {
    float depth = texture(depth_texture, SCREEN_UV).x;
    // Compatibility RENDERER
    vec3 ndc = vec3(SCREEN_UV, depth) * 2.0 - 1.0;
    // non Compatability RENDERER
    // vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, depth);
    
    vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
    view.xyz /= view.w;
    float linear_depth = -view.z;

    vec4 world = INV_VIEW_MATRIX * INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
    vec3 world_position = world.xyz / world.w;

    // Visualize linear depth
    ALBEDO.rgb = vec3(fract(linear_depth));
}