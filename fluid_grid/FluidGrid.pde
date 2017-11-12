
public class FluidGrid extends ArrayList<Dust>
{
  private float[][][] data;
  private float[][][] back;
  
  public FluidGrid(int width, int height)
  {
    data = new float[width][height][4];
    back = new float[width][height][4];
    for(int i=0;i<10000;i++) {
      add(new Dust());
    }
  }
  
  public void flipBuffers()
  {
    float[][][] tmp = back;
    back = data;
    data = tmp;
  }
  
  public void advect()
  {
    for(int x=0;x<data.length;x++)
    for(int y=0;y<data[0].length;y++)
    {
      for(int k=0;k<data[0][0].length;k++) {
        back[x][y][k] = 0;
      }
      back[x][y][2] = 1;
    }
    for(int x=0;x<data.length;x++)
    for(int y=0;y<data[0].length;y++)
    {
      float u = x+data[x][y][0]; int gx=(int)u; float lx=u-gx;
      float v = y+data[x][y][1]; int gy=(int)v; float ly=v-gy;
      gx=gx<0?data.length-1-((-gx)%data.length):gx%data.length;
      gy=gy<0?data[0].length-1-((-gy)%data.length):gy%data.length;
      int px=gx+1; if(px>=data.length) px=0;
      int py=gy+1; if(py>=data[0].length) py=0;
      float x0y0 = (1-lx)*(1-ly);
      float x1y0 = lx*(1-ly);
      float x0y1 = (1-lx)*ly;
      float x1y1 = lx*ly;
      for(int k=0;k<data[0][0].length;k++) {
        back[gx][gy][k] += x0y0*data[x][y][k];
        back[px][gy][k] += x1y0*data[x][y][k];
        back[gx][py][k] += x0y1*data[x][y][k];
        back[px][py][k] += x1y1*data[x][y][k];
      }
    }
  }
  
  public void applyPressureForce()
  {
    for(int x=0;x<data.length;x++)
    for(int y=0;y<data[0].length;y++)
    {
      int x_1 = x-1>=0?x-1:data.length-1;
      int y_1 = y-1>=0?y-1:data[0].length-1;
      int x1 = x+1<data.length?x+1:0;
      int y1 = y+1<data[0].length?y+1:0;
      data[x][y][0] -= (data[x1][y][2]-data[x_1][y][2])*.001;
      data[x][y][1] -= (data[x][y1][2]-data[x][y_1][2])*.001;
      data[x][y][1] -= data[x][y][3]*=.9;
    }
  }
  
  public void diffuse()
  {
    for(int x=0;x<data.length;x++)
    for(int y=0;y<data[0].length;y++)
    {
      float[] contrib = new float[data[0][0].length];
      int samples = 0;
      for(int i=-1;i<=1;i++)
      for(int j=-1;j<=1;j++)
      {
        int u = x+i; if(u<0||u>=data.length) continue;
        int v = y+j; if(v<0||v>=data[0].length) continue;
        for(int k=0;k<contrib.length;k++)  {
          contrib[k] += data[u][v][k];
        }
        samples++;
      }
      if(samples!=0) {
        for(int k=0;k<contrib.length;k++) {
          back[x][y][k] = (contrib[k] / samples)*.999;
        }
      }
    }
  }
  
  public void draw()
  {
    /*
    PImage canvas = createImage(data.length,data[0].length,RGB);
    canvas.loadPixels();
    for(int x=0;x<data.length;x++)
    for(int y=0;y<data[0].length;y++)
    {
      /*
      canvas.pixels[x+y*data.length] = color(
        (data[x][y][0]-data[x][y][1]-data[x][y][2])*2550,
        (data[x][y][1]-data[x][y][0]-data[x][y][2])*2550,
        (data[x][y][2]-data[x][y][0]-data[x][y][1])*2550
      );
      //
      canvas.pixels[x+y*data.length] = color(
        (data[x][y][0]-data[x][y][1])*2550,
        (data[x][y][1]-data[x][y][0])*2550,
        (-data[x][y][0]-data[x][y][1])*2550
      );
    }
    canvas.updatePixels();
    image(canvas,0,0);
    */
    
    for(Dust dust : this) {
      float lx = dust.x;
      float ly = dust.y;
      int x = (int)lx; lx-=x;
      int y = (int)ly; ly-=y;
      if(x<0||x>=data.length-1) continue;
      if(y<0||y>=data[0].length-1) continue;
      float x0y0 = (1-lx)*(1-ly);
      float x1y0 = lx*(1-ly);
      float x0y1 = (1-lx)*ly;
      float x1y1 = lx*ly;
      float[] point = new float[]{dust.x,dust.y};
      for(int i=0;i<2;i++) {
        point[i] += (
          data[x][y][i]*x0y0+
          data[x+1][y][i]*x1y0+
          data[x][y+1][i]*x0y1+
          data[x+1][y+1][i]*x1y1)*10;
      }
      dust.x = point[0];
      dust.y = point[1];
      dust.draw();
    }
    for(int i=0;i<1000;i++) {
      remove(0);
      add(new Dust());
    }
    
    /*
    stroke(255);
    for(int x=0;x<data.length;x+=3)
    for(int y=0;y<data.length;y+=3)
    {
      line(x,y,x+data[x][y][0]*20,y+data[x][y][1]*20);
    }
    */
    
  }
  
  public void handle()
  {
    diffuse();
    flipBuffers();
    advect();
    flipBuffers();
    applyPressureForce();
    draw();
  }
  
}