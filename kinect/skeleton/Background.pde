float CHANGEBY = 1.0;
float SATURATION = 100.0;
float BRIGHTNESS = 60.0;
float CHANGE_THRESHOLD = 1.0;

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
}