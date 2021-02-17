leaf leaf1;

void setup() {
  size(1200,800); // Switch to full size ?
  frameRate(60); // default frameRate = 60/sec = 3600/min --> How to synchronize with supercollider ? 
  leaf1 = new leaf();
}

void draw(){
  background(255, 220,100);
  float angle = PI/6;
  leaf1.display(100,100, angle);
  }
