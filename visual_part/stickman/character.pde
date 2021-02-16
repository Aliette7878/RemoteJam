class Character {

  private int centerX;
  private int centerY;
  private float headY;
  private float dancingStep;
  private int dancingAmplitude;
  private float walkingStep;
  private int walkingAmplitude;
  private float walkingSpeed;
  private int walkingStepSens;
  private int walkingDirection;
  private boolean dancing;


  Character(int maxspeed) {
    centerX = int(random(0, width));
    centerY = 135;
    headY = 60;
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
      dancingStep+=dancingAmplitude/20.0;
      dancingStep %= dancingAmplitude;
      headY = 60-dancingStep/4;
    } else {
      walkingStep+=walkingStepSens*walkingAmplitude*walkingSpeed/20;
      if (walkingStep>walkingAmplitude) {
        walkingStepSens = -1;
      } else if (walkingStep<-walkingAmplitude) {
        walkingStepSens= +1;
      }
      headY = 60-walkingStep/6;
      centerX+=walkingDirection*walkingSpeed;
    }
  }

  public void DrawCharacter() {
    ellipseMode (CENTER);
    rectMode (CENTER);
    strokeWeight(3);

    //Head
    fill(0);
    ellipse (centerX, headY, 38, 40);

    //Neck
    line (centerX, headY+22, centerX, centerY-50);



    if (dancing) {

      //Body
      triangle (centerX, centerY, centerX+25, centerY-50, centerX-25, centerY-50);
      triangle (centerX, centerY, centerX+25, centerY+50, centerX-25, centerY+50);

      //Arms
      line (centerX-25, centerY-50, centerX-40, centerY-15);
      line (centerX-40, centerY-15, centerX-50-dancingStep, centerY+25-dancingStep/2);

      line (centerX+25, centerY-50, centerX+40, centerY-15);
      line (centerX+40, centerY-15, centerX+50+dancingStep, centerY+25-dancingStep/2);

      if (dancingStep<10) {

        //Legs
        line (centerX-10, centerY+50, centerX-20-dancingStep, centerY+80);
        line (centerX-20-dancingStep, centerY+80, centerX-20-dancingStep, centerY+115);

        line (centerX+10, centerY+50, centerX+20, centerY+80);
        line (centerX+20, centerY+80, centerX+20, centerY+115);

        //Feets
        line (centerX-20-dancingStep, centerY+115, centerX-25-dancingStep, centerY+115);
        line (centerX+20-dancingStep, centerY+115, centerX+25-dancingStep, centerY+115);
      } else {

        //Legs
        line (centerX-10, centerY+50, centerX-20, centerY+80);
        line (centerX-20, centerY+80, centerX-20, centerY+115);

        line (centerX+10, centerY+50, centerX+20+dancingStep-10, centerY+80);
        line (centerX+20+dancingStep-10, centerY+80, centerX+20+dancingStep-10, centerY+115);

        //Feets
        line (centerX-20+dancingStep-10, centerY+115, centerX-25+dancingStep-10, centerY+115);
        line (centerX+20+dancingStep-10, centerY+115, centerX+25+dancingStep-10, centerY+115);
      }
    } else {

      //Body
      triangle (centerX, centerY, centerX+15, centerY-50, centerX-15, centerY-50);
      triangle (centerX, centerY, centerX+20, centerY+50, centerX-20, centerY+50);
      
      //Arms
      line (centerX-15, centerY-50, centerX-15+walkingStep/2, centerY-15);
      line (centerX-15+walkingStep/2, centerY-15, centerX-15+1.5*walkingStep, centerY+25+walkingStep/2);

      line (centerX+15, centerY-50, centerX+15-walkingStep/2, centerY-15);
      line (centerX+15-walkingStep/2, centerY-15, centerX+15-1.5*walkingStep, centerY+25+walkingStep/2);

      //Legs
      line (centerX-10, centerY+50, centerX-20-walkingStep/2, centerY+80);
      line (centerX-20-walkingStep/2, centerY+80, centerX-20-walkingStep, centerY+115);

      line (centerX+10, centerY+50, centerX+20+walkingStep/2, centerY+80);
      line (centerX+20+walkingStep/2, centerY+80, centerX+20+walkingStep, centerY+115);

      //Feets
      line (centerX-20-walkingStep, centerY+115, centerX-20-walkingStep+walkingDirection*5, centerY+115);
      line (centerX+20+walkingStep, centerY+115, centerX+20+walkingStep+walkingDirection*5, centerY+115);
    }
  }
}
