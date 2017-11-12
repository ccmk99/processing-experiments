
public boolean pmousePressed;
public PShader mandel;
public NumberInput re;
public NumberInput im;
public boolean draggingInput;
public float mre;
public float mim;

public boolean mouseClicking()
{
  return mousePressed && !pmousePressed;
}

public void setup()
{
  size(840,840,P2D);
  background(0);
  surface.setTitle("Custom Exponent Mandelbrot");
  surface.setResizable(true);
  //surface.setIcon(createImage(1,1,ARGB));
  noSmooth();
  textFont(createFont("courier new bold",12));
  re = new NumberInput(33,24,150,15);
  im = new NumberInput(33,44,150,15);
  re.sendKey('2');
  im.sendKey('0');
  mandel = loadShader("frag.glsl","vert.glsl");
  PImage palette = createImage(7,1,RGB);
  float luma = 255;
  palette.pixels[0] = color(luma,0,0);
  palette.pixels[1] = color(luma,luma,0);
  palette.pixels[2] = color(0,luma,0);
  palette.pixels[3] = color(0,luma,luma);
  palette.pixels[4] = color(0,0,luma);
  palette.pixels[5] = color(luma,0,luma);
  palette.pixels[6] = color(luma,0,0);
  mandel.set("palette",palette);
}

public void keyPressed()
{
  NumberInput selected = NumberInputManager.getSelectedNumberInput();
  if(selected!=null) {
    if(keyCode!=BACKSPACE) {
      selected.sendKey(key);
    } else {
      selected.backspace();
    }
  }
}

public void mouseReleased()
{
  draggingInput = false;
}

public void draw()
{
  background(0);
  NumberInput selected = NumberInputManager.getSelectedNumberInput();
  try {
    mandel.set("re",re.get());
    mandel.set("im",im.get());
    mandel.set("res",(float)width,(float)height);
    mandel.set("juliaC",mre,mim);
    shader(mandel);
    rect(0,0,width,height);
    resetShader();
    if(mousePressed && selected==null) {
      fill(0,128);
      noStroke();
      rect(0,0,width,height);
    }
  } catch(Exception e) {
    stroke(255,0,0);
    line(width/2-50,height/2-50,width/2+50,height/2+50);
    line(width/2-50,height/2+50,width/2+50,height/2-50);
  }
  color rgb = color(255,selected==null?128:255);
  fill(rgb);
  textAlign(LEFT,TOP);
  text("Exponent:",8,8);
  text("Re:",8,re.y+2);
  text("Im:",8,im.y+2);
  NumberInputManager.handle(mouseClicking(),rgb);
  selected = NumberInputManager.getSelectedNumberInput();
  if(mouseClicking() && selected!=null) {
    draggingInput = true;
  }
  if(draggingInput) {
    try {
      float number = selected.get();
      selected.clear();
      String newNum = ((number+(mouseX-pmouseX)*.1)+"");
      if(newNum.lastIndexOf('-')<1) {
        for(char key : newNum.toCharArray()) {
          selected.sendKey(key);
        }
      }
    } catch(Exception e) {}
  }
  if(mousePressed && selected==null) {
    mre = (float)mouseX/width *4-2;
    mim = (float)mouseY/height*4-2;
    stroke(255);
    noFill();
    rect(mouseX-3,mouseY-3,6,6);
    fill(255);
    text("Re: "+mre+"\nIm "+mim,mouseX+12,mouseY+8);
  }
  pmousePressed = mousePressed;
}