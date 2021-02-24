class Body {

  public int size;

  private Character c;

  Body(Character character, int size_input) {
    size = size_input;
    c = character;
  }

  void display() {
    if (c.dancing) {
      triangle (c.centerX, c.centerY, c.centerX+0.25*size, c.centerY-0.5*size, c.centerX-0.25*size, c.centerY-0.5*size);
      //triangle (c.centerX, c.centerY, c.centerX+0.25*size, c.centerY+0.5*size, c.centerX-0.25*size, c.centerY+0.5*size);
      fill(255);
      beginShape(TRIANGLE_STRIP);

      vertex(c.centerX+0.525*size/2, c.centerY+size/2);
      vertex(c.centerX, c.centerY);
      vertex(c.centerX-0.525*size/2, c.centerY+size/2);

      vertex(c.centerX-0.525*size/2, c.centerY+size/2);
      vertex(c.centerX-0.35*size/2, c.centerY+0.6*size/2);
      vertex(c.centerX-0.175*size/2, c.centerY+size/2);
      vertex(c.centerX, c.centerY+0.6*size/2);
      vertex(c.centerX+0.175*size/2, c.centerY+size/2);
      vertex(c.centerX+0.35*size/2, c.centerY+0.6*size/2);
      vertex(c.centerX+0.525*size/2, c.centerY+size/2);
      endShape();
      fill(0);
    } else {
      triangle (c.centerX, c.centerY, c.centerX+0.22*size, c.centerY-0.5*size, c.centerX-0.22*size, c.centerY-0.5*size);
      triangle (c.centerX, c.centerY, c.centerX+0.2*size, c.centerY+0.5*size, c.centerX-0.2*size, c.centerY+0.5*size);
    }
  }
}



class Legs {

  private int size;
  private int centerYLegs;

  private Character c;

  Legs(Character character, int size_input) {
    size = size_input;
    c = character;
    centerYLegs = c.centerY + c.body.size/2+size/2;
  }

  void display() {
    if (c.dancing) {

      if (c.dancingStep<10) {

        //Legs
        line (c.centerX-0.1*size, centerYLegs-size/2, c.centerX-0.12*size-c.dancingStep, centerYLegs);
        line (c.centerX-0.12*size-c.dancingStep, centerYLegs, c.centerX-0.12*size-c.dancingStep, centerYLegs+size/2);

        line (c.centerX+0.1*size, centerYLegs-size/2, c.centerX+0.12*size, centerYLegs);
        line (c.centerX+0.12*size, centerYLegs, c.centerX+0.12*size, centerYLegs+size/2);

        //Feets
        line (c.centerX-0.12*size-c.dancingStep/2, centerYLegs+size/2, c.centerX-0.2*size-c.dancingStep/2, centerYLegs+size/2);
        line (c.centerX+0.12*size-c.dancingStep/2, centerYLegs+size/2, c.centerX+0.2*size-c.dancingStep/2, centerYLegs+size/2);
      } else {

        //Legs
        line (c.centerX-0.1*size, centerYLegs-size/2, c.centerX-0.12*size, centerYLegs);
        line (c.centerX-0.12*size, centerYLegs, c.centerX-0.12*size, centerYLegs+size/2);

        line (c.centerX+0.1*size, centerYLegs-size/2, c.centerX+0.12*size+c.dancingStep-10, centerYLegs);
        line (c.centerX+0.12*size+c.dancingStep-10, centerYLegs, c.centerX+0.12*size+c.dancingStep-10, centerYLegs+size/2);

        //Feets
        line (c.centerX-0.12*size+c.dancingStep/2-5, centerYLegs+size/2, c.centerX-0.2*size+c.dancingStep/2-5, centerYLegs+size/2);
        line (c.centerX+0.12*size+c.dancingStep/2-5, centerYLegs+size/2, c.centerX+0.2*size+c.dancingStep/2-5, centerYLegs+size/2);
      }
    } else {



      //Legs
      line (c.centerX-0.1*size, centerYLegs-size/2, c.centerX-0.12*size-c.walkingStep/2, centerYLegs);
      line (c.centerX-0.12*size-c.walkingStep/2, centerYLegs, c.centerX-0.12*size-c.walkingStep, centerYLegs+size/2);

      line (c.centerX+0.1*size, centerYLegs-size/2, c.centerX+0.12*size+c.walkingStep/2, centerYLegs);
      line (c.centerX+0.12*size+c.walkingStep/2, centerYLegs, c.centerX+0.12*size+c.walkingStep, centerYLegs+size/2);



      //Feets
      line (c.centerX-0.12*size-c.walkingStep, centerYLegs+size/2, c.centerX-0.2*size-c.walkingStep+c.walkingDirection*5, centerYLegs+size/2);
      line (c.centerX+0.12*size+c.walkingStep, centerYLegs+size/2, c.centerX+0.2*size+c.walkingStep+c.walkingDirection*5, centerYLegs+size/2);
    }
  }
}



class Arms {

  private int size;

  private Character c;
  private float RshoulderX, RshoulderY;
  private float RelbowX, RelbowY;
  private float RwristX, RwristY;
  private float LshoulderX, LshoulderY;
  private float LelbowX, LelbowY;
  private float LwristX, LwristY;

  Arms(Character character, int size_input) {
    size = size_input;
    c = character;
    updatePart();
  }

  void updatePart() {

    if (c.dancing) {
      float armsAngle = (PI/2)*c.dancingStep/c.dancingAmplitude;
      RshoulderX = c.centerX-0.25*size; 
      RshoulderY = c.centerY-0.5*size;
      LshoulderX = c.centerX+0.25*size; 
      LshoulderY = c.centerY-0.5*size;

      RelbowX = c.centerX-0.4*size + noise(4); 
      RelbowY = c.centerY-0.15*size;
      LelbowX = c.centerX+0.4*size + noise(4); 
      LelbowY = c.centerY-0.15*size;

      RwristX = RelbowX - 0.4*size*sin(armsAngle+0.1);
      RwristY = RelbowY - 0.4*size*cos(armsAngle+0.1);
      LwristX = LelbowX + 0.4*size*sin(armsAngle+0.1);
      LwristY = LelbowY - 0.4*size*cos(armsAngle+0.1);
    } else {
      float armsAngle = (PI/4)*c.walkingStep/c.walkingAmplitude;
      RshoulderX = c.centerX-0.15*size; 
      RshoulderY = c.centerY-0.5*size;
      LshoulderX = c.centerX+0.15*size; 
      LshoulderY = c.centerY-0.5*size;


      RelbowX = RshoulderX + 0.4*size*sin(armsAngle);
      RelbowY = RshoulderY + 0.4*size*cos(armsAngle);
      LelbowX = LshoulderX - 0.4*size*sin(armsAngle);
      LelbowY = LshoulderY + 0.4*size*cos(armsAngle);

      RwristX = RelbowX + 0.4*size*sin(1.4*armsAngle);
      RwristY = RelbowY + 0.4*size*cos(1.4*armsAngle);
      LwristX = LelbowX - 0.4*size*sin(1.4*armsAngle);
      LwristY = LelbowY + 0.4*size*cos(1.4*armsAngle);
    }
  }

  void display() {
    //Arms
    line (RshoulderX, RshoulderY, RelbowX, RelbowY);
    line (LshoulderX, LshoulderY, LelbowX, LelbowY);
    line (RelbowX, RelbowY, RwristX, RwristY);
    line (LelbowX, LelbowY, LwristX, LwristY);
  }
}



class Head {

  private int size;

  public float headY;

  private Character c;

  Head(Character character, int size_input) {
    size = size_input;
    c = character;
    headY = c.centerY-0.74*c.body.size;
  }

  void display() {


    //Head
    ellipse (c.centerX, headY, 0.86*size, 0.9*size);

    //Neck
    line (c.centerX, headY+size/2, c.centerX, headY+0.6*size);
  }
}
