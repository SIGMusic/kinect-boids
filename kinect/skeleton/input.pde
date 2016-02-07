
class Input{
  
  void collision(Boid b){
  }
  protected void sendCollisionMsg(Boid b, float x1, float y1, float x2, float y2){
    boolean collides = b.checkCollision(x1, y1, x2, y2);
    if (collides) {
       OscMessage msg = new OscMessage("/collision");
       msg.add(b.id);
       //location of boid
       msg.add(b.location.x);
       msg.add(b.location.y);
       
       float linelen = dist(x1, y1, x2, y2);
      
        // send the length of the string
       msg.add(linelen);
       
       // send radius
       msg.add(b.r);
       
       
       // send colors
       msg.add(b.red);
       msg.add(b.green);
       msg.add(b.blue);
       
       
       sendOSCMessage(msg);
    }
  }
  
  boolean kinected(){
    return true;
  }
  
  void drawInput() {}
  
  void keyDown() {}
  void keyUp() {}
}