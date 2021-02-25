class Body {

  public float size;

  private Character c;

  public float chestInclination;
  private float RshoulderX, RshoulderY;
  private float LshoulderX, LshoulderY;

  Body(Character character, float size_input) {
    size = size_input;
    c = character;
    chestInclination = 0;
    updatePart();
  }

  void updatePart() {
    if (c.dancing) {
      if (c.dancingCode==2) {
        chestInclination = (PI/8)*c.dancingStep/c.dancingAmplitude;
      }
      RshoulderX = c.centerX-0.5*size*sin((PI/6)+chestInclination);
      LshoulderX = c.centerX+0.5*size*sin((PI/6)-chestInclination);
      RshoulderY = c.centerY-0.5*size*cos((PI/6)+chestInclination);
      LshoulderY = c.centerY-0.5*size*cos((PI/6)-chestInclination);
    } else {
      RshoulderX = c.centerX-0.5*size*sin((PI/8)+chestInclination);
      LshoulderX = c.centerX+0.5*size*sin((PI/8)-chestInclination);
      RshoulderY = c.centerY-0.5*size*cos((PI/8)+chestInclination);
      LshoulderY = c.centerY-0.5*size*cos((PI/8)-chestInclination);
    }
  }

  void display() {
    if (c.dancing) {
      triangle (c.centerX, c.centerY, RshoulderX, RshoulderY, LshoulderX, LshoulderY);
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
      triangle (c.centerX, c.centerY, RshoulderX, RshoulderY, LshoulderX, LshoulderY);
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
      if (c.dancingStep<0) {
        LthighsAngle = -(PI/6)*c.dancingStep/c.dancingAmplitude;
        LcalvesAngle = 0;
        RthighsAngle = 0;
        RcalvesAngle = 0;
      } else {
        LthighsAngle = 0;
        LcalvesAngle = 0;
        RthighsAngle = (PI/6)*(c.dancingStep)/c.dancingAmplitude;
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
  private float RelbowX, RelbowY;
  private float RwristX, RwristY;
  private float LelbowX, LelbowY;
  private float LwristX, LwristY;

  Arms(Character character, float size_input) {
    size = size_input;
    c = character;
    updatePart();
  }

  void updatePart() {
    float armsAngle = c.body.chestInclination;
    float forearmsAngle = c.body.chestInclination;
    if (c.dancing) {
      if (c.dancingCode == 1) {
        armsAngle += PI/8 + noise(frameCount)/4;
        forearmsAngle += (PI/2) + (PI/2)*c.dancingStep/c.dancingAmplitude;
      } else {
        armsAngle += (PI/2) + (PI/2)*c.dancingStep/c.dancingAmplitude + noise(frameCount/4)/4;
        forearmsAngle += (PI/2) + (3*PI/4)*c.dancingStep/c.dancingAmplitude;
      }
    } else {
      armsAngle += (PI/4)*c.walkingStep/c.walkingAmplitude;
      forearmsAngle += 1.4*armsAngle;
    }


    RelbowX = c.body.RshoulderX - 0.4*size*sin(armsAngle);
    RelbowY = c.body.RshoulderY + 0.4*size*cos(armsAngle);
    LelbowX = c.body.LshoulderX + 0.4*size*sin(armsAngle);
    LelbowY = c.body.LshoulderY + 0.4*size*cos(armsAngle);

    RwristX = RelbowX - 0.4*size*sin(forearmsAngle);
    RwristY = RelbowY + 0.4*size*cos(forearmsAngle);
    LwristX = LelbowX + 0.4*size*sin(forearmsAngle);
    LwristY = LelbowY + 0.4*size*cos(forearmsAngle);
  }

  void display() {
    //Arms
    line (c.body.RshoulderX, c.body.RshoulderY, RelbowX, RelbowY);
    line (c.body.LshoulderX, c.body.LshoulderY, LelbowX, LelbowY);
    line (RelbowX, RelbowY, RwristX, RwristY);
    line (LelbowX, LelbowY, LwristX, LwristY);
  }
}



class Head {

  private float size;
  public float headX;
  public float headY;
  public float neckX;
  public float neckY;

  private Character c;

  Head(Character character, float size_input) {
    size = size_input;
    c = character;
    headX = c.centerX-0.75*c.body.size*sin(c.body.chestInclination);
    headY = c.centerY-0.75*c.body.size*cos(c.body.chestInclination);
    neckX = c.centerX-0.5*c.body.size*sin(c.body.chestInclination);
    neckY = c.centerY-0.5*c.body.size*cos(c.body.chestInclination);
  }
  void updatePart() {
    if (c.dancing) {
      headX = c.centerX-0.75*c.body.size*sin(c.body.chestInclination) + 4*cos((PI/2)+((c.dancingStep/c.dancingAmplitude)-0.5));
    } else {
      headX = c.centerX-0.75*c.body.size*sin(c.body.chestInclination);
    }
    headY = c.centerY-0.75*c.body.size*cos(c.body.chestInclination);
    neckX = c.centerX-0.5*c.body.size*sin(c.body.chestInclination);
    neckY = c.centerY-0.5*c.body.size*cos(c.body.chestInclination);
  }

  void display() {
    //Head
    ellipse (headX, headY, 0.86*size, 0.9*size);
    //Neck
    line (headX, headY, neckX, neckY);
  }
}
