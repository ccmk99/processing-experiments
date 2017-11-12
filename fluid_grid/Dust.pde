
public class Dust
{
  public float x;
  public float y;
  public color rgb;
  
  public Dust()
  {
    x = random(0,width);
    y = random(0,height);
    rgb = image.get((int)x,(int)y);
  }
  
  public void draw()
  {
    noStroke();
    fill(rgb);
    rect((int)x,(int)y,1,1);
  }
  
}