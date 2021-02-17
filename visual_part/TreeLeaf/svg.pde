// Why is this class cool ? 
// Because with "translate" and "rotate", we're able to command exactly the position & orientation of the leave


String file_name = "tree-leaf.svg" ;
float s = 0.1; //scaler for the svg file

class leaf {
  PVector position; // Position
  PShape svg; // Image
  int w, h; // Dimensions

  leaf() {
    svg = loadShape(file_name);
    svg.scale(s);
    position = new PVector(0,0);
    w = int(svg.width*s); h = int(svg.height*s);
  }
    
  void display(int x, int y, float angle){
    pushMatrix();
    translate(x, y);
    rotate(angle);
    shape(svg,-leaf1.w/2,-leaf1.h);
    popMatrix();
  }
}
