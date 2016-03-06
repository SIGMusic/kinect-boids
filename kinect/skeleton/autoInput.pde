import java.util.*;

class AutoInput extends Input{
  
  float xCenter, yCenter, radius, angle;
  float x1, x2, y1, y2;
  boolean posX, posY;
  
  final float angVel = 0.02;
  final float radAvg = 75.0;
  final float radAmp = 25.0;
  final float centerVel = 2.0;
  
  AutoInput(){
    xCenter = width/2.0;
    yCenter = height/2.0;
    radius = 50.0;
    angle = 0.0;
    posX = true;
    posY = true;
    computeEndpoints();
  }
  
  void collision(Boid b){
    resizeBoidCollisions(1);
    sendCollisionMsg(b, x1, y1, x2, y2, 0);
  }
  
  void drawInput() {
    resizeBoidCollisions(1);
    
    updatePos();
    
    drawString(x1, y1, x2, y2, 0);
    
    stroke(255);
    strokeWeight(10);
    point(x1,y1);
    point(x2,y2);
    
  }
  
  void updatePos(){
    angle += angVel;
    radius = radAmp * sin(2*PI*frameCount/animationSpeedModulo/2.0) + radAvg;
    xCenter += posX? centerVel: -centerVel;
    yCenter += posY? centerVel: -centerVel;
    if(xCenter < radius){
      xCenter = radius;
      posX = true;
    }
    if(xCenter > width - radius){
      xCenter = width - radius;
      posX = false;
    }
    if(yCenter < radius){
      yCenter = radius;
      posY = true;
    }
    if(yCenter > height - radius){
      yCenter = height - radius;
      posY = false;
    }
    computeEndpoints();
  }
  
  void computeEndpoints(){
    float dx = radius*cos(angle);
    float dy = radius*sin(angle);
    x1 = xCenter - dx;
    y1 = yCenter + dy;
    x2 = xCenter + dx;
    y2 = yCenter - dy;
  }
  
}