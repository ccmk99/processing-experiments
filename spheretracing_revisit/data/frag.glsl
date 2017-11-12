uniform vec3 x_line; // x direction
uniform vec3 y_line; // y direction
uniform vec3 z_line; // z direction
uniform vec3 pos; // position
uniform vec2 res; // resolution
uniform float time; // frames elapsed

float magnitude(vec3 v)
{
	return sqrt(dot(v,v));
}

vec3 unit(vec3 v)
{
	return v/magnitude(v);
}

void main()
{
	gl_FragColor = vec4(vec3(0.0,0.0,0.0),1.0);
	
	vec2 offsetScale = (gl_FragCoord.xy/res)*2.0-vec2(1.0);
	vec3 offset = x_line*offsetScale.x + y_line*offsetScale.y;
	
	vec3 rayDir = unit(z_line+offset);
	vec3 rayPos = pos + offset * 10.0;
	
	float distance = 0;
	int i = 0;
	
	for(;i<50;i++) {
		
		float radius = (sin((magnitude(vec3(rayPos.x,0,rayPos.z))+time)/100.0)*0.5+0.5) * 100.0;
		distance = magnitude(vec3(
			mod(rayPos.x+radius,radius*2.0)-radius,
			mod(rayPos.y+200.0,400.0)-200.0,
			mod(rayPos.z+radius,radius*2.0)-radius
		))-radius;
		
		if(distance<0.01) {
			gl_FragColor = vec4(vec3(float(i)/100.0),1.0);
			break;
		}
		rayPos += rayDir * distance;
	}
	
	if(i==50 && distance<10) {
		gl_FragColor = vec4(vec3(gl_FragCoord.xy/res,sin(time/100.0)*.5+.5),1.0);
	}
}
