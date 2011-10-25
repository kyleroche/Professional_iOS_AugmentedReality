precision mediump float;                        
varying highp float lightIntensity;
uniform vec3 a_color;

void main() { 
    gl_FragColor =  vec4(lightIntensity*a_color, 1.0);
}