uniform vec2 res;
uniform float re;
uniform float im;
uniform vec2 juliaC;
uniform sampler2D palette;

vec3 getColorFromIndex(float index)
{
	return texture(palette,vec2(mod(index/6.0,1.0),0)).rgb;
}

void main()
{
	gl_FragColor = vec4(vec3(0.0),1.0);
	vec2 z = gl_FragCoord.xy/res*4.0-vec2(2.0);
	vec2 c = juliaC;
	for(int i=0;i<100;i++) {
		vec2 sqr = z*z;
		float a = sqr.x+sqr.y;
		if(a>4.0) {
			gl_FragColor = vec4(getColorFromIndex(i+1.0-log(log(a))/log(2)),1.0);
			break;
		}
		float angle = atan(z.y/z.x);
		float multiplier = pow(a,re/2.0)*exp(-im*angle);
		float theta = re*angle+0.5*im*log(a);
		z.x = cos(theta);
		z.y = sin(theta);
		z = z*multiplier+c;
	}
}