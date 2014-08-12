precision highp float;

attribute vec3 aPosition;
attribute vec3 aNormal;


uniform mat4 uModelMat;
uniform mat4 uViewMat;
uniform mat4 uProjectionMat;
uniform vec3 uEyePosition;
uniform mat4 uNormalMat;


// uv
#ifdef UV1
attribute vec2 aUV;
#endif

#ifdef UV2
attribute vec2 aUV2;
#endif

#ifdef SHADOWS
#ifdef LIGHT0
uniform mat4 lightMatrix0;
varying vec4 vPositionFromLight0;
#endif
#ifdef LIGHT1
uniform mat4 lightMatrix1;
varying vec4 vPositionFromLight1;
#endif
#ifdef LIGHT2
uniform mat4 lightMatrix2;
varying vec4 vPositionFromLight2;
#endif
#ifdef LIGHT3
uniform mat4 lightMatrix3;
varying vec4 vPositionFromLight3;
#endif
#endif

varying vec3 vWorldPosition;
varying vec3 vNormal;

#ifdef DIFFUSE
varying vec2 vDiffuseUV; 
#endif

mat3 getNormalMat(mat4 mat) {
    return mat3(mat[0][0], mat[1][0], mat[2][0], mat[0][1], mat[1][1], mat[2][1], mat[0][2], mat[1][2], mat[2][2]);
}

const mat4 offsetMat = mat4(0.5, 0.0, 0.0, 0.0, 0.0, 0.5, 0.0, 0.0, 0.0, 0.0, 0.5, 0.0, 0.5, 0.5, 0.5, 1.0);

void main(void) {
    
    vec4 worldPos = (uModelMat * vec4(aPosition, 1.0));

    vWorldPosition = worldPos.xyz;
    
    gl_Position = uProjectionMat * uViewMat * worldPos;

    
    vec2 uv = vec2(0.0, 0.0);
    #ifdef UV1
        uv = aUV;
    #endif
    #ifdef UV2
        uv = aUV2;
    #endif

    #ifdef DIFFUSE
        vDiffuseUV = uv;
    #endif

    vNormal = normalize(vec3(uNormalMat * vec4(aNormal, 1.0)));

    // Shadows
    #ifdef SHADOWS
    #ifdef LIGHT0
      vPositionFromLight0 = offsetMat * lightMatrix0 * worldPos;
    #endif
    #ifdef LIGHT1
      vPositionFromLight1 = offsetMat * lightMatrix1 * worldPos;
    #endif
    #ifdef LIGHT2
      vPositionFromLight2 = offsetMat * lightMatrix2 * worldPos;
    #endif
    #ifdef LIGHT3
      vPositionFromLight3 = offsetMat * lightMatrix3 * worldPos;
    #endif
    #endif
}