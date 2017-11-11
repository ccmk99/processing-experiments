
// space to reset accumulation buffer
// drag inside window to set julia coordinates

int[][][] data;
float xAxis;
float yAxis;
float unit;
double juliax;
double juliay;

void loadSystem()
{
  surface.setTitle("Buddhabrot");
  surface.setResizable(true);
  
  PGraphics icon = createGraphics(1,1,JAVA2D);
  icon.beginDraw();
  icon.endDraw();
  surface.setIcon(icon.get());
  
}

void collectSample(int iterations, int r, int g)
{
  double startx = Math.random()*4-2;
  double starty = Math.random()*4-2;
  double xpos = juliax,xsqr;
  double ypos = juliay,ysqr;
  double re = startx;
  double im = starty;
  for(int i=0;i<iterations;i++)
  {
    xsqr = re * re;
    ysqr = im * im;
    im = 2 * re * im + ypos;
    re = xsqr - ysqr + xpos;
    if(xsqr+ysqr>4.)
    {
      int c = i>g?2:i>r?1:0;
      re = startx;
      im = starty;
      for(int j=1;j<i;j++)
      {
        xsqr = re * re;
        ysqr = im * im;
        im = 2 * re * im + ypos;
        re = xsqr - ysqr + xpos;
        int x = (int)((re/unit)+xAxis); //if(x<0||x>=data.length) continue;
        int y = (int)((im/unit)+yAxis); //if(y<0||y>=data[0].length) continue;
        data[x][y][c]++;
      }
      break;
    }
  }
}

void updateParams()
{
  xAxis = width / 2.;
  yAxis = height / 2.;
  unit = 4.0 / min(width,height);
  if((data==null) || (width!=data.length) || (height!=data[0].length))
  {
    data = new int[width][height][3];
  }
}

int getMaxValue(int c)
{
  int max = 0;
  for(int x=0;x<data.length;x++)
  for(int y=0;y<data[0].length;y++)
  {
    if(data[x][y][c]>max)
    {
      max = data[x][y][c];
    }
  }
  return max;
}

void setup()
{
  size(640,480);
  loadPixels();
  loadSystem();
}

void keyPressed()
{
  switch(key)
  {
    case ' ':
      data = new int[width][height][3];
    break;
    case 'c':
      saveFrame("#####.png");
    break;
  }
}

void draw()
{
  try {
    updateParams();
    for(int i=0;i<100000;i++)
    {
      //juliax = Math.random()*4-2;
      //juliay = Math.random()*4-2;
      collectSample(1000,333,666);
    }
    int rmax = getMaxValue(0);
    int gmax = getMaxValue(1);
    int bmax = getMaxValue(2);
    for(int x=0;x<width ;x++)
    for(int y=0;y<height;y++)
    {
      pixels[x+y*width] = color(
        (float)data[x][y][0]/rmax*2550,
        (float)data[x][y][1]/gmax*2550,
        (float)data[x][y][2]/bmax*2550
      );
    }
    updatePixels();
  } catch(Exception e) {}
  juliax = ((double)mouseX/width )*4-2;
  juliay = ((double)mouseY/height)*4-2;
}