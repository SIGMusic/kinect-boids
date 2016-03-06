float[] getBackground() {
  if (hsvValues.size() > 50) {
    hsvValues.remove(0);
  }
  
  float sum = 0;
  if(!hsvValues.isEmpty()) {
     for (float[] f : hsvValues) {
       sum += f[0];
     }
     return new float[] {sum/hsvValues.size(), 175.0, 255.0};
  }
  return new float[] {0.0, 0.0, 0.0};
}

void switchBackground(Color target) {
  
}