
static class mat3
{
  vec3[] e;
  
  mat3()
  {
    e = new vec3[3];
    for(int i=0;i<e.length;i++) {
      e[i] = new vec3();
    }
  }
  
  mat3(float...e) {
    this();
    for(int i=0;i<e.length;i++) {
      this.e[i/3].e[i%3] = e[i];
    }
  }
  
  mat3(vec3...e) {
    e = new vec3[3];
    for(int i=0;i<e.length;i++) {
      this.e[i] = new vec3(e[i]);
    }
  }
  
  mat3(mat3 m) {
    this(m.e);
  }
  
  mat3 mul(mat3 m)
  {
    mat3 transformed = new mat3();
    for(int i=0;i<e.length;i++) {
      transformed.e[i] = e[i].mul(m);
    }
    return transformed;
  }
  
  static mat3 getIdentity()
  {
    mat3 m = new mat3();
    for(int i=0;i<m.e.length;i++) {
      m.e[i].e[i] = 1;
    }
    return m;
  }
  
  static mat3 getRotationX(float angle)
  {
    if(angle!=0) {
      float y = sin(angle);
      float x = cos(angle);
      return new mat3(
        1,0,0,
        0,x,y,
        0,-y,x
      );
    }
    return getIdentity();
  }
  
  static mat3 getRotationY(float angle)
  {
    if(angle!=0) {
      float y = sin(angle);
      float x = cos(angle);
      return new mat3(
        x,0,-y,
        0,1,0,
        y,0,x
      );
    }
    return getIdentity();
  }
  
  static mat3 getRotationZ(float angle)
  {
    if(angle!=0) {
      float y = sin(angle);
      float x = cos(angle);
      return new mat3(
        x,y,0,
        -y,x,0,
        0,0,1
      );
    }
    return getIdentity();
  }
  
  String toString()
  {
    StringBuilder str = new StringBuilder();
    str.append(e[0].toString());
    for(int i=1;i<e.length;i++) {
      str.append("\n"+e[i].toString());
    }
    return str.toString();
  }
  
}