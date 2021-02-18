leaf leaf1;
branch branch1, b2,b3, b4, b5;

void setup() {
  size(1200,800); // Switch to full size ?
  frameRate(60); // default frameRate = 60/sec = 3600/min --> How to synchronize with supercollider ? 
  leaf1 = new leaf();
  branch1 = new branch(new PVector(0,40), 100, 1); // branch(x,y,length, side(-1 or 1) )
  b2 = new branch(branch1.end, 50, -1);
  b3 = new branch(branch1.end, 50, 1);
  b4 = new branch(b2.end, 30, 1);
  b5 = new branch(b2.end, 30, -1);

}

void draw(){
  background(255, 220,100);
  float angle = PI/6;
  branch1.display();
  b2.display();
  b3.display();
  b4.display();
  b5.display();
  leaf1.display(b3.end, angle);
  leaf1.display(b2.mid, PI/2);
  leaf1.display(b4.end, PI/4);
  
  }
