
public class FileExplorer
{
  private File currentFile;
  private String[] fileList;
  private String[] oldFileList;
  private int[] iconList;
  private EFloat oldOpacity;
  private EFloat extend;
  private EFloat scroll;
  private PImage[] icons;
  private EFloat widthOffset;
  private int currentSelection = -1;
  private int pastSelection = -1;
  private EFloat selectionScroll;
  
  public FileExplorer(File file)
  {
    this.currentFile = file;
    selectionScroll = new EFloat(0);
    fileList = new String[]{""};
    oldFileList = new String[]{""};
    extend = new EFloat(0,1).setEaseValue(.2);
    oldOpacity = new EFloat(255,0).setEaseValue(.2);
    scroll = new EFloat();
    updateFileList();
    ArrayList<PImage> pil = new ArrayList<PImage>();
    for(int i=0;;i++) {
      PImage img = loadImage("fileicon"+i+".png");
      if(img!=null) {
        pil.add(img);
      } else {
        break;
      }
    }
    icons = pil.toArray(new PImage[pil.size()]);
    widthOffset = new EFloat();
  }
  
  public FileExplorer(String path)
  {
    this(new File(path));
  }
  
  public FileExplorer()
  {
    this(sketchPath());
  }
  
  private void updateFileList()
  {
    if(currentFile.list()!=null) {
      oldFileList = new String[fileList.length];
      for(int i=0;i<fileList.length;i++) {
        oldFileList[i] = new String(fileList[i]);
      }
      fileList = currentFile.list();
      iconList = new int[fileList.length];
      for(int i=0;i<iconList.length;i++) {
        File file = currentFile.listFiles()[i];
        if(file.isDirectory()) {
          try {
            int len = file.list().length;
            iconList[i] = 2;
          } catch(Exception e) {
            iconList[i] = 3;
          }
        } else if(isMusicFileName(file.getName())) {
          iconList[i] = 1;
        } else {
          iconList[i] = 0;
        }
      }
      oldOpacity.a = 255;
      extend.a = 0;
      scroll.set(0,0);
    }
  }
  
  public void toParent()
  {
    if(currentFile.getParentFile()!=null) {
      currentFile = currentFile.getParentFile();
      updateFileList();
    }
  }
  
  public void selectFile(int index)
  {
    File file = currentFile.listFiles()[index];
    if(file.isDirectory() && iconList[index]!=3) {
      currentFile = file;
      updateFileList();
    } else {
      selectMusicFile(file);
    }
  }
  
  public void selectMusicFile(File file)
  {
    String name = file.getName();
    if(isMusicFileName(name) && file.length()<Runtime.getRuntime().freeMemory()-1024000) {
      addAudio(file.getPath());
    }
  }
  
  public boolean isMusicFileName(String name)
  {
    //String[] split = name.split("\\.");
    name = name.toLowerCase();
    String[] extensions = new String[]{"wav","mp3","ogg","mp4"};
    for(String extension : extensions) {
      if(name.endsWith(extension)) {
        return true;
      }
    }
    return false;
  }
  
  public boolean isMouseOver(float x, float y, float w, float h)
  {
    x = mouseX-x; if(x<0||x>w) return false;
    y = mouseY-y; if(y<0||y>h) return false;
    return true;
  }
  
  public float getWidthOffset()
  {
    return (float)widthOffset.get();
  }
  
  public void draw()
  {
    stroke(255);
    float x = width-getWidthOffset();
    float y = AudioTab.yBorder;
    float w = getWidthOffset()-AudioTab.xBorder;
    float h = height-AudioTab.yBorder*2;
    
    float othery = (float)(y-scroll.get());
    float bottomoftheline = (float)Math.max(y+h,y+currentFile.list().length*14+4-scroll.get());
    line(x,othery,x,bottomoftheline);
    line(x,othery,width,othery);
    line(x,bottomoftheline,width,bottomoftheline);
    
    
    float wo = getWidthOffset();
    widthOffset.set(wo,width-mouseX<wo+min(1,(wo-50)/(width/3.-50))*50?width/3.:50);
    float getopacity = (float)oldOpacity.get();
    if(getopacity>1) {
      for(int i=0;i<oldFileList.length;i++) {
        float cy = (float)(y+(i*(1-extend.get())+1)*14-2-scroll.get());
        fill(getopacity);
        text(oldFileList[i],x+16,cy);
      }
    }
    for(int i=0;i<fileList.length;i++) {
      float cy = (float)(y+(i*extend.get()+1)*14-2-scroll.get());
      float opacity = (255-getopacity)*(iconList[i]==0?.5:1);
      if(iconList[i]==3) {
        opacity *= .5;
      }
      if(cy>-14 && cy<height+14) {
        float selectoffset = x;
        String fileName = fileList[i];
        if(i==currentSelection || i==pastSelection) {
          //float offset = mouseX>x?min(0,height-getWidthOffset()+30-textWidth(fileName)):0;
          float offset = 0;
          if(i==currentSelection) {
            selectoffset += selectionScroll.get()*offset;
            fill(0,(float)selectionScroll.get()*255);
            stroke(255,(float)selectionScroll.get()*255);
          } else {
            selectoffset += (1-selectionScroll.get())*offset;
            fill(0,(float)(1-selectionScroll.get())*255);
            stroke(255,(float)(1-selectionScroll.get())*255);
          }
          rect(selectoffset+1,cy-12,width,14);
        }
        fill(255,opacity);
        tint(255,opacity);
        text(fileName,selectoffset+16,cy);
        image(iconList[i]<icons.length?icons[iconList[i]]:new PImage(),selectoffset+4,cy-8);
      }
    }
    noFill();
    
    
        
    if(isMouseOver(x,y,w,h)) {
      scroll.b += getScroll()*56;
      float cellHeight = (float)(extend.get()*14);
      int selecty = (int)((mouseY-y+scroll.get())/cellHeight);
      boolean selectionValid = selecty>=0 && selecty<fileList.length;
      if(selectionValid) {
        //rect(x+1,(float)(y+selecty*cellHeight+1-scroll.get()),width-x-2,cellHeight);
        fill(0,180);
        noStroke();
        rect(0,height-14,textWidth(currentFile.list()[selecty])+6,14);
        fill(255);
        stroke(255);
        text(currentFile.list()[selecty],4,height-4);
        if(currentSelection!=selecty) {
          pastSelection = currentSelection;
          currentSelection = selecty;
          selectionScroll.set(0,1);
        }
      }
      if(mouseClicking()) {
        if(mouseButton==LEFT && selectionValid) {
          selectFile(selecty);
        } else if(mouseButton==RIGHT) {
          toParent();
        }
      }
    }
    scroll.b = Math.max(0,Math.min(scroll.b,fileList.length*14-h));
    
    //rect(x,y,w,h);
  }
  
}