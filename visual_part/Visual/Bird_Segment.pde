// Each wing of a bird is a segment
// ParticleSystems stick to that segment

class Segment {
  PVector pos1; // Position (fixed)
  PVector pos2; // Position
  int L; // Sitck Length
  int side;  // -1 for left, 1 for right


  Segment(PVector position, int Side, int Length) {
      pos1 = position; 
      L = Length; //60
      side = Side; 
      pos2 = new PVector(pos1.x, pos1.y);
  }
  
  
  void update(){
    strokeWeight(4); 
    stroke(0);
    pos2 = new PVector(pos1.x + side*L*cos(theta-PI/6),pos1.y + L*sin(theta-PI/6));
    //line(pos1.x, pos1.y, pos2.x, pos2.y);
  }
  
}
