
class Segment {
  float x0;
  float y0;
  float x1;
  float y1;
  ArrayList<Segment> children = new ArrayList<Segment>();
  int age;
  
  Segment(float x_start, float y_start, float x_dest, float y_dest) {
    x0 = x_start;
    y0 = y_start;
    x1 = x_dest;
    y1 = y_dest;
    age = 0;
  }
  
  void display(){
  stroke(255,200-age);
  strokeWeight(2); 
  line(x0,y0,x1,y1);
  age++;
  }
  
}
