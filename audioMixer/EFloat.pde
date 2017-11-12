
public class EFloat
{
  public double a;
  public double b;
  public double easeValue = 0.2;
  public double threshold = 0;
  
  public EFloat(double a, double b)
  {
    set(a,b);
    Register.add(this);
  }
  
  public EFloat(double a)
  {
    this(a,a);
  }
  
  public EFloat()
  {
    this(0);
  }
  
  public EFloat setEaseValue(double easeValue)
  {
    this.easeValue = easeValue;
    return this;
  }
  
  public EFloat setThreshold(double threshold)
  {
    this.threshold = threshold;
    return this;
  }
  
  public double get()
  {
    return a;
  }
  
  public void set(double a, double b)
  {
    this.a = a;
    this.b = b;
  }
  
  public void set(double a)
  {
    set(a,a);
  }
  
  public void run()
  {
    a=(Math.abs(a-(a+=(b-a)*easeValue))>threshold)?a:b;
  }
  
}