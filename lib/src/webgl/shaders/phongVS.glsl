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



varying vec3 vWorldPosition;
varying vec4 vEyeSpacePosition;
varying vec3 vNormal;

#ifdef DIFFUSE
varying vec2 vDiffuseUV; 
#endif

mat3 getNormalMat(mat4 mat) {
    return mat3(mat[0][0], mat[1][0], mat[2][0], mat[0][1], mat[1][1], mat[2][1], mat[0][2], mat[1][2], mat[2][2]);
}

void main(void) {
    
    vWorldPosition = (uModelMat * vec4(aPosition, 1.0)).xyz;

    vEyeSpacePosition = uViewMat * vec4(vWorldPosition, 1.0);
    
    gl_Position = uProjectionMat * uViewMat * vec4(vWorldPosition, 1.0);

    
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
}