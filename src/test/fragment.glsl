varying vec3 vPosition;
uniform vec2 uResolution;
uniform sampler2D tDiffuse;
uniform sampler2D tNormalTexture;
uniform sampler2D uStitchTexture;
uniform float uUvRepetitions;
uniform float uStichRepetitions;
varying vec2 vUv;


void main()
{
    vec2 uv = gl_FragCoord.xy / uResolution.y;
    float uUvRepetitions = 50.0;
    

    float aspectRatio = uResolution.x / uResolution.y;

    vec2 adjustedUv = vUv;
    adjustedUv.x *= aspectRatio; 
    
    vec2 brandNewUv = floor(adjustedUv * uUvRepetitions) / uUvRepetitions;
    vec2 patternUv = fract(adjustedUv * uUvRepetitions);

    brandNewUv.x /= aspectRatio;

    vec3 Color = texture2D(tDiffuse, brandNewUv).rgb;

    // gl_FragColor = vec4(finalColor, 1.0);
    // gl_FragColor = vec4(brandNewUv, 1.0, 1.0);




    // float ratioX = uResolution.x / uResolution.y;

    // float n = 60.0;

    // float squareSize = 1.0 / n;
    

    // // vec2 adjustedUv = vUv;
    // // if (ratioX > 1.0) {
    // //     // Wider than tall
    // //     adjustedUv.x *= ratioX;
    // // } else {
    // //     // Taller than wide
    // //     adjustedUv.y /= ratioX;
    // // }
    // // vec2 scaledUv = adjustedUv * n;
    // // vec2 gridUv = mod(scaledUv, 1.0);

    // // if (ratioX > 1.0) {
    // //     gridUv.x /= ratioX;
    // // } else {
    // //     gridUv.y *= ratioX;
    // // }

    // // vec2 brandNewUv = gridUv;


    // // vec2 brandNewUv = vUv * n;
    // // brandNewUv = floor(brandNewUv) / n;




    // vec2 brandNewUv = floor(uv * 20.0) / 20.0;

    // vec2 stitchUv = floor(vUv * n) / n;
    // vec3 defTex = texture2D(tDiffuse, brandNewUv).rgb;


    // // Implentation 2 ****************************************************************

    vec2 newUv = patternUv;

    float x = abs(newUv.x - 0.5);
    float y = newUv.y;
    float result1 = float(x<y);
    


    float upX = abs(newUv.x - 0.5);
    float upY = newUv.y - 0.5;

    float result2 = float(upX > upY);

    float result = result1 * result2;

    // result *= newUv.y < 0.05 ? 0.0 : result;
    // result *= newUv.y > 0.95 ? 0.0 : result;

    result *= newUv.x < 0.1 ? 0.0 : result;
    result *= newUv.x < 0.9 ? result : 0.0;

    result = step(0.5, result);


    vec3 finalColor = step(vec3(0.5), Color * result);
    gl_FragColor = vec4(result, result, result, 1.0);
    gl_FragColor = vec4(finalColor, 1.0);

    // // **********************************************************************************




    // // Implementation 1 *****************************************************************

    // // float strength = newUv.x;
    // // strength += newUv.y;
    // // strength = step(0.5, strength);

    // // float strength2 = -newUv.x;
    // // strength2 += newUv.y;
    // // strength2 = step(-0.5, strength2);

    // // float strength3 = newUv.x - 0.5;
    // // strength3 += newUv.y;
    // // strength3 = 1.0 - step(0.5, strength3);

    // // float strength4 = -newUv.x;
    // // strength4 += newUv.y;
    // // strength4 = 1.0 - step(0.0, strength4);


    // // float final1 = strength * strength2;
    // // float final2 = strength3 + strength4;

    // // float final = final2 * final1;

    // // *********************************************************************************

    // vec3 final = defTex * result;

    // gl_FragColor = vec4(defTex, 1.0);
    // gl_FragColor = vec4(vec2(brandNewUv),    1.0, 1.0);
}