precision highp float;
precision highp int;

uniform vec3 uEyePosition;

uniform vec3 uAmbientColor;
uniform vec4 uDiffuseColor;
uniform vec3 uEmissiveColor;
uniform vec4 uSpecularColor;

varying vec3 vNormal;
varying vec3 vWorldPosition;



// diffuse
#ifdef DIFFUSE
uniform sampler2D diffuseSampler;
varying vec2 vDiffuseUV;
#endif

// light 0
#ifdef LIGHT0
uniform vec4 uLightData0;
uniform vec4 uLightDiffuse0;
uniform vec3 uLightSpecular0;
  #ifdef SPOTLIGHT0
    uniform vec4 uLightDirection0;
  #endif
  #ifdef HEMILIGHT0
    uniform vec3 uLightGround0;
  #endif
  #ifdef SHADOW0
    varying vec4 vPositionFromLight0;
    uniform sampler2D shadowSampler0;
    uniform float darkness0;
  #endif
#endif

// light 1
#ifdef LIGHT1
uniform vec4 uLightData1;
uniform vec4 uLightDiffuse1;
uniform vec3 uLightSpecular1;
  #ifdef SPOTLIGHT1
    uniform vec4 uLightDirection1;
  #endif
  #ifdef HEMILIGHT1
    uniform vec3 uLightGround1;
  #endif
  #ifdef SHADOW1
    varying vec4 vPositionFromLight1;
    uniform sampler2D shadowSampler1;
    uniform float darkness1;
  #endif
#endif

// light 2
#ifdef LIGHT2
uniform vec4 uLightData2;
uniform vec4 uLightDiffuse2;
uniform vec3 uLightSpecular2;
  #ifdef SPOTLIGHT2
    uniform vec4 uLightDirection2;
  #endif
  #ifdef HEMILIGHT2
    uniform vec3 uLightGround2;
  #endif
  #ifdef SHADOW2
    varying vec4 vPositionFromLight2;
    uniform sampler2D shadowSampler2;
    uniform float darkness2;
  #endif
#endif

// light 3
#ifdef LIGHT3
uniform vec4 uLightData3;
uniform vec4 uLightDiffuse3;
uniform vec3 uLightSpecular3;
  #ifdef SPOTLIGHT3
    uniform vec4 uLightDirection3;
  #endif
  #ifdef HEMILIGHT3
    uniform vec3 uLightGround3;
  #endif
  #ifdef SHADOW3
    varying vec4 vPositionFromLight3;
    uniform sampler2D shadowSampler3;
    uniform float darkness3;
  #endif
#endif




struct LightingInfo {
  vec3 diffuse;
  vec3 specular;
};


LightingInfo computeSpotLighting(vec3 viewDirection, vec3 normal, vec3 position, 
                                 vec4 lightData, vec4 lightDirection, 
                                 vec3 diffuseColor, vec3 specularColor, float range, float shininess) {
    
    LightingInfo result;

    vec3 direction = lightData.xyz - position;
    vec3 lightVector = normalize(direction);

    // diffuse
    float cosAngle = max(0.0, dot(-lightDirection.xyz, lightVector));
    float spotAtten = 0.0;

    float angle = lightDirection.w;

    if (cosAngle >= angle) {
        float exponent = lightData.w;
        float attenuation = max(0.0, 1.0 - length(direction) / range);

        cosAngle = max(0.0, pow(cosAngle, exponent));
        spotAtten = max(0.0, (cosAngle - angle) / (1.0 - cosAngle));

        // Diffuse
        float ndl = max(0.0, dot(normal, -lightDirection.xyz));

        // Specular
        vec3 H = normalize(viewDirection - lightDirection.xyz); //reflect(-lightVector.xyz, normal);
        float specComp = pow(max(0.0, dot(normal, H)), range);

        result.diffuse = ndl * spotAtten * diffuseColor * attenuation;
        result.specular = specComp * specularColor * spotAtten * attenuation;

        return result;
    }

    result.diffuse = vec3(0.0);
    result.specular = vec3(0.0);

    return result;
}


// compute point and directinal lighting
LightingInfo computeLighting(vec3 viewDirection, vec3 normal, vec3 position, 
                             vec4 lightData, vec3 diffuseColor, vec3 specularColor, 
                             float range, float shininess) {

    LightingInfo result;

    vec3 lightVector;
    float attenuation = 1.0;
    if (lightData.w == 0.0) {
        // point light
        vec3 direction = lightData.xyz - position;
        attenuation =  max(0.0, 1.0 - length(direction) / range);
        lightVector = normalize(direction);
    } else {
        // directional light
        lightVector = -lightData.xyz;
    }

    // diffuse
    float ndl = max(0.0, dot(normal, lightVector));
    result.diffuse = ndl * diffuseColor * attenuation;

    // Specular
    if(ndl >= 0.0) {
        vec3 R = reflect(-lightVector, normal);
        float specular = pow(max(0.0, dot(normal, R)), shininess);
        result.specular = specular * specularColor * attenuation;
    } else {
        result.diffuse = vec3(0.0);
        result.specular = vec3(0.0);
    }
    return result;
}


LightingInfo computeHemisphericLighting(vec3 viewDirection, vec3 normal, vec4 lightData, vec3 diffuseColor, vec3 specularColor, vec3 groundColor, float shininess) {
    LightingInfo result;

    // Diffuse
    float ndl = dot(normal, lightData.xyz) * 0.5 + 0.5;

    // Specular
    vec3 H = normalize(viewDirection + lightData.xyz);
    float specular = pow(max(0.0, dot(normal, H)), shininess);

    result.diffuse = mix(groundColor, diffuseColor, ndl);
    result.specular = specular * specularColor;

    return result;
}



// Shadows
#ifdef SHADOWS

float unpack(vec4 color) {
  const vec4 bitShift = vec4(1. / (255. * 255. * 255.), 1. / (255. * 255.), 1. / 255., 1.);
  return dot(color, bitShift);
}

float unpackHalf(vec2 color) {
  return color.x + (color.y / 255.0);
}

float computeShadow(vec4 vPositionFromLight, sampler2D shadowSampler, float darkness) {
  vec3 depth = vPositionFromLight.xyz / vPositionFromLight.w;
  vec2 uv = 0.5 * depth.xy + vec2(0.5, 0.5);
  if (uv.x < 0. || uv.x > 1.0 || uv.y < 0. || uv.y > 1.0) {
    return 1.0;
  }
  float shadow = unpack(texture2D(shadowSampler, uv));
  if (depth.z > shadow) {
    return darkness;
  }
  return 1.0;
}

// Thanks to http://devmaster.net/
float ChebychevInequality(vec2 moments, float t) {
  if (t <= moments.x) {
    return 1.0;
  }

  float variance = moments.y - (moments.x * moments.x);
  variance = max(variance, 0.);

  float d = t - moments.x;
  return variance / (variance + d * d);
}

float computeShadowWithVSM(vec4 vPositionFromLight, sampler2D shadowSampler) {
  vec3 depth = vPositionFromLight.xyz / vPositionFromLight.w;
  vec2 uv = 0.5 * depth.xy + vec2(0.5, 0.5);

  if (uv.x < 0. || uv.x > 1.0 || uv.y < 0. || uv.y > 1.0) {
    return 1.0;
  }

  vec4 texel = texture2D(shadowSampler, uv);

  vec2 moments = vec2(unpackHalf(texel.xy), unpackHalf(texel.zw));
  return clamp(1.3 - ChebychevInequality(moments, depth.z), 0., 1.0);
}
#endif




void main(void) {

    vec3 diffuseColor = uDiffuseColor.rgb;
    float alpha = uDiffuseColor.a;

    vec4 baseColor = vec4(1.0, 1.0, 1.0, 1.0);

    #ifdef DIFFUSE
        baseColor = texture2D(diffuseSampler, vDiffuseUV);
    #endif


    vec3 viewDirection = normalize(uEyePosition - vWorldPosition);
    vec3 position = vWorldPosition;
    vec3 normal = normalize(vNormal);
    

    vec3 diffuseBase = vec3(0.0, 0.0, 0.0);
    vec3 specularBase = vec3(0.0, 0.0, 0.0);
    float shadow = 1.0;
    vec3 specularColor = uSpecularColor.rgb;
    float shininess = uSpecularColor.a;
    vec3 emissiveColor = uEmissiveColor;

    #ifdef LIGHT0
        #ifdef SPOTLIGHT0
        LightingInfo info = computeSpotLighting(viewDirection, 
                                            normal,
                                            position,
                                            uLightData0, 
                                            uLightDirection0,
                                            uLightDiffuse0.rgb, 
                                            uLightSpecular0,
                                            uLightDiffuse0.a, 
                                            shininess);
        #endif

        #ifdef HEMILIGHT0
        LightingInfo info = computeHemisphericLighting(viewDirection, 
                                            normal,
                                            uLightData0, 
                                            uLightDiffuse0.rgb, 
                                            uLightSpecular0,
                                            uLightGround0, 
                                            shininess);
        #endif

        #ifdef POINTDIRLIGHT0
        LightingInfo info = computeLighting(viewDirection, 
                                            normal,
                                            position,
                                            uLightData0, 
                                            uLightDiffuse0.rgb, 
                                            uLightSpecular0,
                                            uLightDiffuse0.a, 
                                            shininess);
        #endif

        #ifdef SHADOW0
        #ifdef SHADOWVSM0
          shadow = computeShadowWithVSM(vPositionFromLight0, shadowSampler0);
        #else
          shadow = computeShadow(vPositionFromLight0, shadowSampler0, darkness0);
        #endif
        #else
          shadow = 1.0;
        #endif

        diffuseBase += info.diffuse * shadow;
        specularBase += info.specular * shadow;
    #endif


    #ifdef LIGHT1
        #ifdef SPOTLIGHT1
        info = computeSpotLighting(viewDirection, 
                                normal,
                                position,
                                uLightData1, 
                                uLightDirection1,
                                uLightDiffuse1.rgb, 
                                uLightSpecular1,
                                uLightDiffuse1.a, 
                                shininess);
        #endif

        #ifdef HEMILIGHT1
        info = computeHemisphericLighting(viewDirection, 
                                            normal,
                                            uLightData1, 
                                            uLightDiffuse1.rgb, 
                                            uLightSpecular1,
                                            uLightGround1, 
                                            shininess);
        #endif

        #ifdef POINTDIRLIGHT1
        info = computeLighting(viewDirection, 
                            normal,
                            position,
                            uLightData1, 
                            uLightDiffuse1.rgb, 
                            uLightSpecular1,
                            uLightDiffuse1.a, 
                            shininess);
        #endif

        #ifdef SHADOW1
        #ifdef SHADOWVSM1
          shadow = computeShadowWithVSM(vPositionFromLight1, shadowSampler1);
        #else
          shadow = computeShadow(vPositionFromLight1, shadowSampler1, darkness1);
        #endif
        #else
          shadow = 1.0;
        #endif

        diffuseBase += info.diffuse * shadow;
        specularBase += info.specular * shadow;
    #endif
    
    #ifdef LIGHT2
        #ifdef SPOTLIGHT2
        info = computeSpotLighting(viewDirection, 
                                normal,
                                position,
                                uLightData2, 
                                uLightDirection2,
                                uLightDiffuse2.rgb, 
                                uLightSpecular2,
                                uLightDiffuse2.a, 
                                shininess);
        #endif

        #ifdef HEMILIGHT2
        info = computeHemisphericLighting(viewDirection, 
                                            normal,
                                            uLightData2, 
                                            uLightDiffuse2.rgb, 
                                            uLightSpecular2,
                                            uLightGround2, 
                                            shininess);
        #endif

        #ifdef POINTDIRLIGHT2
        info = computeLighting(viewDirection, 
                            normal,
                            position,
                            uLightData2, 
                            uLightDiffuse2.rgb, 
                            uLightSpecular2,
                            uLightDiffuse2.a, 
                            shininess);
        #endif

        #ifdef SHADOW2
        #ifdef SHADOWVSM2
          shadow = computeShadowWithVSM(vPositionFromLight2, shadowSampler2);
        #else
          shadow = computeShadow(vPositionFromLight2, shadowSampler2, darkness2);
        #endif
        #else
          shadow = 1.0;
        #endif

        diffuseBase += info.diffuse * shadow;
        specularBase += info.specular * shadow;
    #endif


    #ifdef LIGHT3
        #ifdef SPOTLIGHT3
        info = computeSpotLighting(viewDirection, 
                                normal,
                                position,
                                uLightData3, 
                                uLightDirection3,
                                uLightDiffuse3.rgb, 
                                uLightSpecular3,
                                uLightDiffuse3.a, 
                                shininess);
        #endif

        #ifdef HEMILIGHT3
        info = computeHemisphericLighting(viewDirection, 
                                            normal,
                                            uLightData3, 
                                            uLightDiffuse3.rgb, 
                                            uLightSpecular3,
                                            uLightGround3, 
                                            shininess);
        #endif

        #ifdef POINTDIRLIGHT3
        info = computeLighting(viewDirection, 
                            normal,
                            position,
                            uLightData3, 
                            uLightDiffuse3.rgb, 
                            uLightSpecular3,
                            uLightDiffuse3.a, 
                            shininess);
        #endif

        #ifdef SHADOW3
        #ifdef SHADOWVSM3
          shadow = computeShadowWithVSM(vPositionFromLight3, shadowSampler3);
        #else
          shadow = computeShadow(vPositionFromLight3, shadowSampler3, darkness3);
        #endif
        #else
          shadow = 1.0;
        #endif

        diffuseBase += info.diffuse * shadow;
        specularBase += info.specular * shadow;
    #endif

    


    vec3 finalDiffuse = clamp(diffuseBase * diffuseColor + uAmbientColor + emissiveColor, 0.0, 1.0) * baseColor.rgb;
    vec3 finalSpecular = specularBase * specularColor;

    
    gl_FragColor = vec4(finalDiffuse + finalSpecular, alpha);
}






