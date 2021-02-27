class Character { //<>//

  private float centerX;
  private float centerY;

  private float headY;

  private int dancingStep;
  private int dancingAmplitude;
  public boolean dancing;

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
    centerY = 400;

    lowBody = new BodyPart(dataPath("sprites/body_low.svg"));
    lowBody.SetOriginalPosition(new PVector(centerX, centerY));
    float highBodyLag = 0.21*lowBody.w;
    highBody = new BodyPart(dataPath("sprites/body_high.svg"));
    highBody.SetOriginalPosition(new PVector(centerX+highBodyLag, centerY-highBody.h));
    head = new BodyPart(dataPath("sprites/head_and_neck.svg"));
    head.SetOriginalPosition(new PVector(centerX+highBodyLag, centerY-highBody.h-head.h));

    //arms
    leftArm = new BodyPart(dataPath("sprites/arm_left.svg"));
    leftArm.SetOriginalPosition(new PVector(centerX+0.67*highBody.w+highBodyLag, centerY-0.95*highBody.h));
    rightArm = new BodyPart(dataPath("sprites/arm_right.svg"));
    rightArm.SetOriginalPosition(new PVector(centerX-0.65*highBody.w+highBodyLag, centerY-0.97*highBody.h));
    leftForearm = new BodyPart(dataPath("sprites/forearm_left.svg"));
    leftForearm.SetOriginalPosition(new PVector(centerX+highBody.w/2+leftArm.w+highBodyLag, centerY-highBody.h+leftArm.h));
    rightForearm = new BodyPart(dataPath("sprites/forearm_right.svg"));
    rightForearm.SetOriginalPosition(new PVector(centerX-highBody.w/2-rightArm.w+highBodyLag, centerY-highBody.h+rightArm.h));

    //legs
    leftLeg = new BodyPart(dataPath("sprites/leg_left.svg"));
    leftLeg.SetOriginalPosition(new PVector(centerX+0.27*lowBody.w, centerY+lowBody.h));
    rightLeg = new BodyPart(dataPath("sprites/leg_right.svg"));
    rightLeg.SetOriginalPosition(new PVector(centerX-0.27*lowBody.w, centerY+0.98*lowBody.h));
    leftForeLeg = new BodyPart(dataPath("sprites/foreleg_left.svg"));
    leftForeLeg.SetOriginalPosition(new PVector(centerX+0.4*lowBody.w, centerY+lowBody.h+leftLeg.h));
    rightForeLeg = new BodyPart(dataPath("sprites/foreleg_right.svg"));
    rightForeLeg.SetOriginalPosition(new PVector(centerX-0.42*lowBody.w, centerY+lowBody.h+leftLeg.h));

    headY = 0;
    dancingStep = 0;
    dancingAmplitude = 40;
    dancing = true;

    //walkingStep = 0;
    //walkingStepSens = +1;
    //walkingAmplitude = 30;
    //walkingSpeed = (int)random(1,maxspeed);
    //walkingDirection=floor(random(-1, +1));
    //if (walkingDirection==0) {
    //  walkingDirection=1;
    //}
  }

  public void UpdateChar() {

    centerX+=0;
    headY+=0.15;
    if (headY>3) {
      headY=-2;
    }
    dancingStep+=1;
    dancingStep%=dancingAmplitude;

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

    if (dancing) {
      float horizontalUpperDrift;
      float armsAngle;
      float forearmsAngle;
      float cosArmsAngle;
      float cosForearmsAngle;
      if (dancingStep<20) {
        horizontalUpperDrift = (dancingStep-dancingAmplitude/4)/3;
        armsAngle = dancingStep/10.0;
      } else {
        horizontalUpperDrift = (40-dancingStep-dancingAmplitude/4)/3;
        armsAngle = (40-dancingStep)/10.0;
      }
      cosArmsAngle = cos(armsAngle+0.5);
      forearmsAngle = armsAngle*1.2;
      cosForearmsAngle = cos(forearmsAngle+0.5);

      //tronc
      lowBody.DrawBodyPart(0, 0, 0);
      highBody.DrawBodyPart(horizontalUpperDrift, 0, 0);
      head.DrawBodyPart(horizontalUpperDrift, headY, 0);

      //arms
      leftArm.DrawBodyPart(horizontalUpperDrift, leftArm.h*(cosArmsAngle-1)/2, -armsAngle);
      rightArm.DrawBodyPart(horizontalUpperDrift, rightArm.h*(cosArmsAngle-1)/2, armsAngle);
      leftForearm.DrawBodyPart(horizontalUpperDrift+leftArm.w*(1-cosForearmsAngle)/2, leftArm.h*(cosArmsAngle-1)+leftForearm.h*(cosArmsAngle-1)/2, -forearmsAngle);
      rightForearm.DrawBodyPart(horizontalUpperDrift-rightArm.w*(1-cosForearmsAngle)/2, rightArm.h*(cosArmsAngle-1)+rightForearm.h*(cosArmsAngle-1)/2, forearmsAngle);

      //legs
      leftLeg.DrawBodyPart(0, 0, 0);
      rightLeg.DrawBodyPart(0, 0, 0);
      leftForeLeg.DrawBodyPart(0, 0, 0);
      rightForeLeg.DrawBodyPart(0, 0, 0);
    } else {

      //tronc
      lowBody.DrawBodyPart(0, 0, 0);
      highBody.DrawBodyPart(0, 0, 0);
      head.DrawBodyPart(0, headY, 0);

      //arms
      leftArm.DrawBodyPart(0, 0, 0);
      rightArm.DrawBodyPart(0, 0, 0);
      leftForearm.DrawBodyPart(0, 0, 0);
      rightForearm.DrawBodyPart(0, 0, 0);

      //legs
      leftLeg.DrawBodyPart(0, 0, 0);
      rightLeg.DrawBodyPart(0, 0, 0);
      leftForeLeg.DrawBodyPart(0, 0, 0);
      rightForeLeg.DrawBodyPart(0, 0, 0);
    }
  }
}
