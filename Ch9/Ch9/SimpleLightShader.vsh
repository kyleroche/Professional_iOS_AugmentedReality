attribute vec4 a_position; 
attribute vec4 a_normal;

varying float lightIntensity;

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

void main() {                          
    vec4 newNormal =  modelViewMatrix *projectionMatrix*a_normal;
	vec4 newPosition = modelViewMatrix * a_position;
    
    vec4 dir = vec4(0.0,0.0,1.0,0.0);
    
    gl_Position = projectionMatrix*newPosition;
    
	lightIntensity =1.0* max(0.0, dot(normalize(newNormal.xyz),normalize(newPosition.xyz)));   
} 