// Code for a leaf


//****DO NOT MODIFY BELOW****
String file_name = "tree-leaf.svg" ;
// A bit of math to understant what follow : 
// o We saw that when fps=60 and TimeLeave=12sec, we need step_s = 1.003
// o pow(step_s, N_scale) is the equivalent scaler for every fps, and this constant is also equal to step_s = pow(1.003, 60*12);
// o step_s = pow(pow(1.003, 60*12), 1/Nscale)
float global_s = 0.01; // first scaler applied to the svg file
int opacity = 100;

class leaf {
  PShape svg; // Image
  float s;
  int w, h; // Dimensions
  String colname;
  color col;
  int age;
  PVector position= new PVector(0,0);
  float angle = 0;
  boolean isfalling = false;
  int brightness = 255;
  float N_scale = fps*TimeLeaf; 
  float step_s = pow(pow(1.003, 60*12), 1/N_scale); // scaler applied at every iteration of the growth


  leaf(String colorName) {
    if (level2){s = 1.5*global_s;} else{s=global_s;}
    println(s);
    colname = colorName;
    svg = loadShape(file_name);
    svg.scale(s);
    w = int(svg.width*s); h = int(svg.height*s);
    if (colorName=="red"){this.col = color(int(random(150,255)),0,0, opacity);} // different variation of red
    if (colorName=="green"){this.col = color(0,int(random(50,150)),0, opacity);} // different variation of red
    if (colorName=="blue"){this.col = color(0,0,int(random(50,150)), opacity);} 
    age = 0;
    angle = random(-PI,PI);
  }
    
  void display(){
    if (level2){
      svg.setVisible(true);
    }
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
    else {N_scale = max(N_scale*0.95,TimeLeaf*fps); step_s = pow(pow(1.003, 60*12), 1/N_scale);}
    age++;
    if (level2){opacity=255; }
    else {opacity=100;}

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
    isfalling=false;
  }
}
