precision highp float;

varying vec4 vPosition;
varying vec3 vNormal;

void main(void) {
    
    highp vec3 ambientLight = vec3(0.6, 0.6, 0.6);
    highp vec3 directionalLightColor = vec3(0.5, 0.5, 0.75);
    highp vec3 directionalVector = vec3(-2.0, 2.0, 2.0);
    highp float directional = max(dot(vNormal, directionalVector), 0.0);
    vec3 lighting = ambientLight + (directionalLightColor * directional);
    
    vec3 color = vec3(0.4, 0.4, 0.4);
    gl_FragColor = vec4(color * lighting, 1.0);
}