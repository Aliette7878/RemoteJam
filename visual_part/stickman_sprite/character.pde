class Character {

  private int centerX;
  private int centerY;
  //private float headY;
  //private float dancingStep;
  //private int dancingAmplitude;
  //private float walkingStep;
  //private int walkingAmplitude;
  //private float walkingSpeed;
  //private int walkingStepSens;
  //private int walkingDirection;
  //private boolean dancing;


  Character() {
    centerX = int(random(0, width));
    centerY = 135;

    //headY = 60;
    //dancingStep = 0;
    //dancingAmplitude = 30;
    //walkingStep = 0;
    //walkingStepSens = +1;
    //walkingAmplitude = 30;
    //walkingSpeed = (int)random(1,maxspeed);
    //walkingDirection=floor(random(-1, +1));
    //if (walkingDirection==0) {
    //  walkingDirection=1;
    //}
    //dancing = true;
  }

  public void UpdateChar() {

    centerX+=1;

    //if (dancing) {
    //  dancingStep+=dancingAmplitude/20.0;
    //  dancingStep %= dancingAmplitude;
    //  headY = 60-dancingStep/4;
    //} else {
    //  walkingStep+=walkingStepSens*walkingAmplitude*walkingSpeed/20;
    //  if (walkingStep>walkingAmplitude) {
    //    walkingStepSens = -1;
    //  } else if (walkingStep<-walkingAmplitude) {
    //    walkingStepSens= +1;
    //  }
    //  headY = 60-walkingStep/6;
    //  centerX+=walkingDirection*walkingSpeed;
    //}
  }

  public void DrawCharacter() {
    BodyPart trying1 = new BodyPart(dataPath("sprites/Stickman_full.svg"));
    trying1.DrawBodyPart(new PVector(centerX,centerY), 0, 0.1);
  }
}
