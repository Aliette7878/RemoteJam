float f = 0.3; // scale factor

class Spirals{
  ArrayList<PShape> list_spiral = new ArrayList<PShape>();
  PShape spiral_y;
  PShape spiral_g;
  PShape spiral_b;
  PShape spiral_r;
  
  Spirals(){
    list_spiral.add(loadShape("Spirale_yellow.svg"));
    list_spiral.add(loadShape("Spirale_green.svg"));
    list_spiral.add(loadShape("Spirale_blue.svg"));
    list_spiral.add(loadShape("Spirale_red.svg"));
  }
  
  void rescale(){
    for (int i = 0 ; i < list_spiral.size() ; i ++) {
      list_spiral.get(i).scale(f);
    }
  }

  void display(){
      for (int i = 0 ; i < list_spiral.size() ; i ++) {
      list_spiral.get(i).rotate(0.01*cos(2*PI*millis()*2/1000));
      shape( list_spiral.get(i), 200+i*70,600+i*5);

  }
  
  
}
}
