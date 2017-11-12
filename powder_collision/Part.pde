
class Part
{
  float x;
  float y;
  float px;
  float py;
  
  int id; // not a unique identifier; based on position
  
  Part(float x, float y, float vx, float vy)
  {
    this.x = x;
    this.y = y;
    px = x - vx;
    py = y - vy;
  }
  
  Part(float x, float y)
  {
    this(x,y,0,0);
  }
  
  void move()
  {
    x = min(max(x+(-px+(px=x)),0),width);
    y = min(max(y+(-py+(py=y))+1e-2,0),height);
  }
  
  void draw()
  {
    rect(x,y,3,3);
  }
  
  void updateId(float cell_length, int width)
  {
    id =
      ((int)(x/cell_length))+
      ((int)(y/cell_length))*width;
  }
  
  void interact(Part part) {
    float dx = part.x - x;
    float dy = part.y - y;
    if(!(dx==0 && dy==0)) {
      float rad = 4;
      float dot = dx*dx+dy*dy;
      if(dot<rad*rad) {
        
        float force = (1-(rad-.1)/sqrt(dot));
        force *= force>=0?.005:0.25;
        dx *= force;
        dy *= force;
        x += dx;
        y += dy;
        part.x -= dx;
        part.y -= dy;
        
        float viscosity = 0.01;
        
        if(viscosity!=0) {
          float vx = x-px;
          float vy = y-py;
          float pvx = part.x-part.px;
          float pvy = part.y-part.py;
          float dvx = (pvx-vx)*viscosity;
          float dvy = (pvy-vy)*viscosity;
          px = x - (vx+dvx);
          py = y - (vy+dvy);
          part.px = part.x - (pvx-dvx);
          part.py = part.y - (pvy-dvy);
        }
        
      }
    }
  }
  
}