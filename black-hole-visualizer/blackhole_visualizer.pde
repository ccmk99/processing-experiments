
Camera camera;
PShader shader;
ArrayList<float[]> balls;

float gravity;
float time;

boolean[] input = new boolean[256];

void setup()
{
  size(480,480,P3D);
  balls = new ArrayList<float[]>();
  camera = new Camera(0,0,-100);
  camera.velocity.e[2] -= 1;
  shader = loadShader("frag.glsl","vert.glsl");
  shader.set("FLOAT_MIN_VALUE",Float.MIN_VALUE);
  
  PImage sky = loadImage("sky.png");
  shader.set("skytex",sky);
  
  balls.add(new float[]{0,0,100});
  balls.add(new float[]{0,0,200});
}

void keyPressed() { input[keyCode]=true; }
void keyReleased() { input[keyCode]=false; }

void draw()
{
  background(0);
  float ball_radius = 20;
  
  shader.set("time",(float)time);
  
  /*
  float[] ball_data = new float[balls.size()*3];
  for(int i=0;i<balls.size();i++) {
    ball_data[i*3+0] = balls.get(i)[0];
    ball_data[i*3+1] = balls.get(i)[1];
    ball_data[i*3+2] = balls.get(i)[2];
  }
  shader.set("ball_data",ball_data);
  */
  shader.set("ball_radius",ball_radius);
  //shader.set("balls",balls.size());
  
  //println(ball_data[0],ball_data[1],ball_data[2]);
  //println(balls.size());
  
  shader.set("cam_pos",
    camera.position.e[0],
    camera.position.e[1],
    camera.position.e[2]
  );
  shader.set("frame_x",
    camera.frame.e[0].e[0],
    camera.frame.e[0].e[1],
    camera.frame.e[0].e[2]
  );
  shader.set("frame_y",
    camera.frame.e[1].e[0],
    camera.frame.e[1].e[1],
    camera.frame.e[1].e[2]
  );
  shader.set("frame_z",
    camera.frame.e[2].e[0],
    camera.frame.e[2].e[1],
    camera.frame.e[2].e[2]
  );
  
  shader.set("res",(float)width,(float)height);
  
  shader.set("gravity",gravity);
  
  shader(shader);
  rect(0,0,width,height);
  /*
  loadPixels();
  for(int x=0;x<width ;x++)
  for(int y=0;y<height;y++)
  {
    color pixel = color(0);
    float scale_x = ((float)x/width)-.5;
    float scale_y = ((float)y/height)-.5;
    vec3 offset = new vec3()
      .raw_add(camera.frame.e[0].mul(scale_x))
      .raw_add(camera.frame.e[1].mul(scale_y));
    vec3 ray_pos = camera.position.add(offset);
    vec3 dir = camera.frame.e[2].add(offset).unit(); 
    for(int i=0;i<100;i++) {
      ray_pos.raw_add(dir);
      
      vec3 d = ball_pos.sub(ray_pos);
      ray_pos.raw_add(d.unit().div(vec3.dot(d,d)));
      
      if(ray_pos.sub(ball_pos).magnitude()<ball_radius) {
        pixel = color(255);
        break;
      }
    }
    pixels[x+y*width] = pixel;
  }
  updatePixels();
  */
  if(mousePressed && mouseButton==RIGHT) {
    camera.turnVertical((mouseY-pmouseY)*.01);
    camera.turnHorizontal((mouseX-pmouseX)*.01);
    
  }
  camera.update();
  
  float speed = 1;
  if(input['w'-32]) {
    camera.walk(speed);
  }
  if(input['s'-32]) {
    camera.walk(-speed);
  }
  if(input['d'-32]) {
    camera.strafe(speed);
  }
  if(input['a'-32]) {
    camera.strafe(-speed);
  }
  if(input[32]) {
    camera.velocity.raw_add(0,-speed,0);
  }
  if(input[16]) {
    camera.velocity.raw_add(0,speed,0);
  }
  surface.setTitle("FPS: "+frameRate);
  if(mousePressed && mouseButton==LEFT) {
    gravity = (float)mouseX/width;
  }
  
  // camera gets sucked in too
  //camera.velocity.raw_sub(camera.position.div(vec3.dot(camera.position,camera.position)).mul(gravity*100));
  
  /*
  float ball_x = 100.0*cos(time/10.0);
  float ball_z = 100.0+100.0*sin(time/10.0);
  time += 1+gravity*1000.0*(1/vec3.dot(camera.position,camera.position)-1/(ball_z*ball_z+ball_x*ball_x));
  */
  if(time==Float.POSITIVE_INFINITY) {
    time = 0;
  }
  time += 1+gravity*1e5*(1/vec3.dot(camera.position,camera.position));
  //time += 1;
  
  println(time);
}
