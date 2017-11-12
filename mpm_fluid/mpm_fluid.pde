// left-click to add fluid
// scroll to change cursor size

public MPMFluid mpmf;
public int grav_mode = 8;
public float grav_power = 0.02;
public float limit = .9;

public ArrayList<DropMenu> menus;
public float cursor_radius = 20;

public void setup()
{
  size(640,640,P2D);
  noSmooth();
  mpmf = new MPMFluid(width,height,3);
  menus = new ArrayList<DropMenu>(); {
    float x = 4;
    float y = 20;
    float w = 200;
    float h = 24;
    
    menus.add(new DropMenu(x,y,w,h,"Gravity Mode",
      new String[]{
        "Down",
        "Up",
        "Right",
        "Left",
        "Bottom-Right Corner",
        "Bottom-Left Corner",
        "Top-Right Corner",
        "Top-Left Corner",
        "Center",
        "Edges",
      },
      new Runnable[]{
        
      }
    ));
    y += x+h*2;
    
    
  }
}

public void mouseWheel(MouseEvent e)
{
  cursor_radius = max(0,cursor_radius-e.getCount()*5);
}

public void keyPressed()
{
  switch(key) {
    case 'c':
      mpmf.clear();
    break;
  }
  switch(keyCode) {
    case UP:
      limit += .01;
    break;
    case DOWN:
      limit -= .01;
    break;
  }
}

public void draw()
{
  background(0);
  mpmf.handle();
  
  /*
  for(DropMenu menu : menus) {
    menu.draw();
  }
  */
  
  noFill();
  stroke(255);
  ellipse(mouseX,mouseY,cursor_radius*2,cursor_radius*2);
  if(mousePressed) {
    if(mouseButton==LEFT) {
      for(Part part : mpmf.addCircle(
        mouseX,
        mouseY,
        cursor_radius,
        max(1,(int)cursor_radius)))
      {
        if(keyPressed && key=='s') {
          float dx = part.x - width/2;
          float dy = part.y - height/2;
          float v = sqrt(0.02*sqrt(dx*dx+dy*dy));
          part.vx = v*sin(atan2(part.y,part.x)+PI);
          part.vy = v*cos(atan2(part.y,part.x)+PI);
        } else {
          part.vx = (mouseX - pmouseX) * .1;
          part.vy = (mouseY - pmouseY) * .1;
        }
        part.mass = 1;
        if(keyPressed && key=='l') {
          part.surface_tension = -2;
        } else {
          part.surface_tension = .5;
        }
      }
    } else {
      for(int i=mpmf.size()-1;i>=0;i--) {
        Part part = mpmf.get(i);
        float dx = part.x - mouseX;
        float dy = part.y - mouseY;
        if(dx*dx+dy*dy<cursor_radius*cursor_radius) {
          mpmf.remove(i);
        }
      }
    }
  }
  
  surface.setTitle("FPS: "+frameRate);
}