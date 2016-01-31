/*
Thomas Sanchez Lengeling.
 http://codigogenerativo.com/
 
 KinectPV2, Kinect for Windows v2 library for processing
 
 3D Skeleton.
 Some features a not implemented, such as orientation
 */

import KinectPV2.KJoint;
import KinectPV2.*;

Flock flock;
Flock big_flock;
Input input;


float zVal = 300;
float rotX = PI;

void setup() {
  size(1280, 1024, P3D);
  //fullScreen();
  
  input = new KeyboardInput();//KinectInput(this);
  
  flock = new Flock();
  big_flock = new Flock();
  
  // Set the number of each size we want
  int numSmall = 100;
  int numBig = 10;
  int i;
  // Add an initial set of boids into the system
  for (i = 0; i < numSmall; i++) {
    flock.addBoid(new Boid(width/2, height/2, i, 5));
  }
  // Add an initial set of boids into the system
  for (i = numSmall; i < numSmall+numBig; i++) {
    big_flock.addBoid(new Boid(width/2, height/2, i, 15));
  }
  
  setupOsc();
  //smooth();
}

boolean held = false;

void mouseDragged() {
  //print("hi");
  PVector loc = new PVector(mouseX, mouseY, 0);
  flock.handForce(loc, -1);
}

void mousePressed() {
  
  //print("hi");
  PVector loc = new PVector(mouseX, mouseY, 0);
  if (held) {
    flock.handForce(loc, -1);
  }
  else {
     held = true; 
  }
}

void mouseReleased() {
  held = false;
}

void keyPressed() {
  input.keyDown(); 
}

void keyReleased() {
  input.keyUp(); 
}

void draw() {
  background(0);

  input.drawInput();

  fill(255, 0, 0);
  text(frameRate, 50, 50);
  
  PVector loc = new PVector(mouseX, mouseY, 0);
  if (held) {
    flock.handForce(loc, -1);
  }
  
  flock.run();
  big_flock.run();
}