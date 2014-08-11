precision highp float;
attribute vec3 aPosition;

#ifdef TEXTURE
attribute vec2 aUV;
varying vec2 vUV;
#endif

uniform mat4 uModelMat;
uniform mat4 uViewMat;
uniform mat4 uProjectionMat;

void main(void) {
    gl_Position = uProjectionMat * uViewMat * uModelMat * vec4(aPosition, 1.0);

    #ifdef TEXTURE
    vUV = aUV;
    #endif
}