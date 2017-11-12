
class Console
{
  final static float text_width = 7;
  final static float text_height = 14;
  
  ArrayList<StringBuilder> data;
  Input keyinput;
  boolean taking_input;
  int scroll;
  
  Console()
  {
    data = new ArrayList<StringBuilder>();
    data.add(new StringBuilder());
    keyinput = new Input();
  }
  
  void draw()
  {
    fill(255);
    int line_limit = (int)(canvas.height/text_height);
    int top_line = max(data.size()-line_limit,0);
    scroll = max(min(scroll,top_line),0);
    for(int i=top_line-scroll;i<data.size()-scroll;i++) {
      String line = data.get(i).toString();
      if(i==data.size()-1) {
        line = line+getInput();
      }
      text(line,6,6+text_height*(i-top_line+scroll));
    }
    if(top_line>0) {
      float bar_length = canvas.height/(top_line/10.+1);
      noStroke();
      fill(255);
      rect(canvas.width-6,2+(canvas.height-bar_length-2)*(1-(float)scroll/top_line),5,bar_length);
    }
  }
  
  void scroll(int amount)
  {
    scroll += amount;
  }
  
  void clearInput()
  {
    keyinput.clear();
  }
  
  void useInput(Input input)
  {
    keyinput = input;
  }
  
  StringBuilder getLastLine()
  {
    return data.get(data.size()-1);
  }
  
  void append(String text)
  {
    for(String line : text.split("\n")) {
      getLastLine().append(line);
      data.add(new StringBuilder());
    }
  }
  
  void clear()
  {
    data.clear();
    data.add(new StringBuilder());
  }
  
  void sendKey(char key, int keyCode)
  {
    if(keyCode==DOWN) {
      scroll--;
    }
    if(keyCode==UP) {
      scroll++;
    }
    if(taking_input) {
      keyinput.sendKey(key,keyCode);
    }
  }
  
  void setTakingInput(boolean taking)
  {
    taking_input = taking;
  }
  
  String getInput()
  {
    return keyinput.toString();
  }
  
}