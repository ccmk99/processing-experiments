// do you believe in gravity?

public final int IPF = 3;

public PartSystem ps;
public Part pick;

public void handleInput(float mouseX, float mouseY)
{
  if(mousePressed) {
    if(mouseButton==LEFT) {
      if(pick!=null) {
        pick.x = mouseX;
        pick.y = mouseY;
        pick.vx = (mouseX - pmouseX)/IPF;
        pick.vy = (mouseY - pmouseY)/IPF;
      }
    } else {
      for(Part part : ps) {
        float dx = mouseX - part.x;
        float dy = mouseY - part.y;
        float force = 1./sqrt(dx*dx+dy*dy)/IPF;
        part.vx += dx * force;
        part.vy += dy * force;
      }
    }
  } else {
    pick = ps.getPartClosestToXY(mouseX,mouseY);
  }
  if(pick!=null && mouseButton==LEFT) {
    stroke(255);
    line(mouseX,mouseY,pick.x,pick.y);
  }
}

public void setup()
{
  size(640,480);
  noSmooth();
  loadPixels();
  surface.setTitle("");
  surface.setResizable(true);
  surface.setIcon(createImage(1,1,ARGB));
  ps = new PartSystem();
}

public void keyPressed()
{
  switch(key) {
    case 'n':
      ps.add(new Part(mouseX,mouseY,(mouseX-pmouseX),(mouseY-pmouseY)));
    break;
    case 'r':
      ps.remove(pick);
    break;
    case 'c':
      ps.clear();
    break;
  }
}

public void draw()
{
  if(ps.size()>0) {
    try {
      noStroke();
      colorMode(HSB);
      loadPixels();
      for(int x=0;x<width ;x++)
      for(int y=0;y<height;y++)
      {
        float fx = 0;
        float fy = 0;
        for(Part part : ps) {
          float dx = part.x - x;
          float dy = part.y - y;
          float force = 1./(dx*dx+dy*dy);
          fx += dx * force;
          fy += dy * force;
        }
        pixels[x+y*width] = color((atan2(fx,fy)/PI+1)*128,255,255/((fx*fx+fy*fy)*1000+1));
      }
      updatePixels();
    } catch(Exception e) {}
  } else {
    background(0);
  }
  float ix = pmouseX;
  float iy = pmouseY;
  float dx = (mouseX-ix)/IPF;
  float dy = (mouseY-iy)/IPF;
  for(int i=0;i<IPF;i++) {
    ps.handle();
    handleInput(ix+dx,iy+dy);
  }
}