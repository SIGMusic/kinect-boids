class KinectInput extends Input{

  KinectPV2 kinect;
  
  
  float zVal = 300;
  float rotX = PI;
  
  KinectInput(PApplet _p) {
    kinect = new KinectPV2(_p);
  
    kinect.enableColorImg(true);
  
    //enable 3d  with (x,y,z) position
    kinect.enableSkeleton3DMap(true);
  
    kinect.init();
  }
  
  void collision(Boid b){
    ArrayList<KSkeleton> skeletonArray =  kinect.getSkeleton3d();
    resizeBoidCollisions(skeletonArray.size());
    for (int i = 0; i < skeletonArray.size(); i++) {
      KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
      if (skeleton.isTracked()) {
        KJoint[] joints = skeleton.getJoints();
        
        PVector left = convertToScreenCoord(joints[KinectPV2.JointType_HandTipLeft].getX(), joints[KinectPV2.JointType_HandTipLeft].getY(), joints[KinectPV2.JointType_HandTipLeft].getZ());
        PVector right = convertToScreenCoord(joints[KinectPV2.JointType_HandTipRight].getX(), joints[KinectPV2.JointType_HandTipRight].getY(), joints[KinectPV2.JointType_HandTipRight].getZ());
        
        sendCollisionMsg(b, left.x, left.y, right.x, right.y, i);
      }
    }
  }
  
   // test if the kinect is connected
  boolean kinected(){
    kinect.getColorImage();
    int[] raw = kinect.getRawColor();
    
    //test if we are receiving an image
    //I'm just checking the first 100 pixels for speed
    for(int i=0; i<100; i++){
      if(raw[i] != 0)
        return true;
    }
    return false;
  }
  
  void drawInput() {  

    ArrayList<KSkeleton> skeletonArray =  kinect.getSkeleton3d();
    resizeBoidCollisions(skeletonArray.size());
    for (int i = 0; i < skeletonArray.size(); i++) {
      KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
      if (skeleton.isTracked()) {
        KJoint[] joints = skeleton.getJoints();
  
        PVector left = convertToScreenCoord(joints[KinectPV2.JointType_HandTipLeft].getX(), joints[KinectPV2.JointType_HandTipLeft].getY(), joints[KinectPV2.JointType_HandTipLeft].getZ());
        PVector right = convertToScreenCoord(joints[KinectPV2.JointType_HandTipRight].getX(), joints[KinectPV2.JointType_HandTipRight].getY(), joints[KinectPV2.JointType_HandTipRight].getZ());
        color(skeleton.getIndexColor());
        drawString(left.x, left.y, right.x, right.y, i);
        color col  = skeleton.getIndexColor();
        drawBody(joints, col);
      }
    }
  }
  
  
  void drawBody(KJoint[] joints, color col) {
     PVector left = convertToScreenCoord(joints[KinectPV2.JointType_HandTipLeft].getX(), joints[KinectPV2.JointType_HandTipLeft].getY(), joints[KinectPV2.JointType_HandTipLeft].getZ());
        PVector right = convertToScreenCoord(joints[KinectPV2.JointType_HandTipRight].getX(), joints[KinectPV2.JointType_HandTipRight].getY(), joints[KinectPV2.JointType_HandTipRight].getZ());
    color(col);
    drawJoint(left);
    drawJoint(right);
  }
  
  void drawJoint(PVector joint) {
    strokeWeight(2.0f + joint.z*8);
    point(joint.x, joint.y, joint.z);
  }
  
  void drawJoint(KJoint[] joints, int jointType) {
    strokeWeight(2.0f + joints[jointType].getZ()*8);
    point(joints[jointType].getX(), joints[jointType].getY(), joints[jointType].getZ());
  }
  
  void drawBone(KJoint[] joints, int jointType1, int jointType2) {
    strokeWeight(2.0f + joints[jointType1].getZ()*8);
    point(joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
  }
  
  void drawLine(KJoint[] joints, int jointType1, int jointType2) {
    strokeWeight(.01);
    stroke(255);
    line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType2].getX(), joints[jointType2].getY());
  }
  
  void drawHandState(KJoint joint) {
    handState(joint.getState());
    strokeWeight(5.0f + joint.getZ()*8);
    point(joint.getX(), joint.getY(), joint.getZ());
    
    
    PVector handLocCoord = convertToScreenCoord(joint.getX(), joint.getY(), joint.getZ());
    //PVector handLocCoord = new PVector(joint.getX(), joint.getY());
    //depending on hand state, attract or repel boids
    switch(joint.getState()) {
    case KinectPV2.HandState_Open:  
      //repulse
      //flock.handForce(handLocCoord, 1);
      break;
    case KinectPV2.HandState_Closed:
      //attract
      //flock.handForce(handLocCoord, -1);
      break;
    case KinectPV2.HandState_Lasso:
      //flock.addBoid(new Boid(width/2,height/2));
      break;
    }
  }
  
  void handState(int handState) {
    switch(handState) {
    case KinectPV2.HandState_Open:
      stroke(0, 255, 0);
      break;
    case KinectPV2.HandState_Closed:
      stroke(255, 0, 0);   
      break;
    case KinectPV2.HandState_Lasso:
      stroke(0, 0, 255);
      break;
    case KinectPV2.HandState_NotTracked:
      stroke(100, 100, 100);
      break;
    }
  }
  
  // kinect returns from -1, 1, need to convert to width and height
  PVector convertToScreenCoord(float x, float y, float z) {
    PVector result = new PVector(0.0, 0.0, 0.0);
    float tempWidth = (x+2)/4;
    float tempHeight = (y + 2)/4;
    
    result.x = tempWidth * width;
    result.y = (1 - tempHeight) * height;
    result.z = z;
    
    return result;
  }
  
  void resizeBoidCollisions(int newSize){
    int oldSize = boid_collisions.size();
    if(oldSize < newSize){
      int diff = newSize - oldSize;
      for(int i=0; i<diff; i++)
        boid_collisions.add(new ArrayList<Boid>());
    }else if(oldSize > newSize){
      boid_collisions.subList(newSize, oldSize).clear();
    }
  }
}