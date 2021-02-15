class Character {

  private int horizontal_position;
  private int vertical_position;


  Character() {
    horizontal_position = int(random(0, width));
    vertical_position = 135;
  }
  
  public void UpdateChar(){
    
    horizontal_position+=5;
  }

  public void DrawCharacter() {
    ellipseMode (CENTER);
    rectMode (CENTER);

    //Head
    ellipse (horizontal_position, 60, 50, 50);
    point (horizontal_position-10, 60);
    point (horizontal_position+10, 60);


    //Body
    triangle (horizontal_position, vertical_position, horizontal_position+25, vertical_position-50, horizontal_position-25, vertical_position-50);
    triangle (horizontal_position, vertical_position, horizontal_position+25, vertical_position+50, horizontal_position-25, vertical_position+50);

    //Arms
    line (horizontal_position-25, 85, horizontal_position-50, 160);
    line (horizontal_position+25, 85, horizontal_position+50, 160);

    //Legs
    line (horizontal_position-10, 185, horizontal_position-20, 250);
    line (horizontal_position-20, 250, horizontal_position-25, 250);
    line (horizontal_position+10, 185, horizontal_position+20, 250);
    line (horizontal_position+20, 250, horizontal_position+25, 250);
  }
}
