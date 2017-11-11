
static class vec3
{
  float[] e;
  
  vec3()
  {
    e = new float[3];
  }
  
  vec3(float...e)
  {
    this();
    for(int i=0;i<e.length;i++) {
      this.e[i] = e[i];
    }
  }
  
  vec3(vec3 v)
  {
    this(v.e);
  }
  
  vec3 raw_add(float...e){for(int i=0;i<e.length;i++){this.e[i]+=e[i];}return this;}
  vec3 raw_sub(float...e){for(int i=0;i<e.length;i++){this.e[i]-=e[i];}return this;}
  vec3 raw_mul(float...e){for(int i=0;i<e.length;i++){this.e[i]*=e[i];}return this;}
  vec3 raw_div(float...e){for(int i=0;i<e.length;i++){this.e[i]/=e[i];}return this;}
  vec3 raw_mul(float s){return raw_mul(s,s,s);}
  vec3 raw_div(float s){return raw_div(s,s,s);}
  vec3 raw_add(vec3 v){return raw_add(v.e);}
  vec3 raw_sub(vec3 v){return raw_sub(v.e);}
  vec3 raw_mul(vec3 v){return raw_mul(v.e);}
  vec3 raw_div(vec3 v){return raw_div(v.e);}
  vec3 add(float...e){return new vec3(this).raw_add(e);}
  vec3 sub(float...e){return new vec3(this).raw_sub(e);}
  vec3 mul(float...e){return new vec3(this).raw_mul(e);}
  vec3 div(float...e){return new vec3(this).raw_div(e);}
  vec3 mul(float s){return mul(s,s,s);}
  vec3 div(float s){return div(s,s,s);}
  vec3 add(vec3 v){return add(v.e);}
  vec3 sub(vec3 v){return sub(v.e);}
  vec3 mul(vec3 v){return mul(v.e);}
  vec3 div(vec3 v){return div(v.e);}
  
  vec3 unit()
  {
    return div(magnitude());
  }
  
  float magnitude()
  {
    return sqrt(dot(this,this));
  }
  
  static float dot(vec3 a, vec3 b)
  {
    float sum = 0;
    for(int i=0;i<a.e.length;i++) {
      sum += a.e[i]*b.e[i];
    }
    return sum;
  }
  
  static vec3 cross(vec3 a, vec3 b)
  {
    return new vec3(
      a.e[1]*b.e[2]-a.e[2]*b.e[1],
      a.e[2]*b.e[0]-a.e[0]*b.e[2],
      a.e[0]*b.e[1]-a.e[1]*b.e[0]
    );
  }
  
  vec3 mul(mat3 m)
  {
    vec3 transformed = new vec3();
    for(int i=0;i<e.length;i++) {
      for(int j=0;j<e.length;j++) {
        transformed.e[i] += e[j]*m.e[i].e[j];
      }
    }
    return transformed;
  }
  
  String toString()
  {
    StringBuilder str = new StringBuilder();
    str.append(e[0]);
    for(int i=1;i<e.length;i++) {
      str.append(", "+e[i]);
    }
    return str.toString();
  }
  
}