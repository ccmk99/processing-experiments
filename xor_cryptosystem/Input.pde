
class Input
{
  StringBuilder line;
  int index;
  
  Input()
  {
    line = new StringBuilder();
  }
  
  void enterAction()
  {
    // replace later
    // didn't use abstract because idk whatever
  }
  
  void clear()
  {
    line.setLength(0);
    index = 0;
  }
  
  void sendKey(char key, int keyCode)
  {
    switch(keyCode) {
      case DELETE:
        if(index<line.length()) {
          line.deleteCharAt(index);
        }
      break;
      case BACKSPACE:
        if(index>0) {
          line.deleteCharAt(--index);
        }
      break;
      case SHIFT:
        // ignore 
      break;
      case ENTER:
        enterAction();
      break;
      case UP: case KeyEvent.VK_HOME:
        index = 0;
      break;
      case DOWN: case KeyEvent.VK_END:
        index = line.length();
      break;
      case LEFT:
        index = max(index-1,0);
      break;
      case RIGHT:
        index = min(index+1,line.length());
      break;
      default:
        if(key!=CODED) {
          line.insert(index++,key);
        }
      break;
    }
  }
  
  String toString()
  {
    return line.toString();
  }
  
}