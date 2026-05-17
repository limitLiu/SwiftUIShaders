#include "HelloWorld.metal.h"

using namespace metal;

[[stitchable]] vec4f16 helloWorld(vec2f position, vec4f16 color) {
  return vec4f16(1.0, 0.0, 1.0, 1.0);
}

[[stitchable]] vec4f16 sinTime(vec2f position, vec4f16 color, f32 time) {
  return vec4f16(abs(sin(time)), 0, 0, 1.0);
}

[[stitchable]] vec4f16 coord(vec2f position, vec4f16 color, vec2f size) {
  let st = position.xy / size;
  return vec4f16(st.x, st.y, 0, 1.0);
}
