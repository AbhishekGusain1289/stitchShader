uniform sampler2D tDiffuse;
varying vec2 vUv;

void main(){
    vec3 defTexture = texture2D(tDiffuse, vUv).rgb;

    float luminance = (0.2126*defTexture.r + 0.7152*defTexture.g + 0.0722*defTexture.b);

    // luminance = smoothstep(1.0, 2.0, luminance);

    gl_FragColor = vec4(vec3(luminance), 1.0);
}