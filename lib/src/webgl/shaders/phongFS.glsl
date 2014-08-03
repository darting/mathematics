precision highp float;
precision highp int;

uniform sampler2D diffuseSampler;
varying vec2 vDiffuseUV;

varying vec4 vPosition;
varying vec3 vNormal;

uniform vec3 uEyePosition;

varying vec3 vWorldPosition;



void main(void) {
    
    
    vec4 diffuseColor = texture2D(diffuseSampler, vDiffuseUV);
    
    float alpha = diffuseColor.a;
    
    vec3 diffuse = vec3(1.0, 1.0, 1.0);
    vec3 specular = vec3(0.0, 0.0, 0.0);
    vec3 viewDirection = normalize(uEyePosition - vWorldPosition);
    
    vec3 normal = vNormal;
    
    vec3 light_colour = vec3(1.0, 1.0, 1.0);
    vec3 light_direction = normalize(vec3(1.0, 1.0, 1.0));
    
    diffuse = clamp(dot(normal, light_direction), 0.0, 1.0) * light_colour;
    
    
    
    vec3 angleW = normalize(viewDirection + light_direction);
    float specComp = max(0., dot(normal, angleW));
    specComp = pow(specComp, max(1., 20.0));
    
    
    float specular_term = specComp;// LightingFuncGGX(normal, viewDirection, light_direction, uRoughess, uReflectivity);
    specular = specular_term * light_colour;
    
    
    gl_FragColor = vec4(diffuseColor.xyz * diffuse + specular, alpha);
}






