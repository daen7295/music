// Vertex shader source code
var vertexShaderSource = `
attribute vec4 a_position;
void main() {
    gl_Position = a_position;
}
`;

// Fragment shader source code
var fragmentShaderSource = `
precision highp float;
uniform float u_time;
uniform vec2 u_resolution;

vec3 palette(float t) {
    vec3 a = vec3(0.500, 0.500, 0.500);
    vec3 b = vec3(0.500, 0.500, 0.500);
    vec3 c = vec3(1.000, 1.000, 1.000);
    vec3 d = vec3(0.000, 0.333, 0.667);
    return vec3(a + b*cos(6.28318*(c*t+d)));
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution) / u_resolution.y;
    vec2 uv0 = uv;
    vec3 finalColor = vec3(0.0);

    for (float i = 0.0; i < 5.0; i++) {
        uv = fract((2.2*uv+1.0)*0.5)-0.5;

        float d = length(uv) * 10. + 0.1*length(uv0);
        d = sin(d-u_time*3.1415*.25+3.*length(uv0));
        d = abs(d)/2.;
        d = pow(0.05/(d),1.5);
        d -= 0.1*length(uv0);
        finalColor += palette(length(uv0)-sin(u_time*3.1415/8.)) * d;
    }
    gl_FragColor = vec4(finalColor, 1.0);
}
`;
