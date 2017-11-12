
public class NumberInput
{
  private StringBuilder str;
  private float x;
  private float y;
  private float w;
  private float h;
  
  public NumberInput(float x, float y, float w, float h)
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    str = new StringBuilder();
    NumberInputManager.add(this);
  }
  
  public void sendKey(char key)
  {
    if(key=='.'||key=='-'||(key>='0'&&key<='9')) {
      str.append(key);
    }
  }
  
  public void backspace()
  {
    if(str.length()>0) {
      str.deleteCharAt(str.length()-1);
    }
  }
  
  public void clear()
  {
    str.setLength(0);
  }
  
  public boolean mouseIsOver()
  {
    return (mouseX>x&&mouseY>y&&mouseX<x+w&&mouseY<y+h);
  }
  
  public void draw(color rgb)
  {
    stroke(rgb);
    noFill();
    rect(x,y,w,h);
    textAlign(LEFT,CENTER);
    fill(rgb);
    text(str.toString(),x+3,y+h/2);
    if(NumberInputManager.getSelectedNumberInput()==this && (frameCount/10)%2==0) {
      noStroke();
      rect(x+3+textWidth(str.toString()),y+3,2,h-5);
    }
  }
  
  public float get() throws Exception
  {
    return str.length()>0?Float.parseFloat(str.toString()):0;
  }
  
}