// Bird array
int lastTimeShake = 0;


class BirdArray {
  ArrayList<Bird> birds;
  AttractionPoint AttractionPoint;
  boolean accelerationMode = false;
  float Pbird=PbirdLvl1;

  BirdArray() {
    this.birds = new ArrayList<Bird>();
    AttractionPoint =  new AttractionPoint();
    addBird();
  }

  void display() {
    if (level2) {
      Pbird=PbirdLvl2;
    } else {
      Pbird=PbirdLvl1;
    }

    if (accelerationMode && millis()-lastTimeShake>shakingDuration) {
      accelerationMode=false;
    }

    // Bird creation
    theta = theta(frameCount, accelerationMode);  
    if (random(1)<Pbird && this.birds.size()<maxNumberOfBirds) {
      addBird();
    }
    if (accelerationMode && (random(1)<0.03)) {
      addBird();
    }
    deleteBird(); // delete birds out of scope
    Bird b;
    AttractionPoint.walk(accelerationMode);

    for (int i=this.birds.size()-1; i>=0; i--) {
      b=this.birds.get(i);
      b.Walker.applyAttraction(AttractionPoint.location);
      b.display(accelerationMode);
    }
  }

  void addBird() {
    this.birds.add(new Bird());
  }
  
  void accelerate(int time0) {
    accelerationMode=true;
    lastTimeShake = time0;
  }

  void deleteBird() {
    Bird b;
    for (int i=this.birds.size()-1; i>=0; i--) {
      b=this.birds.get(i);
      if ((b.Walker.outofscreen())||(b.N<5)) {
        birds.remove(i);
      }
    }
  }
}

// Update of theta - the angle for the wings
float theta(int N, boolean accelerationMode) {
  float theta = -abs(cos(N*f1))*0.5;
  if (accelerationMode) {
    theta = -abs(cos(N*f2))*0.5;
  }
  return(theta);
}
