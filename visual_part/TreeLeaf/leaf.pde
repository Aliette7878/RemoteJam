// Why is this class cool ? 
// Because with "translate" and "rotate", we're able to command exactly the position & orientation of the leave


String file_name = "tree-leaf.svg" ;
float s = 0.01; // first scaler for the svg file
float N_scale = frameRate*12 ; // number of rescaling before staying at the same size (here 12sec)
float step_s = 1.003; // scaler applied at each step of the growth


class leaf {
  PShape svg; // Image
  int w, h; // Dimensions
  color col;
  int age;

  leaf() {
    svg = loadShape(file_name);
    svg.scale(s);
    w = int(svg.width*s); h = int(svg.height*s);
    this.col = color(int(random(100,200)),0,0); // different variation of red
    age = 0;
  }
    
  void display(PVector position, float angle){
    pushMatrix();
        grow();
    translate(position.x, position.y);
    rotate(angle);
    svg.disableStyle();
    fill(this.col);
    shape(svg,-w/2,-h);
    popMatrix();
  }
  
  void grow(){
    if (age<N_scale) {
      svg.scale(step_s);
      w = int(svg.width*s*pow(step_s,age)); h = int(svg.height*s*pow(step_s,age));
    } // if born less than 5sec ago
    age++;
  }
}
