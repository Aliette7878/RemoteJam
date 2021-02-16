// Random Walker
// Daniel Shiffman <http://www.shiffman.net>
// The Nature of Code

class Walker {
  PVector location;
  PVector velocity;
  PVector acceleration;

  ArrayList<PVector> history;

  PVector noff;

  Walker() {
    int x = int(random(200, width-200));
    int y = int(random(200,height-200));
    location = new PVector(x,y);
    history = new ArrayList<PVector>();
    noff = new PVector(random(1000), random(1000));
    velocity = new PVector();
    acceleration = new PVector();
  }

  // Randomly move up, down, left, right, or stay in one place
  void walk() {
    acceleration.x = map(noise(noff.x), 0, 1, -0.7, 0.7);
    acceleration.y = map(noise(noff.y), 0, 1, -0.5, 1);
    acceleration.mult(0.005);

    noff.add(0,0.1, 0);

    velocity.add(acceleration);
    velocity.limit(0.3);
    if (mousePressed==true){velocity.mult(2);}
    location.add(velocity);

    history.add(location.get());
    if (history.size() > 1000) {
      history.remove(0);
    }
    
    location.y = constrain(location.y, 200, height-200);
  }
  
  boolean outofscreen(){
    boolean B = true;
    if  ((location.x > -10) && (location.x < 10+width) && (location.y > -10) && (location.y<height-100)) {B=false;}
    return(B);
  }
}
