class StickLeft {
  PVector pos1; // Position (fixed)
  PVector pos2; // Position
  int L; // Sitck Length
  int side;  // -1 for left, 1 for right


  StickLeft(PVector position, int Side) {
      pos1 = position; 
      L = 230;
      side = Side; 
      pos2 = new PVector(pos1.x, pos1.y);
  }
  
  
  void display(){
    strokeWeight(4); 
    stroke(0);
    pos2 = new PVector(pos1.x + side*L*cos(theta+PI/12),pos1.y + L*sin(theta+PI/12));
    //line(pos1.x, pos1.y, pos2.x, pos2.y);
  }
  
}
