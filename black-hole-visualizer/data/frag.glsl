uniform vec2 res;

uniform sampler2D skytex;

uniform vec3 cam_pos;
uniform vec3 frame_x;
uniform vec3 frame_y;
uniform vec3 frame_z;

uniform float[] ball_data;
uniform float ball_radius;
uniform int balls;

uniform float gravity;
uniform float time;

uniform float FLOAT_MIN_VALUE;

vec2 flipY(vec2 v)
{
	return vec2(v.x,1.0-v.y);
}

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
	//gl_FragColor = vec4(vec3(0.0),1.0);
	
	vec2 scale = flipY(gl_FragCoord.xy/res)-vec2(0.5);
	
	vec3 offset = frame_x*scale.x+frame_y*scale.y;
	vec3 ray_pos = cam_pos + offset;
	vec3 dir = frame_z+offset;
	/*
	float soi = sqrt(gravity/FLOAT_MIN_VALUE); // sphere of influence
	vec3 closest_point = ray_pos+dir*(-dot(dir,ray_pos)/dot(dir,dir));
	if(gravity/dot(closest_point,closest_point)<FLOAT_MIN_VALUE) {
		
		ray_pos += dir * 1024;
		
	} else {
	*/
	
	bool world_one = true;
	
	for(int i=0;i<512;i++) {
		
		// gravity
		//vec3 d = ray_pos-vec3(0.0,0.0,100.0);
		vec3 d = ray_pos; // black hole is at 0,0,0
		float strength = gravity/dot(d,d);
		// if it's within the event horizon...
		if(strength>=1.0) {
			gl_FragColor = vec4(vec3(0.0),1.0);
			return;
			//world_one = !world_one;
			
			//vec3 norm = unit(d);
			//dir = dir-2*(dot(dir,norm))*norm;
		}
		
		vec3 force = d*strength;
		//vec3 force = vec3(1.0,0.0,0.0)*gravity/dot(d,d);
		dir -= force;//+vec3(force.z,0.0,-force.x)*10;
		
		dir = unit(dir);
		
		//bool under_disk = ray_pos.y<0.0;
		
		ray_pos += dir;
		
		/*
		if((ray_pos.y<0.0)!=under_disk) {
			float disk_distance = dot(ray_pos.xz,ray_pos.xz);
			float distance = strength*100.0;
			if(disk_distance<strength) {
				gl_FragColor = vec4(vec3(1.0,0.8,0.5)*distance/disk_distance,1.0);
				return;
			}
		}
		*/
		
		/*
		vec3 black_hole = vec3(ball_data[0],ball_data[1],ball_data[2]);
		if(magnitude(ray_pos-black_hole)<=10) {
			//vec3 norm = unit(ray_pos-black_hole)*0.5+vec3(0.5);
			gl_FragColor = vec4(vec3(0.0),1.0);
			return;
		}
		*/
		
		//vec3 ball_pos = vec3(ball_data[3],ball_data[4],ball_data[5]);
		//vec3 ball_pos = vec3(100.0*cos(time/10.0),0,100.0+100.0*sin(time/10.0));
		vec3 ball_pos = vec3(0.0,0.0,100.0);
		if(magnitude(ray_pos-ball_pos)<=ball_radius) {
			
			vec3 norm = unit(ray_pos-ball_pos)*0.5+vec3(0.5);
			gl_FragColor = vec4(norm,1.0);
			
			return;
			/*
			bool line_x = mod(ray_pos.x,5.0)<0.5;
			bool line_y = mod(ray_pos.y,5.0)<0.5;
			bool line_z = mod(ray_pos.z,5.0)<0.5;
			if(line_x||line_y||line_z) {
				vec3 norm = unit(ray_pos-ball_pos)*0.5+vec3(0.5);
				gl_FragColor = vec4(norm,1.0);
			} else {
				gl_FragColor = vec4(vec3(0.0),1.0);
			}
			return;
			*/
		}
		/*
		for(int j=0;j<balls*3;j+=3) {
			vec3 ball_pos = vec3(ball_data[j],ball_data[j+1],ball_data[j+2]);
			if(magnitude(ray_pos-ball_pos)<=ball_radius) {
				gl_FragColor = vec4(vec3(1.0),1.0);
				break;
			}
		}
		*/
		
		/*
		if(ray_pos.y>=50.0) {
			bool in_line = mod(atan(ray_pos.z/ray_pos.x)/3.14159265358,.1)<.01;
			bool in_circle = mod(1.0/sqrt(dot(ray_pos.xz,ray_pos.xz)),0.01)<0.001;
			gl_FragColor = vec4(vec3((in_line||in_circle)?1.0:0.0),1.0);
			return;
		}
		*/
		
	}
	
	//}
	
	//gl_FragColor = vec4(unit(ray_pos-cam_pos)*0.5+vec3(0.5),1.0);
	vec3 diff = ray_pos-cam_pos;
	
	/*
	if(world_one) {
		bool line_x = mod(diff.x+time/30.0,10.0)<2.0;
		bool line_y = mod(diff.y+time/30.0,10.0)<2.0;
		bool line_z = mod(diff.z+time/30.0,10.0)<2.0;
		
		
		//bool thick_line = (mod(diff.x,30.0)<2.0)||(mod(diff.y,30.0)<2.0)||(mod(diff.z,30.0)<2.0);
		//bool thin_line = (mod(diff.x,10.0)<1.0)||(mod(diff.y,10.0)<1.0)||(mod(diff.z,10.0)<1.0);
		//gl_FragColor = vec4((line_x&&line_y&&line_z)?vec3(1.0):((line_x||line_y||line_z)?vec3(0.1):vec3(0.0)),1.0);
		gl_FragColor = vec4((line_x&&line_y&&line_z)?vec3(1.0):vec3(0.1),1.0);
		//gl_FragColor = vec4(thick_line?vec3(1.0):thin_line?vec3(0.5):vec3(0.0),1.0);
	} else {
		gl_FragColor = vec4(vec3(
			sin((diff.x+time)/30.0),
			sin((diff.y+time)/30.0),
			sin((diff.z+time)/30.0)
		)+vec3(0.5),1.0);
	}
	*/
	float theta = atan(diff.z/diff.x)+3.14159265358;
	float phi = acos(diff.y/magnitude(diff));
	
	//bool line_t = mod(theta,0.5)<0.05;
	//bool line_p = mod(phi,0.5)<0.05;
	
	//gl_FragColor = vec4(vec3(line_p||line_t?1.0:0.0),1.0);
	gl_FragColor = vec4(texture2D(skytex,vec2(theta/2.0/3.14159265358,phi/3.14159265358)).rgb,1.0);
}