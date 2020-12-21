
class SvgPic {
  PVector position; // Position
  PVector shape; 
  PShape svg; // Image (here, a svg mask)
  int periodicity;

  SvgPic(String name, float posx, float posy) {
    svg = loadShape(name);
    position = new PVector(posx,posy);
    shape = new PVector(svg.width, svg.height,1); 
    periodicity = 500; // 500ms for now
  }
  
  void update_shape(){
    float scale;
    int half_periodicity = int(periodicity/2);
    int time = millis()%periodicity ; // 0<time<500 ; 2 times per seconds --> decreasing if sec < 250, 
    if (time>half_periodicity){
      scale = pow(0.99,time/half_periodicity);      
    }
    else { scale=(pow(0.99,(-periodicity+time)/(half_periodicity)));
    }
    //position.y = position.y - 2*shape.z;
    //position.x = position.x - (shape.x/shape.y)*shape.z;
    svg.scale(scale);
    }
  
  void display(){
    update_shape();
    shape(svg, position.x, position.y, shape.x, shape.y);
  }
  
}
