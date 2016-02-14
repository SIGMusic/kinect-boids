
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
  void drawString(float x1, float y1, float x2, float y2) {
    stroke(255);
    strokeWeight(2);
    
    for( Boid b : boid_collisions) {
      b.compareInit(x1, y1, x2, y2);
    }
    Collections.sort(boid_collisions);
    
    float prev_x = x1;
    float prev_y = y1;
    
    // with lines
    //if (boid_collisions.size() != 0) {
    // for (Boid b : boid_collisions) {
    //   line(prev_x, prev_y, b.location.x, b.location.y);
    //   prev_x = b.location.x;
    //   prev_y = b.location.y;
    // }
    //}
    //line(prev_x, prev_y, x2, y2);
    //line(prev_x,prev_y,x2,y2);
    
    
    // with curves
    ArrayList<Boid> boid_string = new ArrayList<Boid>();
    if (boid_collisions.size() != 0){
      for( Boid b : boid_collisions) {
        // only draw those that are past the string
        if(((prev_x-x2)*(b.location.y-prev_y) > (prev_y-y2)*(b.location.x-prev_x)) == cwCollision){
          boid_string.add(b);
          prev_x = b.location.x;
          prev_y = b.location.y;
        }
      }
      prev_x = x2;
      prev_y = y2;
      Iterator<Boid> bIt = boid_string.iterator();
      ListIterator<Boid> nIt;
      testBoid: while(bIt.hasNext()) {
        Boid b = bIt.next();
        nIt = boid_string.listIterator(boid_string.indexOf(b) + 1);
        while(nIt.hasNext()) {
          Boid n = nIt.next();
          if(((prev_x-b.location.x)*(n.location.y-prev_y) > (prev_y-b.location.y)*(n.location.x-prev_x)) == cwCollision){
            bIt.remove();
            continue testBoid;
          }
        }
        prev_x = b.location.x;
        prev_y = b.location.y;
      }
    }
    noFill();
    beginShape();
    curveVertex(x1, y1); // the first control point
    curveVertex(x1, y1);
    if (boid_string.size() != 0) {
      // add all boid points
      for( Boid b : boid_string) {
        curveVertex(b.location.x, b.location.y);
      }
    }
    curveVertex(x2, y2); 
    curveVertex(x2, y2); // is also the last control point
    endShape();
  }
  
  void keyDown() {}
  void keyUp() {}
}