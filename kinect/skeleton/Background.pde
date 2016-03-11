float CHANGEBY = 5.0;
float SATURATION = 100.0;
float BRIGHTNESS = 60.0;

float[] getBackground() {
  if (hsvValues.size() > 50) {
    hsvValues.remove(0);
  }
  
  float sum = 0;
  if(!hsvValues.isEmpty()) {

     for (float[] f : hsvValues) {
       sum += f[0];
     }

     return new float[] {sum/float(hsvValues.size()), 100.0/360.0, 60.0/360.0};
  }
  return new float[] {0.0/360.0, SATURATION, BRIGHTNESS};
}


// linear transition between colors
void switchBackground() {
  float[] newBackground = getBackground();
  if (newBackground[0] >= curBackground[0]) {
     curBackground[0] = ((curBackground[0] * 360.0 + CHANGEBY)%360)/360.0; 
  }
  else {
     curBackground[0] = ((curBackground[0] * 360.0 - CHANGEBY)%360)/360.0; 
  }
  Color tempColor = Color.getHSBColor(curBackground[0], curBackground[1], curBackground[2]);

  background(tempColor.getRed(), tempColor.getGreen(), tempColor.getBlue());
  
  if (frameCount % animationSpeedModulo < 1) {
    sendBackgroundOSC(tempColor.getRed(), tempColor.getGreen(), tempColor.getBlue());
  }
}


void sendBackgroundOSC(int r, int g, int b) {
   OscMessage msg = new OscMessage("/background");
   // send colors
   msg.add(r);
   msg.add(g);
   msg.add(b);
   
   sendOSCMessage(msg); 
}