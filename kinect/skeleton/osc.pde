import oscP5.*;
import netP5.*;

float BPM = 120.0;

OscP5 oscP5;
ArrayList<NetAddress> addresses;
//OSCThread oscthread;

void setupOsc() {
  //oscthread = new OSCThread();

  oscP5 = new OscP5(this, 13371);
  addresses = new ArrayList<NetAddress>();
  addresses.add(new NetAddress("127.0.0.1", 9433));
  addresses.add(new NetAddress("127.0.0.1", 9434));
  addresses.add(new NetAddress("127.0.0.1", 9435));
  addresses.add(new NetAddress("127.0.0.1", 9436));

  //oscthread.start();
}

void sendOSCMessage(OscMessage message) {
  for (NetAddress address : addresses) {
    oscP5.send(message, address);
  }
}

//class OSCThread extends Thread {
//  public void run() {
//    while (true) {
//      // Send shapes
//      ArrayList<Boid> clonedShapes;
//      synchronized (shapes) {
//        clonedShapes =  (ArrayList<Shape>)shapes.clone();
//      }
//      for (Shape shape : clonedShapes) {
//        shape.sendOSC();
//      }
//      try { 
//        Thread.sleep(100L);
//      } 
//      catch (Exception e) {
//      }
//    }
//  }
//}