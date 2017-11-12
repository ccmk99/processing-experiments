// cryptosystem that only knows how to use xor encryption/decryption
// doesn't check for nulls in a file, so having a file full of zero will
// make the encryption key visible
// this weakness is so that if i accidentally encrypt my entire system with this
// i won't instantly die

import java.math.BigInteger;
import java.util.Base64;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.ByteArrayOutputStream;
import javax.swing.JFileChooser;
import javax.swing.UIManager;
import java.awt.event.KeyEvent;

PGraphics canvas;
Console console;

void setup()
{
  size(840,480);
  background(0);
  noSmooth();
  imageMode(CENTER);
  rectMode(CENTER);
  
  surface.setTitle("SimpleCryptosystem 1.0.2");
  surface.setResizable(true);
  surface.setIcon(createImage(1,1,ARGB));
  
  console = new Console();
  canvas = createGraphics(720,360);
  canvas.beginDraw();
  canvas.textFont(createFont("courier new bold",12));
  canvas.textAlign(LEFT,TOP);
  canvas.endDraw();
  
  console.append("----- simple-cryptosystem 1.0.2 -----\n ");
  
  Cryptosystem.useConsole(console);
  
  final PApplet applet = this;
  
  try {
    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
  } catch(Exception e) {}
  
  final ArrayList<Object> stack = new ArrayList<Object>();
  
  stack.add(new Input(){public void sendKey(char key, int keyCode){
    super.sendKey(key,keyCode);
    if(key=='y') {
      clear();
      ((Runnable)stack.get(2)).run();
    } else if(key=='n') {
      exit();
    }
  }});
  
  stack.add(new Input(){public void enterAction(){
    String pass = toString();
    console.append(pass+"\n ");
    console.clearInput();
    console.setTakingInput(false);
    final byte[] key = SmallHash.digest(pass);
    console.append("hashed key: \t\n"+new String(Base64.getEncoder().encode(key))+"\n ");
    new Thread(){public void run(){
      final File target = FileIO.getUserChosenFile(applet,new File(sketchPath()));
      if(target!=null) {
        console.append("target: \t"+target.getAbsolutePath()+"\n");
        console.append(" \nworking...");
        Cryptosystem.process(target,key);
        console.append(" \ndone.");
        
        int n = Cryptosystem.files_encrypted;
        int m = Cryptosystem.files_processed;
        console.append("\n"+n+" file"+(n==1?" was":"s were")+" successfully processed.");
        console.append((m-n)+" file"+((m-n)==1?" was":"s were")+" skipped.");
      } else {
        console.append(" \nno target was selected");
      }
      console.append(" \nagain? (y/n) ");
      console.setTakingInput(true);
      console.useInput((Input)stack.get(0));
    }}.start();
  }});
  
  stack.add(new Runnable(){public void run(){
    Cryptosystem.resetStats();
    console.append("\nplaintext key: ");
    console.setTakingInput(true);
    console.useInput((Input)stack.get(1));
    console.clearInput();
  }});
  
  ((Runnable)stack.get(2)).run();
}

void keyPressed()
{
  console.sendKey(key,keyCode);
}

void mouseWheel(MouseEvent e)
{
  console.scroll(e.getCount());
}

void draw()
{
  background(0);
  canvas.beginDraw();
  canvas.background(0);
  PGraphics original = g;
  g = canvas;
  console.draw();
  g = original;
  canvas.endDraw();
  image(canvas.get(),width/2,height/2);
  stroke(48);
  noFill();
  rect(width/2,height/2,canvas.width,canvas.height);
}