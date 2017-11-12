
public class Sound
{
  private String path = "";
  private SamplePlayer sp;
  private boolean valid;
  private Gain amp;
  private Glide gain;
  private Glide rate;
  
  public Sound(String path)
  {
    try {
      sp = new SamplePlayer(ac,new Sample(this.path=path));
      sp.setKillOnEnd(false);
      gain = new Glide(ac,1,10);
      rate = new Glide(ac,1,10);
      amp = new Gain(ac,1,gain);
      amp.addInput(sp);
      ac.out.addInput(amp);
      valid = true;
    } catch(Exception e) {}
  }
  
  public void play()
  {
    if(isValid()) {
      sp.start();
    }
  }
  
  public void stop()
  {
    rate(0);
  }
  
  public void rate(double rate)
  {
    if(isValid()) {
      this.rate.setValue((float)rate);
      sp.setRate(this.rate);
    }
  }
  
  public void amp(double amp)
  {
    if(isValid()) {
      this.amp.setGain((float)amp);
    }
  }
  
  public void jump(double pos)
  {
    if(isValid()) {
      this.sp.setPosition(pos);
    }
  }
  
  public boolean isValid()
  {
    return valid;
  }
  
  public double duration()
  {
    return sp.getSample().getLength();
  }
  
  public double durationSeconds()
  {
    return duration()/sp.getSampleRate();
  }
  
  public double position()
  {
    return sp.getPosition();
  }
  
  public void close()
  {
    if(amp!=null) {
      ac.out.removeAllConnections(amp);
    }
    //ac.stop();
  }
  
}