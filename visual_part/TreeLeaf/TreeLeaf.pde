leaf leaf1, l2, l3;
branch branch1, b2,b3, b4, b5;
Background bg ;


void setup() {
  size(1200,800); // Switch to full size ?
  frameRate(60); // default frameRate = 60/sec 
  bg  = new Background();
  
  branch1 = new branch(new PVector(0,40), 100, 1); // branch(x,y,length, side(-1 or 1) )
  b2 = new branch(branch1.end, 50, -1);
  b3 = new branch(branch1.end, 50, 1);
  b4 = new branch(b2.end, 30, 1);
  b5 = new branch(b2.end, 30, -1);

}

void draw(){
  bg.draw_background();
  
  branch1.display();
  branch1.grow();
  if (branch1.age>N_scale){  
    b2.start = branch1.end;
    b2.display();
    b2.grow();}
  if (b2.age>N_scale){  
    b3.start = branch1.end;
    b3.display();
    b3.grow();}
  }
