
class SvgPic {
  PVector position; // Position
  PVector shape; 
  PShape svg; // Image (here, a svg mask)
  PShape original_svg;
  float periodicity;

  SvgPic(String name, float posx, float posy, float period) {
    svg = loadShape(name);
    original_svg = svg;
    position = new PVector(posx,posy);
    shape = new PVector(svg.width, svg.height,1); 
    periodicity = period; // 500ms for now
  }
  
  void update_shape(){
    float scale;
    float half_periodicity = periodicity/2;
    float time = millis()%periodicity ; // 0<time<500 ; 2 times per seconds --> decreasing if sec < 250, 
    String c = "growing";

    if (time>half_periodicity){
      scale = pow(0.99,time/half_periodicity);
    }
    else { scale=(pow(0.99,(-periodicity+time)/(half_periodicity)));
    }
    if (time==0){Drum0.periodicity = drum_period;}
    //position.y = position.y - 2*shape.z;
    //position.x = position.x - (shape.x/shape.y)*shape.z;
    svg.scale(scale);
    }
  
  void display(){
    update_shape();
    shape(svg, position.x, position.y, shape.x, shape.y);
  }
}
