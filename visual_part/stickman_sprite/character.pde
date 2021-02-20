class Character { //<>//

  private int centerX;
  private int centerY;

  BodyPart leftLeg;
  BodyPart rightLeg;
  BodyPart leftForeLeg;
  BodyPart rightForeLeg;
  BodyPart lowBody;
  BodyPart highBody;
  BodyPart head;
  BodyPart leftForearm;
  BodyPart rightForearm;
  BodyPart leftArm;
  BodyPart rightArm;

  Character() {
    centerX = int(random(width/10, 9*width/10));
    centerY = 600;

    leftLeg = new BodyPart(dataPath("sprites/leg_left.svg"));
    rightLeg = new BodyPart(dataPath("sprites/leg_right.svg"));
    leftForeLeg = new BodyPart(dataPath("sprites/foreleg_left.svg"));
    rightForeLeg = new BodyPart(dataPath("sprites/foreleg_right.svg"));
    lowBody = new BodyPart(dataPath("sprites/body_low.svg"));
    highBody = new BodyPart(dataPath("sprites/body_high.svg"));
    head = new BodyPart(dataPath("sprites/head_and_neck.svg"));
    leftForearm = new BodyPart(dataPath("sprites/forearm_left.svg"));
    rightForearm = new BodyPart(dataPath("sprites/forearm_right.svg"));
    leftArm = new BodyPart(dataPath("sprites/arm_left.svg"));
    rightArm = new BodyPart(dataPath("sprites/arm_right.svg"));

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

    centerX+=0.2;

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
    leftLeg.DrawBodyPart(new PVector(centerX, centerY), 0, 0.5);
    rightLeg.DrawBodyPart(new PVector(centerX, centerY), 0, 0.5);
    leftForeLeg.DrawBodyPart(new PVector(centerX, centerY), 0, 0.5);
    rightForeLeg.DrawBodyPart(new PVector(centerX, centerY), 0, 0.5);
    lowBody.DrawBodyPart(new PVector(centerX, centerY), 0, 0.5);
    highBody.DrawBodyPart(new PVector(centerX, centerY), 0, 0.5);
    head.DrawBodyPart(new PVector(centerX, centerY), 0, 0.5);
    leftForearm.DrawBodyPart(new PVector(centerX, centerY), 0, 0.5);
    rightForearm.DrawBodyPart(new PVector(centerX, centerY), 0, 0.5);
    leftArm.DrawBodyPart(new PVector(centerX, centerY), 0, 0.5);
    rightArm.DrawBodyPart(new PVector(centerX, centerY), 0, 0.5);

  }
}
