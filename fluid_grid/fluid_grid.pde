// drag mouse to move particles

public FluidGrid fg;
public PImage image;

public void setup()
{
  size(240,240);
  noSmooth();
  image = loadImage("mka.jpg");
  surface.setSize(image.width,image.height);
  fg = new FluidGrid(width,height);
  image(image,0,0);
}

public void draw()
{
  try {
  //background(0);
  //image(image,0,0);
  if(mousePressed) {
    if(mouseButton==LEFT) {
      fg.data[mouseX][mouseY][0] += (mouseX - pmouseX)*10;
      fg.data[mouseX][mouseY][1] += (mouseY - pmouseY)*10;
    } else {
      fg.data[mouseX][mouseY][3] += 1;
    }
    //fg.data[mouseX][mouseY][2] += 100;
  }
  fg.handle();
  } catch(Exception e) {}
}