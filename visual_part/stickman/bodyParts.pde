class Body {

  public float size;

  private Character c;

  Body(Character character, float size_input) {
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

  private float size;

  private Character c;

  private float RhipX, RhipY;
  private float RkneeX, RkneeY;
  private float RheelX, RheelY;
  private float RfoottipX;
  private float LhipX, LhipY;
  private float LkneeX, LkneeY;
  private float LheelX, LheelY;
  private float LfoottipX;

  Legs(Character character, float size_input) {
    size = size_input;
    c = character;
    updatePart();
  }

  void updatePart() {
    float LthighsAngle;
    float LcalvesAngle;
    float RthighsAngle;
    float RcalvesAngle;
    if (c.dancing) {
      if (c.dancingStep<c.dancingAmplitude/2) {
        LthighsAngle = (PI/3)*c.dancingStep/c.dancingAmplitude;
        LcalvesAngle = 0;
        RthighsAngle = (PI/8);
        RcalvesAngle = 0;
      } else {
        LthighsAngle = (PI/8);
        LcalvesAngle = 0;
        RthighsAngle = (PI/3)*(c.dancingStep-c.dancingAmplitude/2)/c.dancingAmplitude;
        RcalvesAngle = 0;
      }
    } else {
      LthighsAngle = (PI/3)*c.walkingStep/c.walkingAmplitude;
      LcalvesAngle = (PI/5)*c.walkingStep/c.walkingAmplitude;
      RthighsAngle = (PI/3)*c.walkingStep/c.walkingAmplitude;
      RcalvesAngle = (PI/5)*c.walkingStep/c.walkingAmplitude;
    }
    RhipX = c.centerX - 0.1*size;
    RhipY = c.centerY + c.body.size/2;
    LhipX = c.centerX + 0.1*size;
    LhipY = c.centerY + c.body.size/2;

    RkneeX = RhipX - 0.5*size*sin(RthighsAngle);
    RkneeY = RhipY + 0.5*size*cos(RthighsAngle);
    LkneeX = LhipX + 0.5*size*sin(LthighsAngle);
    LkneeY = LhipY + 0.5*size*cos(LthighsAngle);

    RheelX = RkneeX - 0.5*size*sin(RcalvesAngle);
    RheelY = RkneeY + 0.5*size*cos(RcalvesAngle);
    LheelX = LkneeX + 0.5*size*sin(LcalvesAngle);
    LheelY = LkneeY + 0.5*size*cos(LcalvesAngle);

    if (c.dancing) {
      RfoottipX=RheelX - 0.1*size*cos(PI*c.dancingStep/c.dancingAmplitude);
      LfoottipX=LheelX + 0.1*size*cos(PI*c.dancingStep/c.dancingAmplitude);
    } else {
      RfoottipX=RheelX + c.walkingDirection*0.1*size;
      LfoottipX=LheelX + c.walkingDirection*0.1*size;
    }
  }

  void display() {
    //Legs
    line (RhipX, RhipY, RkneeX, RkneeY);
    line (LhipX, LhipY, LkneeX, LkneeY);
    line (RkneeX, RkneeY, RheelX, RheelY);
    line (LkneeX, LkneeY, LheelX, LheelY);
    //Feets
    line (RheelX, RheelY, RfoottipX, RheelY);
    line (LheelX, LheelY, LfoottipX, LheelY);
  }
}



class Arms {

  private float size;

  private Character c;
  private float RshoulderX, RshoulderY;
  private float RelbowX, RelbowY;
  private float RwristX, RwristY;
  private float LshoulderX, LshoulderY;
  private float LelbowX, LelbowY;
  private float LwristX, LwristY;

  Arms(Character character, float size_input) {
    size = size_input;
    c = character;
    updatePart();
  }

  void updatePart() {
    float armsAngle;
    float forearmsAngle;
    if (c.dancing) {
      armsAngle = -PI/8 + noise(frameCount)/4;
      forearmsAngle = PI+0.1 + (PI/2)*c.dancingStep/c.dancingAmplitude;
      RshoulderX = c.centerX-0.25*size; 
      LshoulderX = c.centerX+0.25*size;
    } else {
      armsAngle = (PI/4)*c.walkingStep/c.walkingAmplitude;
      forearmsAngle = 1.4*armsAngle;
      RshoulderX = c.centerX-0.15*size; 
      LshoulderX = c.centerX+0.15*size;
    }

    RshoulderY = c.centerY-0.5*size;
    LshoulderY = c.centerY-0.5*size;

    RelbowX = RshoulderX + 0.4*size*sin(armsAngle);
    RelbowY = RshoulderY + 0.4*size*cos(armsAngle);
    LelbowX = LshoulderX - 0.4*size*sin(armsAngle);
    LelbowY = LshoulderY + 0.4*size*cos(armsAngle);

    RwristX = RelbowX + 0.4*size*sin(forearmsAngle);
    RwristY = RelbowY + 0.4*size*cos(forearmsAngle);
    LwristX = LelbowX - 0.4*size*sin(forearmsAngle);
    LwristY = LelbowY + 0.4*size*cos(forearmsAngle);
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

  private float size;
  public float headX;
  public float headY;

  private Character c;

  Head(Character character, float size_input) {
    size = size_input;
    c = character;
    headY = c.centerY-0.78*c.body.size;
    headX = c.centerX;
  }
  void updatePart() {
    if (c.dancing) {
      headX = c.centerX + 4*cos((PI/2)+((c.dancingStep/c.dancingAmplitude)-0.5));
    } else {
      headX = c.centerX;
    }
  }

  void display() {
    //Head
    ellipse (headX, headY, 0.86*size, 0.9*size);
    //Neck
    line (headX, headY+size/2, c.centerX, headY+0.6*size);
  }
}
