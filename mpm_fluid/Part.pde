
public class Part
{
  public float x;
  public float y;
  public float vx;
  public float vy;
  public float mass;
  public float radius = 4;
  public float surface_tension = 1;
  
  public Part(float x, float y)
  {
    this.x = x;
    this.y = y;
  }
  
  public Part(float x, float y, float vx, float vy)
  {
    this(x,y);
    this.vx = vx;
    this.vy = vy;
  }
  
  public Part useMass(float mass)
  {
    this.mass = mass;
    return this;
  }
  
  public void move()
  {
    x += vx;
    y += vy;
  }
  
  public void draw()
  {
    //colorMode(HSB);
    //color rgb = color((atan2(vy,vx)/PI+1)*255,255,255);
    //colorMode(RGB);
    color rgb = color(surface_tension>0?255:color(127,127,255));
    if(abs(vx)>=1||abs(vy)>=1) {
      stroke(rgb);
      line(x,y,x+vx,y+vy);
    } else {
      noStroke();
      fill(rgb);
      rect(x,y,1,1);
    }
  }
  
  public void interact(Part part)
  {
    float dx = x - part.x;
    float dy = y - part.y;
    float rad = part.radius+radius;
    if(abs(dx)<rad && abs(dy)<rad) {
      if(!(dx==0 && dy==0)) {
        float dot = dx*dx+dy*dy;
        if(rad*rad>dot) {
          float force = (1-rad/sqrt(dot)) * .05;
          dx *= force;
          dy *= force;
          vx -= dx;
          vy -= dy;
          part.vx += dx;
          part.vy += dy;
        }
      }
    }
  }
  
}