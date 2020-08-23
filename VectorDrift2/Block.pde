//cleaning up Block class
float rotational_noise=1;
float cohesion_coef=2*block_size;
float separate_coef=2*block_size;
float align_coef=3*block_size;

float maxSeparationForce=0.25;
float maxAlignmentForce=0.25;
float maxCohesionForce=0.25;
float maxOriginForce=0.25;

float separationWeight=1.5;
float alignmentWeight=1.0;
float cohesionWeight=1.0;

float maxspeed=2.5;

class Block {

  PVector origin;
  PVector location;
  PVector last_location;
  PVector velocity;
  PVector acceleration;

  int size_x = 0;
  int size_y = 0;

  Block(int _x, int _y, int _size_x, int _size_y) {
    origin = new PVector(_x, _y);
    location = new PVector(_x, _y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    size_x=_size_x;
    size_y=_size_y;
  }

  Block(int _x, int _y, int _size) {
    origin = new PVector(_x, _y);
    location = new PVector(_x, _y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    size_x=_size;
    size_y=_size;
  }

  void run( ArrayList<Block> _blocks) {
    flock(_blocks);
    update();
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Block> blocks) {

    PVector sep = separate(blocks);   // Separation
    PVector ali = align(blocks);      // Alignment
    PVector coh = cohesion(blocks);   // Cohesion

    // Weight these forces
    sep.mult(separationWeight);
    ali.mult(alignmentWeight);
    coh.mult(cohesionWeight);

    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
    applyForce(origin());
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // Method to update location
  void update() {
    last_location=location.copy();
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    velocity.rotate(random(-PI, PI) * rotational_noise);
    location.add(velocity);
    acceleration.mult(0);
    borders();
  }

  // Wraparound
  void borders() {
    location.x = (width + location.x) % width;
    location.y = (height + location.y) % height;
  }

  //////////////////////////////////////////////////////////////
  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, location);
    desired.setMag(maxspeed);
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxCohesionForce);
    return steer;
  }

  //////////////////////////////////////////////////////////////
  // Adds a springlike force to the origin

  PVector origin() {
    PVector force = PVector.sub(this.origin, this.location);
    force.setMag(PVector.dist(this.origin, this.location));
    force.limit(maxOriginForce);
    return force;
  }

  //////////////////////////////////////////////////////////////
  // Separation
  // Method checks for n`earby blocks and steers away

  PVector separate (ArrayList<Block> blocks) {
    float desiredseparation = separate_coef;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Block other : blocks) {

      float d = PVector.dist(location, other.location);

      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    if (count > 0) {
      steer.div((float)count); // Average
      steer.setMag(maxspeed);
      steer.sub(velocity);
      steer.limit(maxSeparationForce);
    } 
    return steer;
  }


  //////////////////////////////////////////////////////////////
  // Alignment
  // For every nearby boid in the system, calculate the average velocity

  PVector align (ArrayList<Block> blocks) {
    float neighbordist = align_coef;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Block other : blocks) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      sum.setMag(maxspeed);
      PVector steer = PVector.sub(sum, velocity); // Implement Reynolds: Steering = Desired - Velocity
      steer.limit(maxAlignmentForce);
      return steer;
    } else {
      return new PVector(0, 0);
    }
  }

  //////////////////////////////////////////////////////////////
  // Cohesion
  // For the average location (i.e. center) of all nearby blocks, calculate steering vector towards that location
  PVector cohesion (ArrayList<Block> blocks) {
    float neighbordist = cohesion_coef;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (Block other : blocks) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.location); // Add location
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      return seek(sum);  // Steer towards the location
    } else {
      return new PVector(0, 0);
    }
  }

  void display(PGraphics canvas) {
    canvas.beginDraw();
    canvas.stroke(255);
    canvas.strokeWeight(1);
    canvas.noFill();
    canvas.translate(location.x, location.y);
    canvas.rect(0, 0, size_x, size_y);
    canvas.endDraw();
  }
}
