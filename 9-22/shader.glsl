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
    vec3 b = vec3(-0.562, 0.500, 0.500);
    vec3 c = vec3(0.948, 1.000, 1.000);
    vec3 d = vec3(0.000, 0.333, 0.667);
    return vec3(a + b*cos(6.28318*(c*t+d)));
}

void main() {
    vec2 uv = (gl_FragCoord.xy * 2.0 - u_resolution) / u_resolution.y; // fix aspect ratio
    vec3 finalColor = vec3(0.0);
    vec2 uv0 = uv;
    vec2 uv2 = uv;
    vec3 finalColor2 = vec3(0.0);
    float time = u_time - (1.0/8.0);      // time in beats and radians
    float timer = time * 3.141592;


    for (float i = 0.0; i < 8.0; i++) {
        uv2 = fract(uv*1.333 * i)-0.5;

        float d = length(uv2) * exp(-length(uv0)*.3);

        vec3 col = vec3(1., 1., 1.);

        d = sin(d*8.+timer/4.)/8.;
        d = abs(d);
        d = 0.005/d;
        finalColor2 += col * d;
    }
        // background color pattern that pulses and zooms
                             //scale        in/outspeed      zoom in speed
    for (float i = 1.; i < 3.; i++) {
        uv.x = fract((uv.x + 1.6) * i) / i - 0.4;
        uv.y = fract((uv.y - 0.5) * i) / i - 0.25;
        vec3 color = palette(1.*length(uv)-cos(timer)/2.-u_time/8.);

        float dr = length(.4*uv) - sin(time+6.*atan(uv.y/uv.x));
        dr *= 10.;
        dr = pow((1./dr),1.);
        dr = fract(1.*dr*i);

        float dg = length(.35*uv) + sin(2.*time+2.*atan(uv.y/uv.x));
        dg = pow(0.05/(dg),1.);
        dg = fract(1.*dr*i);

        float db = length(.4*uv) - sin(1.5*time+16.*atan(uv.y/uv.x));
        //db = pow(.01/(db),1.);
        db = fract(1.*db*i);



        finalColor += color * vec3(dr, dg, db);
    }
    gl_FragColor = vec4(finalColor * finalColor2, 1.0);
}
`;
