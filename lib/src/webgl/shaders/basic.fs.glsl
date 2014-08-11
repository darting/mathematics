precision highp float;

uniform vec3 uColor;

#ifdef TEXTURE
uniform sampler2D texture;
varying vec2 vUV;
#endif

void main(void) {

    #ifdef TEXTURE
        gl_FragColor = texture2D(texture, vUV) * vec4(uColor, 1.0);
    #else
        gl_FragColor = vec4(uColor, 1.0);
    #endif

}