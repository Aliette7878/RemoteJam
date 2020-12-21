
class PngPic {
  PImage png;
  PVector position;
  PVector shape;
  int periodicity;

  PngPic(String name, float posx, float posy) {
    png = loadImage(name);
    position = new PVector(posx,posy);
    periodicity = 500; // 500ms for now
    shape = new PVector(png.width, png.height);
  }
  
  void update_scale(){
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
    png.resize(int(shape.x*scale),int(shape.y*scale));
    }
  
  void display(){
    update_scale();
    image(png, position.x, position.y);
  }
  
}
