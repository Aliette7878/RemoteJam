PImage bg;
PShape MaskZulu;
PImage scrolling_img;
ScrollingObject ScrollingAfrican0;
ScrollingObject ScrollingAfrican1;
AfricanMask AfricanMask0;
AfricanMask AfricanMask1;
AfricanMask AfricanMask2;
WhiteLines Tree0;
float theta;   

void setup() {
  frameRate(60); // default frameRate = 60/sec = 3600/min
  size(1200,800); // Switch to full size ?
  
  // Load and resize images or SVG
  bg = loadImage("bg1.png");
  bg.resize(width,height);
  MaskZulu = loadShape("Zulu.svg");
  MaskZulu.scale(0.2);
  AfricanMask0 = new AfricanMask(0);
  AfricanMask1 = new AfricanMask(1);
  AfricanMask2 = new AfricanMask(2);

  scrolling_img = loadImage("frise1.png");
  scrolling_img.resize(width, int(height/10));
  
  // Scrolling bars
  ScrollingAfrican1 = new ScrollingObject(scrolling_img, 1, 0,0);
  ScrollingAfrican0 = new ScrollingObject(scrolling_img, 0, 0, height-scrolling_img.height);
  
  Tree0 = new WhiteLines(new PVector(int(width/2),height)); // Inspired by processing tutorial


}


void draw(){
  background(bg);
  ScrollingAfrican1.scroll();
  ScrollingAfrican0.scroll();
  AfricanMask0.display();
  AfricanMask1.display();
  AfricanMask2.display();
  
  Tree0.display();  
}
 
 
