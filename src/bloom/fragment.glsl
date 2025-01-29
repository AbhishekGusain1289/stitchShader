uniform sampler2D tDiffuse;
uniform sampler2D tDefTex;
uniform float uBlurStrength;
uniform float uKernelSize;
varying vec2 vUv;

float gaussian(float x, float sigma) {
    return exp(-0.5 * (x * x) / (sigma * sigma)) / (2.0 * 3.14159265359 * sigma * sigma);
}


void main(){
    // float uKernelSize = 7.0;


    vec4 color = vec4(0.0); // Initialize the color accumulator
    float count = 0.0; // Initialize the sample count

    // Loop through the neighboring pixels within the blur radius
    for (float x = -uKernelSize; x <= uKernelSize; x++)
    {
        for (float y = -uKernelSize; y <= uKernelSize; y++)
        {
            float weight = gaussian(length(normalize(vec2(x,y))), 1.0);


            // Sample the texture at the neighboring pixel
            vec2 offset = normalize(vec2(x,y));
            // color += texture2D(tDiffuse, vUv + offset * uBlurStrength);
            color += texture2D(tDiffuse, vUv + offset * uBlurStrength * weight);
            count++;
        }
    }







    // vec4 tl= texture2D(tDiffuse, vec2(vUv.x - uBlurStrength,vUv.y - uBlurStrength));
    // vec4 tc= texture2D(tDiffuse, vec2(vUv.x - 0.0,vUv.y - uBlurStrength));
    // vec4 tr= texture2D(tDiffuse, vec2(vUv.x + uBlurStrength,vUv.y - uBlurStrength));
    // vec4 ml= texture2D(tDiffuse, vec2(vUv.x - uBlurStrength,vUv.y - 0.0));
    // vec4 mc= texture2D(tDiffuse, vec2(vUv.x - 0.0,vUv.y - 0.0));
    // vec4 mr= texture2D(tDiffuse, vec2(vUv.x + uBlurStrength,vUv.y - 0.00));
    // vec4 bl= texture2D(tDiffuse, vec2(vUv.x - uBlurStrength,vUv.y + uBlurStrength));
    // vec4 bc= texture2D(tDiffuse, vec2(vUv.x - 0.0,vUv.y + uBlurStrength));
    // vec4 br= texture2D(tDiffuse, vec2(vUv.x + uBlurStrength,vUv.y + uBlurStrength));

    // vec3 box = ((tl + tc + tr + ml + mc + mr + bl + bc + br) / 9.0).rgb;
    // vec3 gaussian = ((tl + 2.0 * tc + tr + 2.0 * ml + 4.0 * mc + 2.0 * mr + bl + 2.0 * bc + br) / 16.0).rgb;

    color /= count;


    vec3 defTexture = texture2D(tDefTex, vUv).rgb;

    // vec3 finalColor = defTexture - color.xyz;

    // float luminance = (0.2126*defTexture.r + 0.7152*defTexture.g + 0.0722*defTexture.b);
    // vec3 final = mix(defTexture, color.xyz, defTexture);
    // // vec3 final = clamp(finalColor, 0.0, 1.0);


    // gl_FragColor = vec4(final, 1.0);


    vec3 final = mix(color.xyz, defTexture, defTexture);
    gl_FragColor = vec4(color.xyz, 1.0);
    gl_FragColor = vec4(final, 1.0);
}