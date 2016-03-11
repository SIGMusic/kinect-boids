float CHANGEBY = 1.0;
float SATURATION = 100.0;
float BRIGHTNESS = 60.0;
float CHANGE_THRESHOLD = 1.0;
float GAMMA_VALUE = 2.8; 

float[] getBackground() {
  while(hsvValues.size() > 10) {
    hsvValues.remove(0);
  }
  
  //float sum = 0;
  PVector sum = new PVector(0,0);
  if(!hsvValues.isEmpty()) {

     for (float[] f : hsvValues) {
       sum.add(cos(2*PI*f[0]), sin(2*PI*f[0]));
       //sum += f[0];
     }
     //sum/float(hsvValues.size())
     return new float[] {sum.heading()/(2*PI), 100.0/360.0, 60.0/360.0, sum.mag()};
  }
  return new float[] {0.0/360.0, SATURATION, BRIGHTNESS, 10.0};
}


// linear transition between colors
void switchBackground() {
  float[] newBackground = getBackground();
  if(newBackground[3] > CHANGE_THRESHOLD){
      if (newBackground[0] >= curBackground[0]) {
         curBackground[0] = ((curBackground[0] * 360.0 + CHANGEBY)%360)/360.0; 
      }
      else {
         curBackground[0] = ((curBackground[0] * 360.0 - CHANGEBY)%360)/360.0; 
      }
  }
  Color tempColor = Color.getHSBColor(curBackground[0], curBackground[1], curBackground[2]);

  background(tempColor.getRed(), tempColor.getGreen(), tempColor.getBlue());
  Color tempColor_lights = Color.getHSBColor(curBackground[0], curBackground[1], curBackground[2] + 30);
  
  if (frameCount % animationSpeedModulo < 1) {
    sendBackgroundOSC(tempColor_lights.getRed(), tempColor_lights.getGreen(), tempColor_lights.getBlue());
  }
}


void sendBackgroundOSC(int r, int g, int b) {
   OscMessage msg = new OscMessage("/background");
   // send colors
   msg.add(gamma(r));
   msg.add(gamma(g));
   msg.add(gamma(b));
   
   sendOSCMessage(msg); 
}

int gamma(float value) {
  return (int)(0.5 + 255.0 * pow(value/255.0, GAMMA_VALUE));
}