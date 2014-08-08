precision highp float;
precision highp int;

uniform vec3 uEyePosition;
uniform mat4 uViewMat;

uniform vec3 uAmbientColor;
uniform vec4 uDiffuseColor;
uniform vec3 uEmissiveColor;
uniform vec4 uSpecularColor;

varying vec3 vNormal;
varying vec3 vWorldPosition;

varying vec4 vEyeSpacePosition;



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
#endif




struct LightingInfo {
  vec3 diffuse;
  vec3 specular;
};

LightingInfo computeLighting(vec3 viewDirection, vec3 normal, vec3 position, vec4 lightData, 
                             vec3 diffuseColor, vec3 specularColor, float range, float shininess) {

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
    //lightVector = -lightData.xyz;
    lightVector = -normalize((uViewMat * vec4(lightData.xyz, 0.0)).xyz);
  }

  // diffuse
  float ndl = max(0.0, dot(normal, lightVector));
  result.diffuse = ndl * diffuseColor * attenuation;


  // Specular
  if(ndl >= 0.0) {
  
    vec3 H = normalize(viewDirection + lightVector);
    H = reflect(-lightVector, normal);
    float specComp = pow(max(0.0, dot(normal, H)), shininess);

    // vec3 worldAngle = normalize(viewDirection + lightVector);
    // float specComp = max(0.0, dot(normal, worldAngle));
    // specComp = pow(specComp, max(1.0, shininess));

    result.specular = specComp * specularColor * attenuation;
  }
  // } else {
  //   result.specular = vec3(0.0, 0.0, 0.0);
  // }
  return result;
}






void main(void) {

    vec3 diffuseColor = uDiffuseColor.rgb;
    float alpha = uDiffuseColor.a;

    vec4 baseColor = vec4(1.0, 1.0, 1.0, 1.0);

    #ifdef DIFFUSE
        baseColor = texture2D(diffuseSampler, vDiffuseUV);
    #endif


    vec3 viewDirection = normalize(uEyePosition - vWorldPosition);
    vec3 position = vWorldPosition;
    vec3 normal = vNormal;

    vec3 eye = vec3(uViewMat * vec4(uEyePosition, 1.0));
    position = vEyeSpacePosition.xyz;
    viewDirection = normalize(eye - position);

    

    vec3 diffuseBase = vec3(0.0, 0.0, 0.0);
    vec3 specularBase = vec3(0.0, 0.0, 0.0);
    float shadow = 1.0;
    float shininess = uSpecularColor.a;

    #ifdef LIGHT0
        #ifdef SPOTLIGHT0
        #endif

        #ifdef HEMILIGHT0
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

        diffuseBase += info.diffuse * shadow;
        specularBase += info.specular * shadow;
    #endif


    vec3 finalDiffuse = clamp(diffuseBase * diffuseColor, 0.0, 1.0) * baseColor.rgb;
    vec3 finalSpecular = specularBase;

    
    gl_FragColor = vec4(finalDiffuse + finalSpecular, alpha);
    //gl_FragColor = vec4(finalSpecular, alpha);
}






