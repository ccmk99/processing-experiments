
public class NumberLine implements Draggable
{
  public static final float height = 10;
  private EFloat value;
  
  public NumberLine(float value)
  {
    this.value = new EFloat(value);
  }
  
  public NumberLine()
  {
    this(40);
  }
  
  public void drag(float value)
  {
    this.value.b += value;
  }
  
  public float get()
  {
    return (float)(this.value.get()/40.);
  }
  
  public boolean isMouseOver(float x, float y, float length)
  {
    x = mouseX-x; if(x<0||x>=length) return false;
    y = mouseY-y; if(y<-10||y>=height) return false;
    return true;
  }
  
  private float getOpacity(float x, float xoffset, float length)
  {
    return sin((float)(x+xoffset)/length*PI)*255;
  }
  
  public void draw(float xPos, float yPos, float length)
  {
    float value = (float)(this.value.get()+length/2);
    float xoffset = value%4;
    for(int x=0;x<length;x+=4) {
      stroke(255,getOpacity(x,xoffset,length));
      line(xPos+x+xoffset,yPos+height/2.,xPos+x+xoffset,yPos+height);
    }
    xoffset = value%20;
    for(int x=0;x<length;x+=20) {
      stroke(255,getOpacity(x,xoffset,length));
      line(xPos+x+xoffset,yPos,xPos+x+xoffset,yPos+height);
    }
    xoffset = value%40;
    for(int x=0;x<length;x+=40) {
      fill(255,getOpacity(x,xoffset,length));
      text((int)((-(x-value)/40)-((x-value)>0?1:0)+(value<0?1:0)),xPos+x+xoffset-3,yPos-2);
    }
    //println(value);
    stroke(255);
    line(xPos+length/2,yPos,xPos+length/2,yPos+height);
    noFill();
  }
  
}