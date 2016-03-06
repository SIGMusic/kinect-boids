/*
Thomas Sanchez Lengeling.
 http://codigogenerativo.com/
 
 KinectPV2, Kinect for Windows v2 library for processing
 
 3D Skeleton.
 Some features a not implemented, such as orientation
 */

import KinectPV2.KJoint;
import KinectPV2.*;

// Set the number of each size we want
  int numSmall = 100;
  int numBig = 10;

boolean circleFlocking = true;
boolean useTwitter = false;
boolean showIdle = true;

int numSkeletons = 0;

Flock flock;
Flock big_flock;
Input input;

Input keyboard;


boolean showFlockLines;
ArrayList<ArrayList<Boid>> boid_collisions;
ArrayList<Boolean> cwCollision;

float zVal = 300;
float rotX = PI;

int fps = 60;
float bpm = 112.0;
float animationSpeedModulo = fps*60.0/bpm; // will change frames everytime framecount % speedModulo == 0
float[] curBackground = new float[]{0.0/360.0, 300.0/360.0, 60.0/360.0};
ArrayList<Cloud> clouds;
int numClouds = 6;

ArrayList<float[]> hsvValues;

void setup() {
  size(800, 600, P3D);
  surface.setResizable(true);
  //fullScreen();
  frameRate(fps);
  
  keyboard = new KeyboardInput();
  //input = new KinectInput(this);

  hsvValues = new ArrayList<float[]>();
  flock = new Flock();
  big_flock = new Flock();
  
  boid_collisions = new ArrayList<ArrayList<Boid>>();
  boid_collisions.add(new ArrayList<Boid>());
  cwCollision = new ArrayList<Boolean>();
  cwCollision.add(false);
  
  int i;
  // Add an initial set of boids into the system
  for (i = 0; i < numSmall; i++) {
    flock.addBoid(new Boid(width/2, height/2, i, 10));
  }
  // Add an initial set of boids into the system
  for (i = numSmall; i < numSmall+numBig; i++) {
    big_flock.addBoid(new Boid(width/2, height/2, i, 20));
  }
  
  clouds = new ArrayList<Cloud>();
  for(int j=0; j<numClouds; j++)
    clouds.add(new Cloud());
  
  setupOsc();
  if(useTwitter) { setupTwitter(); }
  
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
  keyboard.keyDown(); 
}

void keyReleased() {
  keyboard.keyUp(); 
}

void draw() {
  //background(0, 30, 80);
  //Color backgroundColor = Color.getHSBColor(curBackground[0], curBackground[1], curBackground[2]);
  //background(backgroundColor.getRed(), backgroundColor.getGreen(), backgroundColor.getBlue());
  switchBackground();
  for(Cloud c: clouds)
    c.drawCloud();
  
  // check if there are no skeletons
  if (numSkeletons == 0) {
    keyboard.drawInput();
  }
  else {
    //input.drawInput();
  }
  fill(255, 255, 255);

  text(frameRate, 50, 50);
  text(curTweet, 50, 100);
  
  PVector loc = new PVector(mouseX, mouseY, 0);
  if (held) {
    flock.handForce(loc, -1);
  }
  
  
  flock.run();
  big_flock.run();
}