
public class AudioTab implements Runnable
{
  public static final float yBorder = 10;
  public static final float xBorder = 10;
  public static final float tabHeight = 40;
  private String name;
  private int index;
  private Sound audio;
  private EFloat y;
  private boolean paused;
  private boolean invalid;
  private NumberLine pitch;
  private NumberLine volume;
  private double naturalPitch;
  private double position;
  private SetDragger posDrag;
  private boolean enabled;
  private boolean isLoading;
  private boolean loop;
  //private boolean waitingToLoad;
  
  public AudioTab(String name, int index)
  {
    this.name = name;
    this.index = index;
    this.y = new EFloat();
    updateIndex(index);
    paused = true;
    pitch = new NumberLine();
    volume = new NumberLine();
    posDrag = new SetDragger();
    new Thread(this).start();
  }
  
  public void run()
  {
    while(audioIsLoading<=0){try{Thread.sleep(100+index);}catch(Exception e){}};
    if(atList.contains(this)) {
      isLoading=true;
      audioIsLoading--;
      audio = new Sound(name);
      try {
        naturalPitch = 1;
        audio.rate(naturalPitch);
        audio.stop();
      } catch(Exception e) {
        invalid=true;
      }
      enabled = true;
      isLoading=false;
      audioIsLoading++;
    }
  }
  
  public void updateIndex(int index)
  {
    y.set(y.get(),yBorder+(tabHeight+yBorder)*index);
  }
  
  private boolean mouseOver(double x, double y, double w, double h)
  {
    x = mouseX - x; if(x<0||x>=w) return false;
    y = mouseY - y; if(y<0||y>=h) return false;
    return true;
  }
  
  public boolean mousePressing(double x, double y, double w, double h)
  {
    return (mouseOver(x,y,w,h) && mousePressed);
  }
  
  private boolean buttonPressed(float x, float y, float w, float h)
  {
    if(mouseOver(x,y,w,h)) {
      stroke(255);
      if(mousePressed) {
        rect(x+1,y+1,w-2,h-2);
        return mouseClicking();
      }
    } else {
      stroke(200);
    }
    rect(x,y,w,h);
    return false;
  }
  
  public void itsTimeToStop()
  {
    audio.stop();
    audio.jump(0);
    paused = true;
  }
  
  public boolean audioLoaded()
  {
    return audio!=null && audio.isValid();
  }
  
  public boolean audioIsDead()
  {
    return audio!=null && !audio.isValid();
  }
  
  public void draw()
  {
    float x = xBorder;
    float y = (float)(this.y.get()+atScroll.get());
    float w = width-xBorder*2-fe.getWidthOffset();
    float h = tabHeight;
    if(y>-h-1 && y<height+1) {
      stroke(255);
      rect(x,y,w,h);
      line(x+w-12,y+2,x+w-2,y+12);
      line(x+w-12,y+12,x+w-2,y+2);
      if(buttonPressed(x+w-12,y+2,10,10)) {
        if(audioLoaded()) {
          paused = true;
          audio.stop();
          audio.close();
        }
        removeAudio(this);
      }
      boolean onTimeSlider = false;
      if(!audioIsDead()) {
        stroke(255);
        if(enabled) {
          if(audioIsDead()) {
            line(x+15,y+15,x+25,y+h-15);
            line(x+15,y+h-15,x+25,y+15);
          } else {
            if(paused) {
              if(keyPressed && keyCode==SHIFT) {
                strokeCap(RECT);
                stroke(255);
                strokeWeight(5);
                arc(x+20,y+h/2,8,8,frameCount/8.-1,frameCount/8.+1);
                arc(x+20,y+h/2,8,8,frameCount/8.-1+PI,frameCount/8.+1+PI);
                stroke(0);
                strokeWeight(3);
                arc(x+20,y+h/2,8,8,frameCount/8.-.7,frameCount/8.+.7);
                arc(x+20,y+h/2,8,8,frameCount/8.-.7+PI,frameCount/8.+.7+PI);
                strokeWeight(1);
              } else {
                line(x+15,y+15,x+15,y+h-15);
                line(x+15,y+15,x+25,y+h-20);
                line(x+15,y+h-15,x+25,y+h-20);
              }
            } else {
              rect(x+14,y+15,4,h-30);
              rect(x+22,y+15,4,h-30);
            }
          }
        } else {
          if(isLoading) {
            arc(x+20,y+h/2,8,8,frameCount/8.-1,frameCount/8.+1);
            arc(x+20,y+h/2,8,8,frameCount/8.-1+PI,frameCount/8.+1+PI);
          } else {
            ellipse(x+15,y+h/2,2,2);
            ellipse(x+20,y+h/2,2,2);
            ellipse(x+25,y+h/2,2,2);
          }
        }
        if(buttonPressed(x+10,y+10,20,h-20) && enabled) {
          paused = !paused;
          if(paused) {
            audio.rate(0);
          } else {
            audio.play();
            loop = (keyPressed && keyCode==SHIFT);
            audio.rate(naturalPitch);
          }
        }
        stroke(255);
        if(enabled) {
          if(audioIsDead()) {
            line(x+45,y+15,x+55,y+h-15);
            line(x+45,y+h-15,x+55,y+15);
          } else {
            rect(x+44,y+15,12,h-30);
          }
        } else {
          if(isLoading) {
            arc(x+50,y+h/2,8,8,frameCount/8.-1,frameCount/8.+1);
            arc(x+50,y+h/2,8,8,frameCount/8.-1+PI,frameCount/8.+1+PI);
          } else {
            ellipse(x+45,y+h/2,2,2);
            ellipse(x+50,y+h/2,2,2);
            ellipse(x+55,y+h/2,2,2);
          }
        }
        if(buttonPressed(x+40,y+10,20,h-20) && audioLoaded()) {
          itsTimeToStop();
        }
        stroke(255);
        volume.draw(x+70,y+15,100);
        if(mouseClicking() && volume.isMouseOver(x+70,y+15,100)) {
          focus = volume;
        }
        fill(255);
        text("volume",x+105,y+36);
        noFill();
        pitch.draw(x+180,y+15,100);
        if(mouseClicking() && pitch.isMouseOver(x+180,y+15,100)) {
          focus = pitch;
        }
        fill(255);
        text("pitch",x+217,y+36);
        onTimeSlider = mouseY>=y+h-5 && mouseY<=y+h && mouseX<x+w && mouseX>x;
        if(onTimeSlider) {
          if(mouseClicking()) {
            focus = posDrag;
          }
          if(audioLoaded()) {
            float time = 43.416927899686520376175548589342*(float)((mouseX-x)/w*audio.durationSeconds());
            int min = (int)(time)/60;
            time-=min*60;
            fill(0,200);
            noStroke();
            String strTime = nf(min,2)+":"+nf((int)time,2);
            float strX = mouseX-((mouseX-x)/w)*textWidth(strTime);
            rect(strX-3,y+h-15,textWidth(strTime)+6,14);
            fill(255);
            text(strTime,strX,y+h-2);
          }
        }
        noFill();
        if(audioLoaded() && !paused) {
          audio.rate(paused?0:naturalPitch*pitch.get());
          audio.amp(volume.get());
        }
        if(focus==posDrag) {
          if(mouseDragging()) {
            if(audioLoaded()) {
              position=(double)(mouseX-x)/w*audio.duration();
            }
          } else if(mouseReleasing() && onTimeSlider && audioLoaded()) {
            audio.stop();
            audio.jump(position);
            audio.play();
          }
        }
        if(audioLoaded()) {
          if(audio.position()<0) {
            if(pitch.get()>0) {
              audio.jump(0);
            } else {
              if(!loop) {
                itsTimeToStop();
              }
              audio.jump(audio.duration());
            }
          } else if(audio.position()>audio.duration()) {
            if(pitch.get()>0) {
              if(!loop) {
                itsTimeToStop();
              }
              audio.jump(0);
            } else {
              audio.jump(audio.duration());
            }
          }
        }
        
        if(invalid && frameCount%100==0) {
          audio = new Sound(name);
          try {
            naturalPitch = 1;
            audio.rate(naturalPitch);
            invalid=false;
          } catch(Exception e) {}
        }
      }
      
      if(audioIsDead() && mouseOver(x,y,w,h)) {
        fill(127);
        text("sound file not compatible with current version. sorry :(",x+15,y+h/2+5);
        noFill();
      } else {
        String name = this.name.substring(this.name.lastIndexOf("\\")+1,this.name.length()-4);
        
        fill((invalid||!audioLoaded())?128:255);
        double cmp = textWidth(name)+350-(width-fe.getWidthOffset());
        int cullDistance = (int)(name.length()-cmp/textWidth(" "));
        text(cmp>0?cullDistance>0?name.substring(0,max(0,cullDistance))+"...":"":name,x+300,y+25);
        noFill();
      }
      
      if(audioLoaded() && !invalid) {
        float a = (float)Math.max(0,Math.min(mouseX-x,w));
        float b = (float)Math.max(0,Math.min(audio.position()/audio.duration(),1))*w;
        
        if(mousePressed && onTimeSlider && focus==posDrag) {
          /*
          stroke(255);
          line(x,y+h-1,x+(b<a?a:b),y+h-1);
          stroke(0);
          line(x,y+h-1,x+(b<a?b:a),y+h-1);
          */
          stroke(255);
          line(x,y+h-1,x+b,y+h-1);
          if(a>b+2) {
            line(x+b+3,y+h-1,x+a,y+h-1);
          }
        } else {
          stroke(255);
          line(x,y+h-1,x+b,y+h-1);
        }
        position += paused?0:pitch.get();
      }
    }
  }
  
  public void close()
  {
    audio.close();
  }
  
}