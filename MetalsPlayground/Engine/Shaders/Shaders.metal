//
//  Shaders.metal
//  MetalsPlayground
//
//  Created by Scott Recker on 10/26/23.
//

#include <metal_stdlib>
#include "../defines.h"

using namespace metal;

struct Fragment {
    float4 position [[position]];
    float4 color;
};

vertex Fragment vertexShader(const device Vertex *vertices [[buffer(0)]], uint vertexId [[vertex_id]]) {
    Vertex input = vertices[vertexId];
    Fragment data;
    data.position = float4(input.position, 1.0);
    data.color = input.color;
    return data;
}

fragment float4 fragmentShader(Fragment input [[stage_in]]) {
    return input.color;
}
