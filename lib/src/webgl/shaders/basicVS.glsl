precision highp float;
attribute vec3 aPosition;

uniform mat4 uModelMat;
uniform mat4 uViewMat;
uniform mat4 uProjectionMat;

void main(void) {
    gl_Position = uProjectionMat * uViewMat * uModelMat * vec4(aPosition, 1.0);
}