#ifndef MOON_H
#define MOON_H

#include <metal_stdlib>

#include "Common.metal.h"

vec3f moonSphereNormals(vec2f uv);

vec2f moonSphereCoords(vec2f st, f32 scale);

[[stitchable]] vec4f16 moon(
  vec2f position,
  vec4f16 currentColor,
  vec2f size,
  metal::texture2d<f16, metal::access::sample> moonTexture,
  vec2f textureSize,
  f32 time,
  f32 darkMode
);

#endif
