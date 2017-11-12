
public class PartSystem extends ArrayList<Part>
{
  
  public void moveParts()
  {
    for(Part part : this) {
      part.move();
    }
  }
  
  public void drawParts()
  {
    for(Part part : this) {
      part.draw();
    }
  }
  
  public void applyInteractions()
  {
    for(int i=0;i<size();i++)
    for(int j=i+1;j<size();j++)
    {
      get(i).interact(get(j));
    }
  }
  
  public void handle()
  {
    applyInteractions();
    moveParts();
    //drawParts();
  }
  
  public Part getPartClosestToXY(float x, float y)
  {
    float dst = Float.MAX_VALUE;
    Part get = null;
    for(Part part : this) {
      float dx = x - part.x;
      float dy = y - part.y;
      float tmp = dx*dx+dy*dy;
      if(tmp<dst) {
        dst = tmp;
        get = part;
      }
    }
    return get;
  }
  
}