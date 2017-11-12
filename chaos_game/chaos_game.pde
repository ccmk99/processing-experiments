
float VERTICES = 2;
final double FRACTION = 0.5;
final int[] RULE = new int[]{0};

long[][] buffer;
double point_x;
double point_y;
double[][] vertices;
int[] history;
long max;

ArrayList<PImage> movie_frames;
boolean saving;

void rememberVertex(int index)
{
  if(history.length>0) {
    for(int i=history.length-1;i>=1;i--) {
      history[i] = history[i-1];
    }
    history[0] = index;
  }
}

void setup()
{
  noSmooth();
  size(1000,1000);
  //fullScreen();
  buffer = new long[width][height];
  history = new int[RULE.length];
  loadPixels();
  initPolygon();
  movie_frames = new ArrayList<PImage>();
}

void fadeBuffer(float factor)
{
  for(int i=0;i<buffer.length;i++)
  for(int j=0;j<buffer[i].length;j++)
  {
    buffer[i][j] = (long)max(0,buffer[i][j]*factor);
  }
  max = 0;
}

void initPolygon()
{
  float center_x = width/2.;
  float center_y = height/2.;
  vertices = new double[100][2];
  // generate polygon
  float radius = min(width,height)/2-10;
  for(int i=0;i<vertices.length;i++) {
    double angle = (double)i/VERTICES*TWO_PI;
    double[] offset = randomVectorWithinRadius(0);
    vertices[i][0] = center_x+radius*Math.sin(angle)+offset[0];
    vertices[i][1] = center_y-radius*Math.cos(angle)+offset[1];
  }
  point_x = vertices[0][0];
  point_y = vertices[0][1];
  for(int i=0;i<pixels.length;i++) {
    pixels[i] = color(0);
  }
}

double[] randomVectorWithinRadius(double radius)
{
  double angle = Math.random()*TWO_PI;
  radius = Math.sqrt(Math.random())*radius;
  return new double[]{
    Math.sin(angle)*radius,
    Math.cos(angle)*radius
  };
}

int loopMod(int index, int length)
{
  return (length+index%length)%length;
}

void keyPressed()
{
  if(key==' ' && !saving) {
    saving = true;
    println("saving...");
    new Thread(new Runnable(){public void run(){
      for(int i=0;i<movie_frames.size();i++) {
        image(movie_frames.get(i),0,0);
        movie_frames.get(i).save("/movie/"+nf(i,4));
      }
      saving = false;
      println("saved!");
    }}).start();
  } else if(key=='s') {
    fadeBuffer(0);
  }
}

void draw()
{
  if(!saving) {
    int changed_pixels = 10000;
    for(int t=0;t<1&&changed_pixels>1000;t++) {
      int vertex = 0;
      for(int i=0;i<1e5;i++) {
        do {
          vertex = (int)random(0,min(VERTICES,vertices.length));
          for(int j=0;j<RULE.length;j++) {
            if(loopMod(vertex+RULE[j],vertices.length)==history[j]||
               loopMod(vertex-RULE[j],vertices.length)==history[j]) {
              vertex = -1;
              break;
            }
          }
        } while(vertex<0);
        point_x += (vertices[vertex][0]-point_x)*FRACTION;
        point_y += (vertices[vertex][1]-point_y)*FRACTION;
        max=Math.max(buffer[(int)point_x][(int)point_y]++,max);
        rememberVertex(vertex);
      }
      
      changed_pixels = 0;
      colorMode(HSB);
      for(int x=0;x<width;x++)
      for(int y=0;y<height;y++)
      {
        if(buffer[x][y]>0) {
          float weight = (float)(255*((double)buffer[x][y]/max));
          int index = x + y*width;
          if(pixels[index]!=(pixels[index]=color((weight*2)%255,255,255))) {
            changed_pixels++;
          }
          //pixels[x+y*width] = color(weight);
        }
      }
    }
    
    updatePixels();
    
    if(frameCount%1==0 && !(keyPressed && key=='s')) {
      float dv = sin((VERTICES%1)*PI)*1e-2+1e-4;
      VERTICES += dv;
      initPolygon();
      //float fade = (1-(dv-1e-4)/1e-2)*1;
      //fadeBuffer(fade>.9?1:fade);
      fadeBuffer(.8);
      //saveFrame();
    }
  }
  surface.setTitle("FPS: "+(int)frameRate+" Frame: "+frameCount);
}

void saveFrame()
{
  movie_frames.add(get());
}