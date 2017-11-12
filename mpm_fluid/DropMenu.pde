
public class DropMenu
{
  public float x;
  public float y;
  public float w;
  public float h;
  
  public boolean dropped;
  public String[] options;
  public Runnable[] actions;
  public int current_option;
  public String description;
  
  public DropMenu(float x, float y, float w, float h, String description, String[] options, Runnable[] actions)
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.description = description;
    this.options = options;
    this.actions = actions;
  }
  
  public boolean mouseHovering(float x, float y, float w, float h)
  {
    return mouseX>x && mouseX<x+w && mouseY>y && mouseY<y+h;
  }
  
  public void draw()
  {
    stroke(255);
    noFill();
    rect(x,y,w,h);
    textAlign(LEFT,CENTER);
    fill(255);
    text(options[current_option],x+4,y+h/2-1);
    text(description,x+4,y-h/2);
  }
  
}