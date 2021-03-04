// Code for a leaf

// LEAF VARIABLES
float global_s = 0.008; // first scaler applied to the svg file
int opacity1 = 255, opacity2 = 255; // ** TO DO : to erase maybe ** opacity of the 1rst level & 2nd level
int TimeLeaf1 = 8, TimeLeaf2 = 3; // Number of seconds before a leaf is fully grown up, level1 & level2
float size2 = 1.5; // Size multiplicator for the leaf at level 2 
float colored = 1; // fully color : 1, not colored : 0
float dark = 0.3; // darkness of the leaves during darkmode
float darkopacity=180; // opacity of the leaves during darkmode

//****DO NOT MODIFY BELOW****
String file_name = "tree-leaf.svg" ;
int opacity = opacity1;
int TimeLeaf = TimeLeaf1;


class leaf {
  PShape svg; // Image
  float s;
  int w, h; // Dimensions
  String colname;
  color col;
  int age;
  PVector position= new PVector(0, 0);
  float angle = 0;
  boolean isfalling = false;
  float N_scale = fps*TimeLeaf; 
  float step_s = pow(pow(1.003, 60*12), 1/N_scale); // scaler applied at every iteration of the growth
  // A bit of math to understant what follow : 
  // o We saw that when fps=60 and TimeLeave=12sec, we need step_s = 1.003
  // o pow(step_s, N_scale) is the equivalent scaler for every fps, and this constant is also equal to step_s = pow(1.003, 60*12);
  // o step_s = pow(pow(1.003, 60*12), 1/Nscale)


  leaf(String colorName) {
    s = global_s;
    if (level2) {
      s = size2*global_s;
    }
    colname = colorName;
    svg = loadShape(file_name);
    svg.scale(s);
    w = int(svg.width*s); 
    h = int(svg.height*s);
    if (colorName=="red") {
      this.col = color(int(random(150, 255))*colored, 0, 0, opacity);
    } // different variation of red
    if (colorName=="green") {
      this.col = color(0, int(random(50, 150))*colored, 0, opacity);
    } // different variation of red
    if (colorName=="blue") {
      this.col = color(0, 0, int(random(50, 150))*colored, opacity);
    } 
    age = 0;
    angle = random(-PI, PI);
  }


  void display() {
    if (level2) {
      svg.setVisible(true);
    }
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle);
    svg.disableStyle();
    color col2 = col;
    if (darkmode) {
      col2 = color(red(this.col)*dark, green(this.col)*dark, blue(this.col)*dark, darkopacity);
    }
    fill(col2);
    shape(svg, -w/2, -h);
    popMatrix();
  }


  void grow() {
    if (age<N_scale && isfalling==false) {
      svg.scale(step_s);
      w = int(svg.width*s*pow(step_s, age)); 
      h = int(svg.height*s*pow(step_s, age));
    } else {
      N_scale = max(N_scale*0.95, TimeLeaf*fps); 
      step_s = pow(pow(1.003, 60*12), 1/N_scale);
    }
    age++;
  }


  void fall(float bias) { // we want to rotate vector(a,b) from -bias (cos*(a)-sin*(b), sin*(a)+cos*(b)): 
    float x = random(-2, 1); // b = 2;
    position.add(new PVector(cos(bias)*x-sin(-bias)*2, cos(-bias)*2+sin(-bias)*x));
    angle=angle+random(-PI/12, PI/12);
  }


  void reset() {
    svg = loadShape(file_name);
    svg.scale(s);
    w = int(svg.width*s); 
    h = int(svg.height*s);
    age=0;
    isfalling=false;
  }
}
