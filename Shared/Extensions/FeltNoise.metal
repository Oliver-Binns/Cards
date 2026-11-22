#include <metal_stdlib>
using namespace metal;

[[ stitchable ]] half4 feltNoise(float2 position, half4 color, float intensity) {
    // Fast procedural hash based on pixel coordinates
    float random = fract(sin(dot(position, float2(12.9898, 78.233))) * 43758.5453);

    // Shift brightness slightly up or down per pixel (-intensity to +intensity)
    half grain = half((random - 0.5) * intensity);

    return half4(color.rgb + grain, color.a);
}
