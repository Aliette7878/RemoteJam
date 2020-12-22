
class Segment {
  float x0;
  float y0;
  float x1;
  float y1;
  ArrayList<Segment> children = new ArrayList<Segment>();
  int age;
  color col;
  int opac; // between 0 and 255
  
  Segment(float x_start, float y_start, float x_dest, float y_dest, color color_seg, int opacity) {
    x0 = x_start;
    y0 = y_start;
    x1 = x_dest;
    y1 = y_dest;
    age = 0;
    col = color_seg;
    opac = opacity;
  }
  
  void display(){
  stroke(col,opac-age*2);
  strokeWeight(2); 
  line(x0,y0,x1,y1);
  age++;
  }
  
}
