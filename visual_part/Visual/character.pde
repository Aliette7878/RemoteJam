class Character {

  private float size;


  private float centerX;
  private float centerY;

  private Body body;
  private Legs legs;
  private Arms arms;
  private Head head;

  private int dancingCode;
  private float dancingStep;
  private int dancingAmplitude;
  private float walkingStep;
  private int walkingAmplitude;
  private float walkingSpeed;
  private int stepSens;
  private int walkingDirection;
  private boolean dancing;

  private boolean aboutToJump;
  private boolean jumping;
  private float jumpingAmplitude;

  private int id;


  Character(float size_input, float speed, int centerYcoor) {
    size = size_input;

    centerX = int(random(0, width));
    centerY = centerYcoor - size/2;
    id = int(random(1, 10000));

    float memberProportion = random(0.97, 1.03);
    body = new Body(this, size/2);
    legs = new Legs(this, 0.38*size*memberProportion);
    arms = new Arms(this, 0.4*size*memberProportion);
    head = new Head(this, size*random(0.15, 0.19), size*random(0.18, 0.23));

    dancingCode = floor(random(1, 4));    // code = 1, 2 or 3
    dancingStep = 0;
    dancingAmplitude = 30;
    walkingStep = 0;
    stepSens = +1;
    walkingAmplitude = 30;
    walkingSpeed = speed;
    walkingDirection=floor(random(-1, +1));
    if (walkingDirection==0) {
      walkingDirection=1;
    }
    dancing = true;
    aboutToJump = false;
    jumping = false;
    jumpingAmplitude=1;
  }

  public void UpdateChar() {
    if (aboutToJump && dancing && abs(dancingStep)<1.5) {
      aboutToJump = false;
      jumping = true;
    }
    if (aboutToJump && !dancing && abs(walkingStep)<1.5) {
      aboutToJump = false;
      jumping = true;
    }
    if (jumping && dancing) {
      if (abs(dancingStep)<(dancingAmplitude/2-1)) {
        centerY-=jumpingAmplitude;
      } else if (abs(dancingStep)<dancingAmplitude) {
        centerY+=jumpingAmplitude;
      } else {
        jumping=false;
      }
    }
    if (jumping && !dancing) {
      if (abs(walkingStep)<(walkingAmplitude/2-1)) {
        centerY-=jumpingAmplitude;
      } else if (abs(walkingStep)<walkingAmplitude) {
        centerY+=jumpingAmplitude;
      } else {
        jumping=false;
      }
    }

    if (dancing) {
      centerX+=noise(id+frameCount/frameRate)-0.5;
      dancingStep+=2*stepSens*dancingAmplitude/frameRate;
      if (dancingStep>dancingAmplitude) {
        stepSens = -1;
      } else if (dancingStep<-dancingAmplitude) {
        stepSens= +1;
      }
    } else {
      walkingStep+=2*stepSens*walkingAmplitude*walkingSpeed/frameRate;
      if (walkingStep>walkingAmplitude) {
        stepSens = -1;
      } else if (walkingStep<-walkingAmplitude) {
        stepSens= +1;
      }
      centerX+=walkingDirection*walkingSpeed*100/frameRate;
    }
    body.updatePart();
    legs.updatePart();
    head.updatePart();
    arms.updatePart();
    if (centerX<-1000 || centerX > 2500) {
      walkingDirection*=-1;
    }
  }

  public void DrawCharacter() {
    ellipseMode (CENTER);
    rectMode (CENTER);
    strokeWeight(3);
    fill(0);


    body.display();
    legs.display();
    arms.display();
    head.display();
  }
  public void jump(float ampl) {
    aboutToJump = true;
    jumpingAmplitude = ampl;
  }
  public void setDancingAmplitude(int ampl) {
    dancingAmplitude = ampl;
  }
  public void setWalkingAmplitude(int ampl) {
    walkingAmplitude = ampl;
  }
  public void setWalkingSpeed(int ampl) {
    walkingSpeed = ampl;
  }
  public void startWalking() {
    dancing=false;
  }
  public void startDancing() {
    dancing=true;
  }
  public void switchWalkingDirection() {
    walkingDirection*=-1;
  }
  
}
