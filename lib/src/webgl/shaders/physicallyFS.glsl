precision highp float;
precision highp int;

#define PI 3.1415926535897932384626433832795
#define PI_OVER_TWO 1.5707963267948966
#define PI_OVER_FOUR 0.7853981633974483
#extension GL_OES_standard_derivatives : enable

uniform sampler2D diffuseSampler;
varying vec2 vDiffuseUV;

uniform float uAlbedo;
uniform float uRoughess;
uniform float uReflectivity;

varying vec4 vPosition;
varying vec3 vNormal;

uniform vec3 uEyePosition;

varying vec3 vWorldPosition;


float saturate(float d) {
    return clamp(d, 0.0, 1.0);
}

float G1V(float dotNV, float k) {
    return 1.0/(dotNV*(1.0-k)+k);
}

vec2 LightingFuncGGX_FV(float dotLH, float roughness) {
    float alpha = roughness*roughness;

    // F
    float F_a, F_b;
    float dotLH5 = pow(1.0-dotLH,5.0);
    F_a = 1.0;
    F_b = dotLH5;
    
    // V
    float vis;
    float k = alpha/2.0;
    float k2 = k*k;
    float invK2 = 1.0-k2;
    vis = inversesqrt(dotLH*dotLH*invK2 + k2);
    return vec2(F_a*vis,F_b*vis);
}

float LightingFuncGGX_D(float dotNH, float roughness) {
    float alpha = roughness*roughness;
    float alphaSqr = alpha*alpha;
    float denom = dotNH * dotNH *(alphaSqr-1.0) + 1.0;
    float D = alphaSqr/(PI * denom * denom);
    return D;
}

float LightingFuncGGX(vec3 N, vec3 V, vec3 L, float roughness, float F0) {
    vec3 H = normalize(V+L);
    
    float dotNL = saturate(dot(N,L));
    float dotLH = saturate(dot(L,H));
    float dotNH = saturate(dot(N,H));
    
    float D = LightingFuncGGX_D(dotNH,roughness);
    vec2 FV_helper = LightingFuncGGX_FV(dotLH,roughness);
    float FV = F0*FV_helper.x + (1.0-F0)*FV_helper.y;
    float specular = dotNL * D * FV;
    return specular;
}

void main(void) {
    
    
    vec4 diffuseColor = texture2D(diffuseSampler, vDiffuseUV);

    float alpha = diffuseColor.a;
    vec3 color = uAlbedo * diffuseColor.xyz;
    
    vec3 diffuse = vec3(1.0, 1.0, 1.0);
    vec3 specular = vec3(0.0, 0.0, 0.0);
    vec3 viewDirection = normalize(uEyePosition - vWorldPosition);
    
    vec3 normal = vNormal;
#ifdef BUMP
    normal = perturbNormal(viewDirection);
#endif
    
    vec3 light_colour = vec3(1.0, 1.0, 1.0);
    vec3 light_direction = normalize(vec3(1.0, 1.0, 1.0));
    
    diffuse = clamp(dot(normal, light_direction), 0.0, 1.0) * light_colour;
    
    float specular_term = LightingFuncGGX(normal, viewDirection, light_direction, uRoughess, uReflectivity);
    specular = specular_term * light_colour;
    
    
    gl_FragColor = vec4(color * diffuse + specular, alpha);
}






