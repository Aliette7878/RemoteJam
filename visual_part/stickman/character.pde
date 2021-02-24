class Character {

  private int size;
  
  
  private int centerX;
  private int centerY;
  
  private Body body;
  private Legs legs;
  private Arms arms;
  private Head head;
  
  
  
  
  private float dancingStep;
  private int dancingAmplitude;
  private float walkingStep;
  private int walkingAmplitude;
  private float walkingSpeed;
  private int walkingStepSens;
  private int walkingDirection;
  private boolean dancing;


  Character(int maxspeed, int size_input) {
    size = size_input;
    
    centerX = int(random(0, width));
    centerY = 110;
    
    body = new Body(this, size/2);
    legs = new Legs(this, size/3);
    arms = new Arms(this, size/2);
    head = new Head(this, size/5);
    
    
    dancingStep = 0;
    dancingAmplitude = 30;
    walkingStep = 0;
    walkingStepSens = +1;
    walkingAmplitude = 30;
    walkingSpeed = (int)random(1,maxspeed);
    walkingDirection=floor(random(-1, +1));
    if (walkingDirection==0) {
      walkingDirection=1;
    }
    dancing = true;
  }

  public void UpdateChar() {

    if (dancing) {
      dancingStep+=2*dancingAmplitude/frameRate;
      dancingStep %= dancingAmplitude;
    } else {
      walkingStep+=2*walkingStepSens*walkingAmplitude*walkingSpeed/frameRate;
      if (walkingStep>walkingAmplitude) {
        walkingStepSens = -1;
      } else if (walkingStep<-walkingAmplitude) {
        walkingStepSens= +1;
      }
      centerX+=walkingDirection*walkingSpeed;
    }
    arms.updatePart();
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
}
