
public static class Register
{
  private static ArrayList<EFloat> efList = new ArrayList<EFloat>();
  
  public static void add(EFloat ef)
  {
    if(!efList.contains(ef)) {
      efList.add(ef);
    }
  }
  
  public static void handle()
  {
    for(EFloat ef : efList) {
      ef.run();
    }
  }
  
}