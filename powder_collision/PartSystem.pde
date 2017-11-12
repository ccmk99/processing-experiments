
class PartSystem extends ArrayList<Part>
{
  Sorter<Part> sorter;
  float cell_length;
  int[][] id_grid;
  
  PartSystem(float cell_length)
  {
    this.cell_length = cell_length;
    id_grid = new int
      [(int)(width/cell_length)+1]
      [(int)(height/cell_length)+1];
    sorter = new Sorter<Part>(this,id_grid.length*id_grid[0].length){
      int getValue(Part part) {
        return part.id;
      }
    };
  }
  
  void move()
  {
    for(Part part : this) {
      part.move();
    }
  }
  
  void draw()
  {
    noStroke();
    fill(255);
    for(Part part : this) {
      part.draw();
    }
  }
  
  void handle()
  {
    for(int i=0;i<1;i++) {
      sortByID();
      resetIDGrid();
      projectIDsToGrid();
      applyInteractions();
    }
    move();
    draw();
  }
  
  private void sortByID()
  {
    for(Part part : this) {
      part.updateId(cell_length,id_grid.length);
    }
    sorter.sort();
  }
  
  private void resetIDGrid()
  {
    for(int i=0;i<id_grid.length;i++)
    for(int j=0;j<id_grid[0].length;j++)
    {
      id_grid[i][j] = -1;
    }
  }
  
  private void projectIDsToGrid()
  {
    int index = -1;
    int track = 0;
    for(Part part : this) {
      if(index!=part.id) {
        index = part.id;
        id_grid
          [index%id_grid.length]
          [index/id_grid.length] = track;
      }
      track++;
    }
  }
  
  private void applyInteractions()
  {
    ArrayList<Part> neighborhood = new ArrayList<Part>();
    for(int i=0;i<id_grid.length;i++)
    for(int j=0;j<id_grid[0].length;j++)
    {
      if(id_grid[i][j]!=-1) {
        neighborhood.clear();
        for(int u=-1;u<=1;u++)
        for(int v=-1;v<=1;v++)
        {
          int x = i+u; if(x<0||x>=id_grid.length) continue;
          int y = j+v; if(y<0||y>=id_grid[0].length) continue;
          if(id_grid[x][y]!=-1) {
            int id = get(id_grid[x][y]).id;
            for(int k=id_grid[x][y];k<size()&&id==get(k).id;k++) {
              neighborhood.add(get(k));
            }
          }
        }
        for(int u=0;u<neighborhood.size();u++)
        for(int v=u+1;v<neighborhood.size();v++)
        {
          neighborhood.get(u).interact(neighborhood.get(v));
        }
      }
    }
  }
  
}