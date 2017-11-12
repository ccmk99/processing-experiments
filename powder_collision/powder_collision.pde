
PartSystem ps;

void setup()
{
  size(480,640,P3D);
  noSmooth();
  ps = new PartSystem(8);
}

void keyPressed()
{
  switch(key) {
    case 'c':
      ps.clear();
    break;
  }
}

void draw()
{
  surface.setTitle("FPS: "+frameRate+" Parts: "+ps.size());
  background(0);
  ps.handle();
  if(mousePressed) {
    float vx = mouseX-pmouseX;
    float vy = mouseY-pmouseY;
    for(int i=0;i<20;i++) {
      float range = sqrt(random(0,1))*20;
      float angle = random(0,TWO_PI);
      ps.add(new Part(
        mouseX+sin(angle)*range,
        mouseY+cos(angle)*range,
        vx,vy
      ));
    }
  }
}