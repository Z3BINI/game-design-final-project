shader_type spatial;

// Uniforms to customize the effect
uniform float blob_speed : hint_range(0.0, 5.0) = 1.0;
uniform float blob_size : hint_range(0.1, 1.0) = 0.5;
uniform vec4 blob_color = vec4(1.0, 0.5, 0.2, 1.0); // Color for the blobs
uniform vec4 background_color = vec4(0.0, 0.0, 0.0, 1.0); // Background color
uniform vec2 uv_scale = vec2(1.0, 2.0); // Scale the UV to fit the mesh better

// Noise texture for smooth blob movement
uniform sampler2D noise_texture;

void fragment() {
    // Scale UV coordinates
    vec2 scaled_uv = UV * uv_scale;
    vec2 uv = scaled_uv * 2.0 - vec2(1.0); // Normalize UV to range [-1, 1]
    float time = TIME * blob_speed;

    // Sample noise texture for pseudo-random movement
    vec2 blob1_pos = vec2(sin(time), cos(time * 0.8));
    vec2 blob2_pos = vec2(cos(time * 1.2), sin(time * 1.5));

    // Calculate distances to blob centers
    float blob1 = exp(-length(uv - blob1_pos) / blob_size);
    float blob2 = exp(-length(uv - blob2_pos) / blob_size);

    // Combine blob contributions
    float combined_blobs = blob1 + blob2;

    // Smooth transition between blobs and background
    float mask = smoothstep(0.3, 0.6, combined_blobs);

    // Blend colors
    vec4 final_color = mix(background_color, blob_color, mask);

    ALBEDO = final_color.rgb;
    ALPHA = final_color.a;
}
