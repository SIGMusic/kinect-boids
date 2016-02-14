
class Cloud{
  // cloud constants
  final float[] cloudWidth = {0.2, 0.3, 0.3, 0.2};
  final float[] cloudHeight = {0.25, 0.05, -0.05, -0.25};
  final float cloudPuff = 0.5;
  
  float x;
  float y;
  float cloudScale;
  float frameScale;
  float vx;
  float vy;
  float animationOffset;
  
  Cloud(){
    x = random(width);
    y = random(height);
    cloudScale = random(100,170);
    float v = random(0.5,1.5);
    vx = v*random(0.8,1.2);
    vy = v*random(0.8,1.2);
    animationOffset = random(2*PI);
  }
  
  void drawCloud(){
    // uncomment if you want static clouds
    //frameScale = cloudScale;
    frameScale = cloudScale * (0.1 * sin(2*PI*frameCount/animationSpeedModulo/2.0 + animationOffset) + 1);
  
    updatePos();
    
    float prevX = x-frameScale/2.0;
    float prevY = y;
    float nextX, nextY, bezX, bezY;
    
    fill(255, 100);
    strokeWeight(2);
    stroke(255, 150);
    beginShape();
    
    vertex(prevX,prevY);
    for(int i=0; i<cloudWidth.length; i++){
      nextX = prevX+cloudWidth[i]*frameScale;
      nextY = prevY+cloudHeight[i]*frameScale;
      bezX = -cloudHeight[i]*frameScale*cloudPuff;
      bezY = cloudWidth[i]*frameScale*cloudPuff;
      bezierVertex(prevX+bezX,prevY+bezY,nextX+bezX,nextY+bezY,nextX,nextY);
      prevX = nextX;
      prevY = nextY;
    }
    for(int i=cloudWidth.length-1; i>=0; i--){
      nextX = prevX-cloudWidth[i]*frameScale;
      nextY = prevY+cloudHeight[i]*frameScale;
      bezX = -cloudHeight[i]*frameScale*cloudPuff;
      bezY = -cloudWidth[i]*frameScale*cloudPuff;
      bezierVertex(prevX+bezX,prevY+bezY,nextX+bezX,nextY+bezY,nextX,nextY);
      prevX = nextX;
      prevY = nextY;
    }
    
    endShape(CLOSE);
  }
  
  void updatePos(){
    x += vx;
    y += vy;
    
    if (x < -frameScale/2.0) x = width+frameScale/2.0;
    if (y < -frameScale/2.0) y = height+frameScale/2.0;
    if (x > width+frameScale/2.0)  x = -frameScale/2.0;
    if (y > height+frameScale/2.0) y = -frameScale/2.0;
  }
}