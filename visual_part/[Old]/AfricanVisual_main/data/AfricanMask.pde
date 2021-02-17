
class AfricanMask {
  PVector position; // Position
  PShape svg; // Image (here, a svg mask)
  int id;
  PVector shape; 

  AfricanMask(int identifier) {
    svg = loadShape("AfrikanMask.svg");
    svg.scale(0.6); 
    id = identifier;
    position = new PVector(id*300+200,200);
    shape = new PVector(svg.width, svg.height,1);
  }
  
  void update_shape(){
    if (frameCount%30 == 0){
      shape.z = shape.z*(-1);
    }
    shape.y = shape.z * 2 + shape.y;
    position.y = position.y - 2*shape.z;
    position.x = position.x - (shape.x/shape.y)*shape.z;
    svg.scale(exp(0+shape.z*0.01));
    }
  
  void display(){
    update_shape();
    shape(svg, position.x, position.y, shape.x, shape.y);
  }
  
}
