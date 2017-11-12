
public class Part
{
  private float x;
  private float y;
  private float vx;
  private float vy;
  
  public Part(float x, float y, float vx, float vy)
  {
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
  }
  
  public void move()
  {
    x += vx;
    y += vy;
  }
  
  public void draw()
  {
    rect(x-1,y-1,3,3);
  }
  
  public void interact(Part p)
  {
    float dx = x - p.x;
    float dy = y - p.y;
    if(!(dx==0 && dy==0)) {
      float force = 1./(dx*dx+dy*dy);
      dx *= force;
      dy *= force;
      vx -= dx;
      vy -= dy;
      p.vx += dx;
      p.vy += dy;
    }
  }
  
}