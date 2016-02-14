// The Flock (a list of Boid objects)

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids

  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
  }

  void run() {
    for (Boid b : boids) {
      b.run(boids);  // Passing the entire list of boids to each boid individually
      
      input.collision(b);
    }
  }

  void handForce(PVector target, int dir) {
    for (Boid b : boids) {
      b.applyForce(PVector.mult(b.avoid(new PVector(target.x,target.y,target.z),true),50*dir)); 
    }
  }
  
  void addBoid(Boid b) {
    boids.add(b);
  }

}

// The Boid class

class Boid implements Comparable<Boid> {

  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  
  float red;
  float green;
  float blue;

  int id;
  int whichFrame;
  boolean animationDirectionForward; //used to animated in a smooth manner

  // used as a time buffer 
  boolean isColliding;
  
  // used for comparison
  float x1, y1, x2, y2;

  Boid(float x, float y, int id, int r) {
    acceleration = new PVector(0, 0);

    // This is a new PVector method not yet implemented in JS
    // velocity = PVector.random2D();

    // Leaving the code temporarily this way so that this example runs in JS
    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));

    location = new PVector(x, y);
    this.r = r;
    maxspeed = 3;
    maxforce = 0.2;
    this.id = id;
    isColliding = false;
    whichFrame = int(random(6));
    animationDirectionForward = true; //
    
    red = 0;
    green = 0;
    blue = 0;
    while(red<1 && green<1 && blue<1)
    {
      red   = int(random(2)) * 255.0;
      green = int(random(2)) * 255.0;
      blue  = int(random(2)) * 255.0;
    }
  }
  
  @Override
  public int compareTo(Boid b) {
    return (int)((y2-y1)*(location.y-b.location.y)+(x2-x1)*(location.x-b.location.x)); //<>//
  }
  
  public void compareInit(float _x1, float _y1, float _x2, float _y2){
    x1 = _x1;
    y1 = _y1;
    x2 = _x2;
    y2 = _y2;
  }

  void run(ArrayList<Boid> boids) {
    
    update();
    borders();
    render();
    flock(boids);
    
    
    //walls
    //acceleration.add(PVector.mult(avoid(new PVector(location.x,height,location.z),true),5));
    //acceleration.add(PVector.mult(avoid(new PVector(location.x,0,location.z),true),5));
    //acceleration.add(PVector.mult(avoid(new PVector(width,location.y,location.z),true),5));
    //acceleration.add(PVector.mult(avoid(new PVector(0,location.y,location.z),true),5));

    
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Boid> boids) {
    PVector sep = separate(boids);   // Separation
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
    // Arbitrarily weight these forces
    sep.mult(3.0);
    ali.mult(2.0);
    coh.mult(1.0);
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }

  // Method to update location
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
    
    // tells us which frame to draw for animating a boid
    if(frameCount % animationSpeedModulo < 1) { 
      if(animationDirectionForward) { whichFrame++; }
      else { whichFrame--; }
    }
    
    if (whichFrame >= 5) {
       animationDirectionForward = false;
    }
    if (whichFrame <= 0) {
       animationDirectionForward = true; 
    }
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, location);  // A vector pointing from the location to the target
    // Scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);

    // Above two lines of code below could be condensed with new PVector setMag() method
    // Not using this method until Processing.js catches up
    // desired.setMag(maxspeed);

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }

  void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    // heading2D() above is now heading() but leaving old syntax until Processing.js catches up
    
    fill(red, green, blue, 100);
    strokeWeight(1);
    stroke(red, green, blue);
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    
    beginShape();

    vertex(0, 0);
    vertex(-r/(6-whichFrame), r);
    vertex(0, r/1.8);
    vertex(r/(6-whichFrame), r);  
     
    endShape(CLOSE);
    popMatrix();
  }
  
  // returns how similar two colors are centered at 0
  // negative is more similar
  private float getColorDiff(Boid other){
    /*float dist = -1.0;
    if(abs(red - other.red)>1)
      dist+=0.5;
    if(abs(green - other.green)>1)
      dist+=0.5;
    if(abs(blue - other.blue)>1)
      dist+=0.5;
    if(dist>-0.6)
      dist+=0.5;*/
    float dist = -1.0;
    if(abs(red - other.red)>1)
      dist=1.0;
    if(abs(green - other.green)>1)
      dist=1.0;
    if(abs(blue - other.blue)>1)
      dist=1.0;
    return dist;
  }

  // Wraparound
  void borders() {
    if (location.x < -r) location.x = width+r;
    if (location.y < -r) location.y = height+r;
    if (location.x > width+r) location.x = -r;
    if (location.y > height+r) location.y = -r;
  }
  
  //avoid. If weight == true avoidance vector is larger the closer the boid is to the target
  PVector avoid(PVector target,boolean weight)
  {
    PVector steer = new PVector(); //creates vector for steering
    steer.set(PVector.sub(location,target)); //steering vector points away from target
    if(weight)
      steer.mult(1/sq(PVector.dist(location,target)));
    //steer.limit(maxSteerForce); //limits the steering force to maxSteerForce
    return steer;
  }


  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Boid> boids) {
    // separation based on size
    float desiredseparation = 4f*(r-5);
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);        // Weight by distance
        diff.mult(0.8 + getColorDiff(other)*0.5);        // Weight by color
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // steer.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Boid> boids) {
    float neighbordist = 40;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbordist)) {
        PVector vel = PVector.mult(other.velocity, 0.7 - getColorDiff(other)*0.5);     // Weight by color
        sum.add(vel);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // sum.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } 
    else {
      return new PVector(0, 0);
    }
  }

  // Cohesion
  // For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
  PVector cohesion (ArrayList<Boid> boids) {
    float neighbordist = 40;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbordist)) {
        // draw lines to show which boids are in the same flock
        if(showFlockLines){
          stroke(100, 100);
          line(location.x, location.y, other.location.x, other.location.y);
        }
        sum.add(other.location); // Add location

        PVector loc = PVector.mult(other.location, 1.0);// - getColorDiff(other)*0.5);     // Weight by color
        
        sum.add(loc); // Add location

        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the location
    } 
    else {
      return new PVector(0, 0);
    }
  }
  
  boolean checkCollision(float x1, float y1, float x2, float y2) {
    float d1 = dist(location.x, location.y, x1, y1);
    float d2 = dist(location.x, location.y, x2, y2);
    
    float linelen = dist(x1, y1, x2, y2);
    
    float tolerance = 1;
    
    if(d1 + d2 >= linelen - tolerance && d1 + d2 <= linelen + tolerance && !isColliding) {
      // if first collision determine if clockwise or counter clockwise with respect to the first point
      if(boid_collisions.isEmpty()){
        cwCollision = ((x1-x2)*(location.y-y1) < (y1-y2)*(location.x-x1));
      }
      isColliding = true;
      boid_collisions.add(this);
      return true; 
    }
    if(!(d1 + d2 >= linelen - tolerance && d1 + d2 <= linelen + tolerance) && isColliding) {
      boid_collisions.remove(this);
      isColliding = false;
    }
    
    return false;
  }
  
}