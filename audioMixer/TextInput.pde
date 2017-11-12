/*
public class TextInput
{
  private StringBuilder str;
  
  public TextInput()
  {
    str = new StringBuilder();
  }
  
  public void sendKey(char key, int keyCode)
  {
    switch(keyCode) {
      case 8:
        if(str.length()>0) {
          str.setLength(str.length()-1);
        }
      break;
      case 10:
        addAudio(toString());
      break;
      default:
        if(key!=CODED) {
          str.append(key);
        }
      break;
    }
  }
  
  public String toString()
  {
    return str.toString();
  }
  
}
*/