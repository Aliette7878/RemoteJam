//****DO NOT MODIFY BELOW****
String file_name = "tree-leaf.svg" ;
// A bit of math to understant what follow : 
// o We saw that when fps=60 and TimeLeave=12sec, we need step_s = 1.003
// o pow(step_s, N_scale) is the equivalent scaler for every fps, and this constant is also equal to step_s = pow(1.003, 60*12);
// o step_s = pow(pow(1.003, 60*12), 1/Nscale)
float N_scale = fps*TimeLeaf; 
float s = 0.012; // first scaler applied to the svg file
float step_s = pow(pow(1.003, 60*12), 1/N_scale); // scaler applied at every iteration of the growth


class leaf {
  PShape svg; // Image
  int w, h; // Dimensions
  String colname;
  color col;
  int age;
  PVector position= new PVector(0,0);
  float angle = 0;
  boolean isfalling = false;

  leaf(String colorName) {
    colname = colorName;
    svg = loadShape(file_name);
    svg.scale(s);
    w = int(svg.width*s); h = int(svg.height*s);
    if (colorName=="red"){this.col = color(int(random(150,255)),0,0);} // different variation of red
    if (colorName=="green"){this.col = color(0,int(random(50,150)),0);} // different variation of red
    if (colorName=="blue"){this.col = color(0,0,int(random(50,150)));} 
    age = 0;
    angle = random(-PI,PI);
  }
    
  void display(){
    pushMatrix();
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
    }
    age++;
  }
  
  void fall(float bias){ // we want to rotate vector(a,b) from -bias (cos*(a)-sin*(b), sin*(a)+cos*(b)): 
        float x = random(-2,1); // b = 2;
        position.add(new PVector(cos(bias)*x-sin(-bias)*2,cos(-bias)*2+sin(-bias)*x));
        angle=angle+random(-PI/12,PI/12);
    }
    
  void reset(){
    svg = loadShape(file_name);
    svg.scale(s);
    w = int(svg.width*s); h = int(svg.height*s);
    age=0;
    svg.setVisible(true);
    isfalling=false;
  }
}