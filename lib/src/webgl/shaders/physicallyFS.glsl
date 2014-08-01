precision highp float;

uniform sampler2D diffuseSampler;
varying vec2 vDiffuseUV;

varying vec4 vPosition;
varying vec3 vNormal;
varying vec3 vLighting;

void main(void) {
    vec3 color = texture2D(diffuseSampler, vDiffuseUV).xyz;
    gl_FragColor = vec4(color * vLighting, 1.0);
}