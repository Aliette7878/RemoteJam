// Provides the overall direction for the birds

class AttractionPoint {
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector noff ;

  AttractionPoint() {
    int x = int(random(100, width-100));
    int y = int(random(100, height-100));
    location = new PVector(x, y);
    noff = new PVector(random(1000), random(1000));
    velocity = new PVector();
    acceleration = new PVector();
  }

  void walk(boolean accelerationMode) {
    acceleration.x = map(noise(noff.x), 0, 1, -1, 1);
    acceleration.y = map(noise(noff.y), 0, 1, -1, 1);
    acceleration.mult(0.1);

    noff.add(0.01, 0.01, 0);

    velocity.add(acceleration);
    velocity.limit(0.8);
    if (accelerationMode==true) {
      velocity.mult(2);
    }
    location.add(velocity);

    location.y = constrain(location.y, 100, height-100);
    location.x = constrain(location.x, 100, width-100);
  }
}



class Walker {
  PVector location;
  PVector velocity;
  PVector acceleration;

  PVector noff;

  Walker() {
    int x = int(random(400, width-400));
    int y = int(random(300, height-300));
    location = new PVector(x, y);
    noff = new PVector(random(1000), random(1000));
    velocity = new PVector();
    acceleration = new PVector();
  }

  // Randomly move up, down, left, right, or stay in one place
  void walk(boolean accelerationMode) {
    acceleration.x += map(noise(noff.x), 0, 1, -1, 1);
    acceleration.y += map(noise(noff.y), 0, 1, -0.7, 1);
    acceleration.mult(0.005);

    noff.add(0.1, 0.1, 0);

    velocity.add(acceleration);
    velocity.limit(0.2);
    if (accelerationMode==true) {
      velocity.mult(3);
    }
    location.add(velocity);

    location.y = constrain(location.y, 100, height-100);
    location.x = constrain(location.x, 100, width-100);
    acceleration=new PVector(0, 0);
  }

  void applyAttraction(PVector pointAttraction) {
    acceleration.y += map(pointAttraction.y-location.y, -height, height, -2, 2);
    acceleration.x += map(pointAttraction.x-location.x, -width, width, -2, 2);
  }


  boolean outofscreen() {
    boolean B = true;
    if  ((location.x > -10) && (location.x < 10+width) && (location.y > -10) && (location.y<height-100)) {
      B=false;
    }
    return(B);
  }
}
