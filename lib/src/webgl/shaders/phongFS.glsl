precision highp float;
precision highp int;

uniform vec3 uEyePosition;

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
uniform vec4 uLightColor0;
  #ifdef SPOTLIGHT0
    uniform vec4 uLightDirection0;
  #endif
  #ifdef HEMILIGHT0
    uniform vec3 uLightGround0;
  #endif
#endif

// light 1
#ifdef LIGHT1
uniform vec4 uLightData1;
uniform vec4 uLightColor1;
  #ifdef SPOTLIGHT1
    uniform vec4 uLightDirection1;
  #endif
  #ifdef HEMILIGHT1
    uniform vec3 uLightGround1;
  #endif
#endif

// light 2
#ifdef LIGHT2
uniform vec4 uLightData2;
uniform vec4 uLightColor2;
  #ifdef SPOTLIGHT2
    uniform vec4 uLightDirection2;
  #endif
  #ifdef HEMILIGHT2
    uniform vec3 uLightGround2;
  #endif
#endif

// light 3
#ifdef LIGHT3
uniform vec4 uLightData3;
uniform vec4 uLightColor3;
  #ifdef SPOTLIGHT3
    uniform vec4 uLightDirection3;
  #endif
  #ifdef HEMILIGHT3
    uniform vec3 uLightGround3;
  #endif
#endif




struct LightingInfo {
  vec3 diffuse;
  vec3 specular;
};

LightingInfo computeLighting(vec3 viewDirection, vec3 normal, vec4 lightData, vec3 diffuseColor, vec3 specularColor, float range) {
  LightingInfo result;

  vec3 lightVector;
  float attenuation = 1.0;
  if (lightData.w == 0.0) {
    vec3 direction = lightData.xyz - vWorldPosition;
    attenuation =  max(0.0, 1.0 - length(direction) / range);
    lightVector = normalize(direction);
  } else {
    lightVector = normalize(-lightData.xyz);
  }

  // diffuse
  float ndl = max(0., dot(normal, lightVector));

  // Specular
  vec3 worldAngle = normalize(viewDirection + lightVector);
  float specComp = max(0., dot(normal, worldAngle));
  specComp = pow(specComp, max(1., uSpecularColor.a));

  result.diffuse = ndl * diffuseColor * attenuation;
  result.specular = specComp * specularColor * attenuation;

  return result;
}






void main(void) {
    vec4 baseColor = vec4(0.0, 0.0, 0.0, 1.0);

    #ifdef DIFFUSE
    baseColor = texture2D(diffuseSampler, vDiffuseUV);
    #endif

    float alpha = baseColor.a;
    vec3 viewDirection = normalize(uEyePosition - vWorldPosition);
    vec3 normal = vNormal;
    

    vec3 diffuseBase = vec3(0.0, 0.0, 0.0);
    vec3 specularBase = vec3(0.0, 0.0, 0.0);
    float shadow = 1.0;

    #ifdef LIGHT0
        #ifdef SPOTLIGHT0
        #endif

        #ifdef HEMILIGHT0
        #endif

        #ifdef POINTDIRLIGHT0
        LightingInfo info = computeLighting(viewDirection, normal, uLightData0, uLightColor0.rgb, uLightColor0.rgb, uLightColor0.a);
        #endif

        diffuseBase += info.diffuse * shadow;
        specularBase += info.specular * shadow;
    #endif

    #ifdef LIGHT1
        #ifdef SPOTLIGHT1
        #endif

        #ifdef HEMILIGHT1
        #endif

        #ifdef POINTDIRLIGHT1
        info = computeLighting(viewDirection, normal, uLightData1, uLightColor1.rgb, uLightColor1.rgb, uLightColor1.a);
        #endif

        diffuseBase += info.diffuse * shadow;
        specularBase += info.specular * shadow;
    #endif

    vec3 finalDiffuse = diffuseBase * baseColor.rgb;
    vec3 finalSpecular = specularBase;

    
    gl_FragColor = vec4(finalDiffuse.rgb + finalSpecular, alpha);
}






