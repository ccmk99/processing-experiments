
public class SetDragger implements Draggable
{
  private float value;
  
  public float get()
  {
    return value;
  }
  
  public void drag(float value)
  {
    this.value = value;
  }
  
}