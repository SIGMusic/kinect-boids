import java.util.*;

class KeyboardInput extends Input{
  
  float x1, x2, y1, y2;
  boolean kW, kA, kS, kD, kQ, kLeft, kRight, kUp, kDown;
  final float vel = 2.0;
  
  KeyboardInput(){
    x1 = width/2-50;
    x2 = width/2+50;
    y1 = height/2;
    y2 = height/2;
  }
  
  void collision(Boid b){
    sendCollisionMsg(b, x1, y1, x2, y2);
  }
  
  void drawInput() {
    updatePos();
    
    stroke(255);
    strokeWeight(2);
    
    // remove if want to use multiple boid collisions
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
    noFill();
    beginShape();
    curveVertex(prev_x, prev_y); // the first control point
    curveVertex(prev_x, prev_y);
    if (boid_collisions.size() != 0) {
      //Boid b = boid_collisions.get(0);
      // this is commented out to only pluck using the first boid that collides
      for( Boid b : boid_collisions) {
        // only draw those that are past the string
        if((x1-x2)*(b.location.y-y1) < (y1-y2)*(b.location.x-x1)){
          curveVertex(b.location.x, b.location.y); 
        }
      }
    }
    curveVertex(x2, y2); 
    curveVertex(x2, y2); // is also the last control point
    endShape();
    
    stroke(255);
    strokeWeight(10);
    point(x1,y1);
    point(x2,y2);
    
  }
  
  void updatePos(){
    if(kA){
      x1 -= vel;
    }
    if(kD){
      x1 += vel;
    }
    if(kW){
      y1 -= vel;
    }
    if(kS){
      y1 += vel;
    }
    if(kLeft){
      x2 -= vel;
    }
    if(kRight){
      x2 += vel;
    }
    if(kUp){
      y2 -= vel;
    }
    if(kDown){
      y2 += vel;
    }
  }
  
  void keyDown() {
    switch(key){
    case 'w':
      kW = true;
      break;
    case 'a':
      kA = true;
      break;
    case 's':
      kS = true;
      break;
    case 'd':
      kD = true;
      break;
      
    case 'q':
      kQ = true;
      break;
      
    case CODED:
      switch(keyCode){
      case LEFT:
        kLeft = true;
        break;
      case RIGHT:
        kRight = true;
        break;
      case UP:
        kUp = true;
        break;
      case DOWN:
        kDown = true;
        break;
      }
      break;
    }
  }
  
  void keyUp() {
    switch(key){
    case 'w':
      kW = false;
      break;
    case 'a':
      kA = false;
      break;
    case 's':
      kS = false;
      break;
    case 'd':
      kD = false;
      break;
      
    case 'q':
      showFlockLines = !showFlockLines;
      kQ = false;
      break;
      
    case CODED:
      switch(keyCode){
      case LEFT:
        kLeft = false;
        break;
      case RIGHT:
        kRight = false;
        break;
      case UP:
        kUp = false;
        break;
      case DOWN:
        kDown = false;
        break;
      }
      break;
    }
  }
}