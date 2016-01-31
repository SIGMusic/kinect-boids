import java.util.*;

class KeyboardInput extends Input{
  
  int x1, x2, y1, y2;
  boolean kW, kA, kS, kD, kQ, kLeft, kRight, kUp, kDown;
  final int vel = 2;
  
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
    
    Collections.sort(boid_collisions);
    
    float prev_x = x1;
    float prev_y = y1;
    //if (boid_collisions.size() != 0) {
    //  for (Boid b : boid_collisions) {
    //    line(prev_x, prev_y, b.location.x, b.location.y);
    //    prev_x = b.location.x;
    //    prev_y = b.location.y;
    //  }
    //}
    
    //line(prev_x,prev_y,x2,y2);
    noFill();
    beginShape();
    curveVertex(prev_x, prev_y); // the first control point
    curveVertex(prev_x, prev_y);
    if (boid_collisions.size() != 0) {
       for( Boid b : boid_collisions) {
          curveVertex(b.location.x, b.location.y); 
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
      print(boid_collisions);
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