class Character {

  private float size;
  
  
  private float centerX;
  private float centerY;
  
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
  
  private int id;


  Character(int maxspeed, float size_input) {
    size = size_input;
    
    centerX = int(random(0, width));
    centerY = 110;
    id = int(random(1,10000));
    
    body = new Body(this, size/2);
    legs = new Legs(this, 0.38*size);
    arms = new Arms(this, 0.45*size);
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
      centerX+=noise(id+frameCount/10)-0.5;
      dancingStep+=2*dancingAmplitude/frameRate;
      dancingStep %= dancingAmplitude;
    } else {
      walkingStep+=2*walkingStepSens*walkingAmplitude*walkingSpeed/frameRate;
      if (walkingStep>walkingAmplitude) {
        walkingStepSens = -1;
      } else if (walkingStep<-walkingAmplitude) {
        walkingStepSens= +1;
      }
      centerX+=walkingDirection*walkingSpeed*100/frameRate;
    }
    arms.updatePart();
    legs.updatePart();
    head.updatePart();
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
