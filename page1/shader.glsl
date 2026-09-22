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
    vec3 a = vec3(0.845, 0.724, 0.454);
    vec3 b = vec3(0.829, 0.480, 0.160);
    vec3 c = vec3(1.570, 1.039, 1.475);
    vec3 d = vec3(3.688, 1.198, 3.020);
    return vec3(a + b*cos(6.28318*(c*t+d)));
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution) / u_resolution.y;
    vec2 uv0 = uv;
    vec3 finalColor = vec3(0.0);

    for (float i = 0.0; i < 5.0; i++) {
        uv = fract(uv*1.5)-0.5;

        float d = length(uv) * exp(-length(uv0));

        vec3 col = palette(length(uv0)+i*.4+u_time*.4);

        d = sin(d*8.+u_time)/8.;
        d = abs(d);
        d = pow(0.01 / d, 1.2);
        d = smoothstep(0.5, 1.0, d);
        finalColor += col * d;
    }

    gl_FragColor = vec4(finalColor, 1.0);
}
`;
