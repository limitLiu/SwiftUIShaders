#include <metal_stdlib>
#include "Common.h.metal"

using namespace metal;

vec3f moonSphereNormals(vec2f uv) {
  uv = fract(uv) * 2.0 - 1.0;

  var normal = vec3f(0.0);
  normal.xy = sqrt(uv * uv) * sign(uv);
  normal.z = sqrt(abs(1.0 - dot(normal.xy, normal.xy)));
  normal = normal * 0.5 + 0.5;

  let mask = 1.0 - smoothstep(0.98, 1.0, dot(uv, uv));
  return mix(vec3f(0.0), normal, mask);
}

vec2f moonSphereCoords(vec2f st, f32 scale) {
  let maxFactor = sin(M_PI_2_F);
  var uv = vec2f(0.0);
  let xy = 2.0 * st - 1.0;
  var d = length(xy);

  if (d < 2.0 - maxFactor) {
    d = length(xy * maxFactor);
    let z = sqrt(1.0 - d * d);
    let r = atan2(d, z) / M_PI_F * scale;
    let phi = atan2(xy.y, xy.x);

    uv.x = r * cos(phi) + 0.5;
    uv.y = r * sin(phi) + 0.5;
  } else {
    uv = st;
  }

  return uv;
}

[[stitchable]] vec4f16 moon(
  vec2f position,
  vec4f16 currentColor,
  vec2f size,
  texture2d<f16, access::sample> moonTexture,
  vec2f textureSize,
  f32 time,
  f32 darkMode
) {
  constexpr sampler textureSampler(coord::normalized, address::repeat, filter::linear, mip_filter::linear);
  let speedMoon = 0.01;
  let speedSun = 0.25;

  let st = position / size;
  var sampleUV = moonSphereCoords(st, 1.0);
  let textureAspect = textureSize.y / textureSize.x;
  sampleUV.x = fract(sampleUV.x * textureAspect + time * speedMoon);

  var color = vec3f(moonTexture.sample(textureSampler, sampleUV).rgb);

  let sunPos = normalize(vec3f(cos(time * speedSun - M_PI_2_F), 0.0, sin(time * speedSun - M_PI_2_F)));
  let surface = normalize(moonSphereNormals(st) * 2.0 - 1.0);

  color *= dot(sunPos, surface);

  let radius = 1.0 - length(vec2f(0.5) - st) * 2.0;
  color *= smoothstep(0.001, 0.05, radius);
  color = 1.0 - color;

  if (darkMode > 0.5) {
    color = 1.0 - color;
  }

  return vec4f16(vec4f(color, 1.0));
}
