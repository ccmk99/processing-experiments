
class Camera
{
  vec3 position;
  vec3 rotation;
  vec3 velocity;
  mat3 frame;
  boolean frame_updated;
  float slow_factor = 0.9;
  
  Camera(float...e)
  {
    position = new vec3(e);
    rotation = new vec3();
    velocity = new vec3();
    frame = mat3.getIdentity();
    frame_updated = true;
  }
  
  Camera()
  {
    this(0,0,0);
  }
  
  private void updateFrame()
  {
    if(!frame_updated) {
      frame_updated = true;
      
      frame = mat3.getIdentity()
        .mul(mat3.getRotationZ(rotation.e[2]))
        .mul(mat3.getRotationX(rotation.e[0]))
        .mul(mat3.getRotationY(rotation.e[1]));
      //println(frame);
    }
  }
  
  void walk(float speed)
  {
    updateFrame();
    velocity.raw_add(frame.e[2].mul(speed));
  }
  
  void strafe(float speed)
  {
    updateFrame();
    velocity.raw_add(frame.e[0].mul(speed));
  }
  
  void turnVertical(float angle)
  {
    rotation.e[0] += angle;
    frame_updated = false;
  }
  
  void turnHorizontal(float angle)
  {
    rotation.e[1] -= angle;
    frame_updated = false;
  }
  
  void update()
  {
    updateFrame();
    position.raw_add(velocity).raw_mul(slow_factor);
  }
  
}