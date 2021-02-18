// Why is this class cool ? 
// Because with "translate" and "rotate", we're able to command exactly the position & orientation of the leave

String file_name = "tree-leaf.svg" ;
float s = 0.08; //scaler for the svg file
color col = color(255,10,10);

class leaf {
  PShape svg; // Image
  int w, h; // Dimensions

  leaf() {
    svg = loadShape(file_name);
    svg.scale(s);
    w = int(svg.width*s); h = int(svg.height*s);
  }
    
  void display(PVector position, float angle){
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle);
    svg.disableStyle();
    fill(col);
    shape(svg,-w/2,-h);
    popMatrix();
  }
}
