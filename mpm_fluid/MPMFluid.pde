
public class MPMFluid extends ArrayList<Part>
{
  private Part[][] grid;
  public float cell_length;
  
  public MPMFluid(int width, int height, float cell_length)
  {
    int grid_width = (int)(width/cell_length)+2;
    int grid_height = (int)(height/cell_length)+2;
    grid = new Part[grid_width][grid_height];
    for(int x=0;x<grid.length;x++)
    for(int y=0;y<grid[0].length;y++)
    {
      grid[x][y] = new Part(x*cell_length,y*cell_length).useMass(0);
    }
    this.cell_length = cell_length;
  }
  
  public void moveParts()
  {
    for(Part part : this) {
      part.move();
      if(part.x!=(part.x=min(max(part.x,cell_length),(grid.length-2)*cell_length))) { part.vx*=-random(.8,.7); }
      if(part.y!=(part.y=min(max(part.y,cell_length),(grid[0].length-2)*cell_length))) { part.vy*=-random(.8,.7); }
    }
  }
  
  public void draw()
  {
    for(Part part : this) {
      part.draw();
    }
  }
  
  private void resetGrid()
  {
    for(int x=0;x<grid.length;x++)
    for(int y=0;y<grid[0].length;y++)
    {
      grid[x][y].vx = 0;
      grid[x][y].vy = 0;
      grid[x][y].mass = 0;
    }
  }
  
  private void projectPartsToGrid()
  {
    // g = grid (e.g. gx = grid x)
    // l = lerp = linear interpolation
    for(Part part : this) {
      float x = part.x/cell_length;
      float y = part.y/cell_length;
      int gx = (int)x; if(gx<0 || gx>=grid.length) { continue; }
      int gy = (int)y; if(gy<0 || gy>=grid[0].length) { continue; }
      float lx = x-gx;
      float ly = y-gy;
      float mass = part.mass;
      float x0y0 = (1-lx)*(1-ly)*mass;
      float x1y0 = lx*(1-ly)*mass;
      float x0y1 = (1-lx)*ly*mass;
      float x1y1 = lx*ly*mass;
      grid[gx][gy].vx += part.vx*x0y0; grid[gx][gy].vy += part.vy*x0y0;
      grid[gx+1][gy].vx += part.vx*x1y0; grid[gx+1][gy].vy += part.vy*x1y0;
      grid[gx][gy+1].vx += part.vx*x0y1; grid[gx][gy+1].vy += part.vy*x0y1;
      grid[gx+1][gy+1].vx += part.vx*x1y1; grid[gx+1][gy+1].vy += part.vy*x1y1;
      grid[gx][gy].surface_tension = part.surface_tension*x0y0;
      grid[gx+1][gy].surface_tension = part.surface_tension*x1y0;
      grid[gx][gy+1].surface_tension = part.surface_tension*x0y1;
      grid[gx+1][gy+1].surface_tension = part.surface_tension*x1y1;
      grid[gx][gy].mass += x0y0;
      grid[gx+1][gy].mass += x1y0;
      grid[gx][gy+1].mass += x0y1;
      grid[gx+1][gy+1].mass += x1y1;
    }
  }
  
  private void blurPressure()
  {
    float[][] pressure = new float[grid.length][grid[0].length];
    for(int x=0;x<grid.length;x++)
    for(int y=0;y<grid[0].length;y++)
    {
      pressure[x][y] = grid[x][y].mass;
    }
    for(int x=0;x<grid.length;x++)
    for(int y=0;y<grid[0].length;y++)
    {
      float contrib = 0;
      int neighbors = 0;
      for(int i=-1;i<=1;i++)
      for(int j=-1;j<=1;j++)
      {
        int u=x+i; if(u<0||u>=grid.length) continue;
        int v=y+j; if(v<0||v>=grid[0].length) continue;
        contrib += pressure[u][v];
        neighbors++;
      }
      grid[x][y].mass = contrib/neighbors;
    }
  }
  
  private void applyForces()
  {
    // d = density
    // _1 = -1
    for(int x=0;x<grid.length;x++)
    for(int y=0;y<grid[0].length;y++)
    {
      float dx_1y0 = x-1>=0?grid[x-1][y].mass:0;
      float dx0y_1 = y-1>=0?grid[x][y-1].mass:0;
      float dx1y0 = x+1<grid.length?grid[x+1][y].mass:0;
      float dx0y1 = y+1<grid[0].length?grid[x][y+1].mass:0;
      grid[x][y].vx += (dx_1y0-dx1y0)*max(-0.25,grid[x][y].mass-grid[x][y].surface_tension);
      grid[x][y].vy += (dx0y_1-dx0y1)*max(-0.25,grid[x][y].mass-grid[x][y].surface_tension);
    }
  }
  
  private void normalizeVelocities()
  {
    for(int x=0;x<grid.length;x++)
    for(int y=0;y<grid[0].length;y++)
    {
      if(grid[x][y].mass>0) {
        grid[x][y].vx /= grid[x][y].mass;
        grid[x][y].vy /= grid[x][y].mass;
      }
    }
  }
  
  private void projectGridToParts()
  {
    normalizeVelocities();
    blurPressure();
    blurPressure();
    applyForces();
    for(Part part : this) {
      float x = part.x/cell_length;
      float y = part.y/cell_length;
      int gx = (int)x; if(gx<0 || gx>=grid.length) { continue; }
      int gy = (int)y; if(gy<0 || gy>=grid[0].length) { continue; }
      float lx = x-gx;
      float ly = y-gy;
      float x0y0 = (1-lx)*(1-ly);
      float x1y0 = lx*(1-ly);
      float x0y1 = (1-lx)*ly;
      float x1y1 = lx*ly;
      part.vx = 
        grid[gx][gy].vx*x0y0+
        grid[gx+1][gy].vx*x1y0+
        grid[gx][gy+1].vx*x0y1+
        grid[gx+1][gy+1].vx*x1y1;
      part.vy = 
        grid[gx][gy].vy*x0y0+
        grid[gx+1][gy].vy*x1y0+
        grid[gx][gy+1].vy*x0y1+
        grid[gx+1][gy+1].vy*x1y1;
    }
  }
  
  public void solve()
  {
    resetGrid();
    projectPartsToGrid();
    //applyForces();
    projectGridToParts();
  }
  
  public void applyGravity()
  {
    switch(grav_mode) {
      case 0: for(Part part : this) { part.vy += grav_power; } break;
      case 1: for(Part part : this) { part.vy -= grav_power; } break;
      case 2: for(Part part : this) { part.vx += grav_power; } break;
      case 3: for(Part part : this) { part.vx -= grav_power; } break;
      case 4: { float force=grav_power/sqrt(2); for(Part part : this) { part.vx += force; part.vy += force; }} break;
      case 5: { float force=grav_power/sqrt(2); for(Part part : this) { part.vx -= force; part.vy += force; }} break;
      case 6: { float force=grav_power/sqrt(2); for(Part part : this) { part.vx += force; part.vy -= force; }} break;
      case 7: { float force=grav_power/sqrt(2); for(Part part : this) { part.vx -= force; part.vy -= force; }} break;
      case 8:
        for(Part part : this) {
          float dx = width/2 - part.x;
          float dy = height/2 - part.y;
          if(!(dx==0 && dy==0)) {
            float force = grav_power/sqrt(dx*dx+dy*dy);
            dx *= force;
            dy *= force;
            part.vx += dx;
            part.vy += dy;
          }
        }
      break;
      case 9:
        for(Part part : this) {
          float dx = width/2 - part.x;
          float dy = height/2 - part.y;
          if(!(dx==0 && dy==0)) {
            float force = -grav_power/sqrt(dx*dx+dy*dy);
            dx *= force;
            dy *= force;
            part.vx += dx;
            part.vy += dy;
          }
        }
      break;
    }
  }
  
  public void drawGrid()
  {
    blurPressure();
    blurPressure();
    noStroke();
    colorMode(HSB);
    for(int x=0;x<grid.length;x++)
    for(int y=0;y<grid[0].length;y++)
    {
      //float vx = grid[x][y].vx;
      //float vy = grid[x][y].vy;
      //float b = (vx*vx+vy*vy);
      //b = b>=1?1:(-2*b+3)*b*b;
      //float h = (atan2(vy,vx)/PI+1)*255;
      //fill(255,255,grid[x][y].mass*1000);
      if(grid[x][y].mass>.1) {
        fill((grid[x][y].mass*100+50)%255,255,grid[x][y].mass*255);
        rect(x*cell_length,y*cell_length,cell_length,cell_length);
      }
    }
    colorMode(RGB);
  }
  
  public void drawMesh()
  {
    stroke(0,255,0);
    final float threshold = .1;
    for(int x=0;x<grid.length-2;x++)
    for(int y=0;y<grid[0].length-2;y++)
    {
      ArrayList<float[]> vertices = new ArrayList<float[]>();
      { float l=(threshold-grid[x  ][y  ].mass)/(grid[x+1][y  ].mass-grid[x  ][y  ].mass); if(l>=0&&l<=1) { vertices.add(new float[]{(x+l  )*cell_length, y     *cell_length}); }}
      { float l=(threshold-grid[x+1][y  ].mass)/(grid[x+1][y+1].mass-grid[x+1][y  ].mass); if(l>=0&&l<=1) { vertices.add(new float[]{(x+1  )*cell_length,(y+l  )*cell_length}); }}
      { float l=(threshold-grid[x+1][y+1].mass)/(grid[x  ][y+1].mass-grid[x+1][y+1].mass); if(l>=0&&l<=1) { vertices.add(new float[]{(x+1-l)*cell_length,(y+1  )*cell_length}); }}
      { float l=(threshold-grid[x  ][y+1].mass)/(grid[x  ][y  ].mass-grid[x  ][y+1].mass); if(l>=0&&l<=1) { vertices.add(new float[]{ x     *cell_length,(y+1-l)*cell_length}); }}
      if(vertices.size()%2==0) {
        for(int i=0;i<vertices.size();i+=2) {
          float[] p0 = vertices.get(i);
          float[] p1 = vertices.get(i+1);
          line(p0[0],p0[1],p1[0],p1[1]);
        }
      }
    }
  }
  
  public void doSpaceTime()
  {
    for(int x=0;x<grid.length-2;x++)
    for(int y=0;y<grid[0].length-2;y++)
    {
      if(grid[x][y].mass<=.5) {
        Part part = new Part((x+random(-1,1))*cell_length,(y+random(-1,1))*cell_length);
        part.mass = 1;
        add(part);
      }
    }
    for(int i=size()-1;i>=0;i--) {
      Part part = get(i);
      float x = part.x/cell_length;
      float y = part.y/cell_length;
      int gx = (int)x; if(gx<0 || gx>=grid.length) { continue; }
      int gy = (int)y; if(gy<0 || gy>=grid[0].length) { continue; }
      float lx = x-gx;
      float ly = y-gy;
      float x0y0 = (1-lx)*(1-ly);
      float x1y0 = lx*(1-ly);
      float x0y1 = (1-lx)*ly;
      float x1y1 = lx*ly;
      if(
        grid[gx][gy].mass*x0y0+
        grid[gx+1][gy].mass*x1y0+
        grid[gx][gy+1].mass*x0y1+
        grid[gx+1][gy+1].mass*x1y1>limit) {
          remove(i);
        }
    }
  }
  
  public void handle()
  {
    for(int i=0;i<5;i++) {
      /*
      float shift_x = random(0,cell_length)/2;
      float shift_y = random(0,cell_length)/2;
      for(Part part : this) {
        part.x += shift_x;
        part.y += shift_y;
      }
      */
      moveParts();
      applyGravity();
      solve();
      /*
      for(Part part : this) {
        part.x -= shift_x;
        part.y -= shift_y;
      }
      */
    }
    /*
    for(int i=0;i<size();i++) {
      for(int j=i+1;j<size();j++) {
        get(i).interact(get(j));
      }
    }
    */
    drawGrid();
    drawMesh();
    //draw();
    //doSpaceTime();
  }
  
  public ArrayList<Part> addCircle(float x, float y, float r, int amount)
  {
    ArrayList<Part> parts = new ArrayList<Part>();
    for(int i=0;i<amount;i++) {
      float angle = random(0,TWO_PI);
      float range = sqrt(random(0,1))*r;
      Part part = new Part(x+sin(angle)*range,y+cos(angle)*range);
      parts.add(part);
      add(part);
    }
    return parts;
  }
  
}