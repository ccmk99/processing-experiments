import processing.net.*;
import beads.*;
import org.jaudiolibs.beads.*;
import java.awt.Point;
import java.awt.MouseInfo;

private boolean pmousePressed;

public boolean mouseClicking()
{
  return mousePressed && !pmousePressed;
}

public boolean mouseDragging()
{
  return mousePressed && pmousePressed;
}

public boolean mouseReleasing()
{
  return !mousePressed && pmousePressed;
}

private int scroll;

public int getScroll()
{
  return scroll;
}

private ArrayList<AudioTab> atList;

public void updateAtList()
{
  for(int i=0;i<atList.size();i++) {
    atList.get(i).updateIndex(i);
  }
}

public void addAudio(String name)
{
  atList.add(new AudioTab(name,atList.size()));
  updateAtList();
}

public void removeAudio(String name)
{
  for(int i=0;i<atList.size();i++) {
    if(atList.get(i).name.equals(name)) {
      atList.remove(i);
      updateAtList();
      break;
    }
  }
}

public void removeAudio(AudioTab at)
{
  atList.remove(at);
  at.close();
  updateAtList();
  //System.gc();
}
/*
public boolean mouseIsOverWindow()
{
  Point mPos = MouseInfo.getPointerInfo().getLocation();
  Point wPos = frame.getLocation();
  if(!frame.isUndecorated()) {
    wPos.x += frame.getInsets().left;
    wPos.y += frame.getInsets().top;
  }
  println(wPos);
  return (mPos.x>wPos.x&&mPos.x<mPos.x+width&&mPos.y>wPos.y&&mPos.y<mPos.y+height);
}
*/
//public TextInput ti;
public Draggable focus;

public FileExplorer fe;
public EFloat atScroll;
public PApplet main;
public int audioIsLoading = 3;
public AudioContext ac;
public Server s;
public PImage cursor;
public PImage cursorDown;
public boolean drawCursor;

public void setup()
{
  //surface.setLocation(displayWidth,displayHeight);
  //frame.setVisible(false);
  //noCursor();
  background(0);
  boolean mainClient = true;
  try {
    s = new Server(this,12345);
  } catch(Exception e) {
    Client c = new Client(this,"127.0.0.1",12345);
    if(args!=null) {
      for(String arg : args) {
        c.write("\n"+arg);
      }
    }
    exit();
    mainClient = false;
  }
  cursor = loadImage("cursor.png");
  cursorDown = loadImage("cursordown.png");
  //if(mainClient) {
  size(840,480);
  background(0);
  surface.setIcon(createImage(1,1,ARGB));
  surface.setTitle("Stereo Mixer");
  background(0);
  noSmooth();
  textFont(createFont("ＭＳ 明朝",12));
  PImage ico = loadImage("icon-16.png");
  if(ico==null) {
    PGraphics icon = createGraphics(255,255,JAVA2D);
    icon.beginDraw();
    icon.fill(0);
    icon.noStroke();
    icon.rect(10,0,icon.width-20,icon.height);
    icon.rect(0,10,icon.width,icon.height-20);
    icon.noFill();
    icon.stroke(255);
    icon.strokeWeight(10);
    icon.strokeJoin(MITER);
    icon.strokeCap(MITER);
    icon.beginShape();
    icon.vertex(40,40);
    icon.vertex(40,icon.height-40);
    icon.vertex(icon.width-40,icon.height/2);
    icon.vertex(40,40);
    icon.endShape();
    icon.beginShape();
    icon.vertex(icon.width-40,40);
    icon.vertex(icon.width-40,icon.height-40);
    icon.vertex(40,icon.height/2);
    icon.vertex(icon.width-40,40);
    icon.endShape();
    icon.endDraw();
    ico = icon.get();
    int[] numbers = new int[]{16,32,48,64,128,256,512,1024};
    for(int n : numbers) {
      icon = createGraphics(n,n,JAVA2D);
      icon.beginDraw();
      icon.image(ico,0,0,icon.width,icon.height);
      icon.endDraw();
      icon.save("data/icon-"+n+".png");
    }
  }
  surface.setIcon(ico);
  surface.setResizable(true);
  main = this;
  atList = new ArrayList<AudioTab>();
  atScroll = new EFloat();
  //ti = new TextInput();
  ac = new AudioContext();
  ac.start();
  
  //surface.setLocation(100,100);
  //frame.setVisible(true);
  
  if(args!=null) {
    String lastArg = args[args.length-1];
    fe = new FileExplorer(lastArg.substring(0,lastArg.lastIndexOf("\\")));
    for(String arg : args) {
      fe.selectMusicFile(new File(arg));
    }
  } else {
    try {
      fe = new FileExplorer("C:/Users/"+System.getProperty("user.name")+"/Music");
    } catch(Exception e) {
      fe = new FileExplorer("C:/");
    }
  }
  frame.pack();
  /*} else {
    surface.setLocation(displayWidth,displayHeight);
    surface.setVisible(false);
    exit();
  }*/
}

public void keyPressed()
{
  /*
  switch(key) {
    case ' ':
      addAudio("star.mp3");
    break;
  }
  */
  //ti.sendKey(key,keyCode);
}

public void mouseWheel(MouseEvent e)
{
  scroll = e.getCount();
}

public void draw()
{
  //try {
  background(0);
  stroke(255);
  noFill();
  //try {
    for(int i=atList.size()-1;i>=0;i--) {
      atList.get(i).draw();
    }
    /*
    for(AudioTab at : atList) {
      at.draw();
    }
    */
  //} catch(Exception e) {}
  if(!(mouseClicking()||mouseDragging())) {
    focus = null;
  } else if(focus!=null) {
    if(focus instanceof NumberLine) {
      focus.drag(mouseX-pmouseX);
    }
  }
  Register.handle();
  stroke(255);
  //line(0,height-20,width,height-20);
  //fill(255);
  //text(ti.toString(),4,height-6);
  //noFill();
  fe.draw();
  strokeWeight(5);
  for(int i=0;i<10;i++) {
    stroke(0,255*(1-i/10.));
    line(width-i*5,0,width-i*5,height);
  }
  strokeWeight(1);
  atScroll.b = Math.min(0,Math.max(
    -atList.size()*(AudioTab.tabHeight+AudioTab.yBorder)-
    AudioTab.yBorder+height,atScroll.b-((mouseX<width-
    fe.getWidthOffset())?getScroll()*40:0
  )));
  pmousePressed = mousePressed;
  scroll = 0;
  if(frameCount%100==0) {
    Client c = s.available();
    if(c!=null) {
      for(String str : c.readString().split("\n")) {
        fe.selectMusicFile(new File(str));
      }
    }
  }
  
  /*
  if(mouseIsOverWindow()) {
    tint(255);
    image(mousePressed?cursorDown:cursor,mouseX,mouseY);
  }
  */
  /*
  strokeCap(RECT);
  stroke(mousePressed?0:255);
  strokeWeight(3);
  line(mouseX-2,mouseY,mouseX+3,mouseY);
  line(mouseX,mouseY-2,mouseX,mouseY+3);
  
  stroke(mousePressed?255:0);
  strokeWeight(1);
  line(mouseX-1,mouseY,mouseX+1,mouseY);
  line(mouseX,mouseY-1,mouseX,mouseY+1);
  */
  //} catch(Exception e){}
}