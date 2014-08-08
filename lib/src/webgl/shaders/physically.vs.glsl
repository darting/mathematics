precision highp float;
attribute vec3 aPosition;
attribute vec3 aNormal;


uniform mat4 uModelMat;
uniform mat4 uViewMat;
uniform mat4 uProjectionMat;
uniform vec3 uEyePosition;


attribute vec2 aUV;
varying vec2 vDiffuseUV;


varying vec3 vWorldPosition;
varying vec3 vNormal;

mat3 getNormalMat(mat4 mat) {
    return mat3(mat[0][0], mat[1][0], mat[2][0], mat[0][1], mat[1][1], mat[2][1], mat[0][2], mat[1][2], mat[2][2]);
}

void main(void) {
    mat4 modelViewMat;
    
    modelViewMat = uViewMat * uModelMat;
    
    vWorldPosition = vec3(uModelMat * vec4(aPosition, 1.0));
    
    gl_Position = uProjectionMat * modelViewMat * vec4(aPosition, 1.0);
    
    mat3 normalMat = getNormalMat(modelViewMat);
    vec3 normal = normalize(normalMat * aNormal);
    
    highp vec3 ambientLight = vec3(0.6, 0.6, 0.6);
    highp vec3 directionalLightColor = vec3(0.5, 0.5, 0.75);
    highp vec3 directionalVector = vec3(-2.0, 2.0, 2.0);
    highp float directional = max(dot(normal, directionalVector), 0.0);
    vec3 lighting = ambientLight + (directionalLightColor * directional);
    
    vDiffuseUV = aUV;
    vNormal = normal;
}