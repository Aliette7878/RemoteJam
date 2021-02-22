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
      triangle (c.centerX, c.centerY, c.centerX+0.25*size, c.centerY+0.5*size, c.centerX-0.25*size, c.centerY+0.5*size);
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
        line (c.centerX-0.12*size-c.dancingStep, centerYLegs+size/2, c.centerX-0.2*size-c.dancingStep, centerYLegs+size/2);
        line (c.centerX+0.12*size-c.dancingStep, centerYLegs+size/2, c.centerX+0.2*size-c.dancingStep, centerYLegs+size/2);
      } else {

        //Legs
        line (c.centerX-0.1*size, centerYLegs-size/2, c.centerX-0.12*size, centerYLegs);
        line (c.centerX-0.12*size, centerYLegs, c.centerX-0.12*size, centerYLegs+size/2);

        line (c.centerX+0.1*size, centerYLegs-size/2, c.centerX+0.12*size+c.dancingStep-10, centerYLegs);
        line (c.centerX+0.12*size+c.dancingStep-10, centerYLegs, c.centerX+0.12*size+c.dancingStep-10, centerYLegs+size/2);

        //Feets
        line (c.centerX-0.12*size-c.dancingStep-10, centerYLegs+size/2, c.centerX-0.2*size-c.dancingStep-10, centerYLegs+size/2);
        line (c.centerX+0.12*size-c.dancingStep-10, centerYLegs+size/2, c.centerX+0.2*size-c.dancingStep-10, centerYLegs+size/2);
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

  Arms(Character character, int size_input) {
    size = size_input;
    c = character;
  }

  void display() {
    

    if (c.dancing) {


      //Arms
      line (c.centerX-0.25*size, c.centerY-0.5*size, c.centerX-0.4*size, c.centerY-0.15*size);
      line (c.centerX-0.4*size, c.centerY-0.15*size, c.centerX-0.5*size-c.dancingStep, c.centerY+0.25*size-c.dancingStep/2);

      line (c.centerX+0.25*size, c.centerY-0.5*size, c.centerX+0.4*size, c.centerY-0.15*size);
      line (c.centerX+0.4*size, c.centerY-0.15*size, c.centerX+0.5*size+c.dancingStep, c.centerY+0.25*size-c.dancingStep/2);
    } else {

      
      //Arms
      line (c.centerX-0.15*size, c.centerY-0.5*size, c.centerX-0.15*size+c.walkingStep/2, c.centerY-0.15*size);
      line (c.centerX-0.15*size+c.walkingStep/2, c.centerY-0.15*size, c.centerX-0.15*size+1.5*c.walkingStep, c.centerY+0.25*size+c.walkingStep/2);

      line (c.centerX+0.15*size, c.centerY-0.5*size, c.centerX+0.15*size-c.walkingStep/2, c.centerY-0.15*size);
      line (c.centerX+0.15*size-c.walkingStep/2, c.centerY-0.15*size, c.centerX+0.15*size-1.5*c.walkingStep, c.centerY+0.25*size+c.walkingStep/2);
    }
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
