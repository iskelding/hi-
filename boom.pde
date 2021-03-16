class boom {
  PVector pos;
  PVector vel;
  float r = 10;
  float a;
  boolean dead;
  
  boom(PVector _pos){
    pos = new PVector(_pos.x, _pos.y);
    a = 200;
    float dir = random(TAU);
    vel = PVector.fromAngle(dir);
    dead = false;
  }
  
  void render(){
    strokeWeight(r);
    stroke(255, a);
    pushMatrix();
    translate(pos.x, pos.y);
    point(0, 0);
    popMatrix();
  }
  
  void update(){
    pos.add(vel);
    a-=5;
    if(a < 0) dead = true;
  }
}
