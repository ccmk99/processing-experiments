
public static class NumberInputManager
{
  private static ArrayList<NumberInput> niList = new ArrayList<NumberInput>();
  private static NumberInput selected;
  
  public static void add(NumberInput ni)
  {
    if(!contains(ni)) {
      niList.add(ni);
    }
  }
  
  public static boolean contains(NumberInput ni)
  {
    return niList.contains(ni);
  }
  
  public static void handle(boolean mouseClicking, color rgb)
  {
    for(int i=0;i<niList.size();i++) {
      niList.get(i).draw(rgb);
    }
    if(mouseClicking) {
      selected = null;
      for(NumberInput ni : niList) {
      if(ni.mouseIsOver()) {
        selected = ni;
        break;
      }
      }
    }
  }
  
  public static NumberInput getSelectedNumberInput()
  {
    return selected;
  }
  
}