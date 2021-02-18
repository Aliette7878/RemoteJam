float crook = 0.3;  // how twisted the branch will be
// we're working on a tree going for the left to the right for now
  
class branch {
  PVector start, end, mid;
  int L;
  
  branch(PVector startingPoint, int Length, int side){
    L = Length;
    float direction = PI/4*side;
    println(startingPoint);
    start = new PVector(int(startingPoint.x),int(startingPoint.y));
    end = new PVector(int(start.x+L*cos(direction)),int(start.y+L*sin(direction)));
    mid = new PVector(int((start.x+end.x)/2+ random(-crook*L,crook*L)),int((start.y+end.y)/2+ random(-crook*L,crook*L)));
  }
  
  void display(){

  noFill();
  stroke(255,10,10);
  beginShape();
  curveVertex(start.x,start.y); // the first control point
  curveVertex(start.x,start.y); // is also the start point of curve
  curveVertex(mid.x, mid.y); // the last point of curve
  curveVertex(end.x, end.y); // the last point of curve
  curveVertex(end.x, end.y); // is also the last control point
  endShape();
  }
}
