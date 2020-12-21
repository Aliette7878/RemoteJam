PImage bg; 
PShape MaskZulu;
PImage scrolling_img;

SvgPic Drum0;
ScrollingObject ScrollingAfrican0, ScrollingAfrican1; // 2 scrolling bars
GrowingTree GrowingTree0;   // 3 growingTrees
ProcessingTree Tree0;                                 // 1 ProcessingTree
GrowingArray GrowingArray_right0,GrowingArray_right1,GrowingArray_right2 ;
Spirals Spirals0;

void setup() {
  frameRate(200); // default frameRate = 60/sec = 3600/min --> How to synchronize with supercollider ? 
  size(1200,800); // Switch to full size ?
  
  // Images
  bg = loadImage("bgforms.jpg"); // Can also try Savane1 or Savane2
  bg.resize(width,height);
  scrolling_img = loadImage("frise1.png");
  scrolling_img.resize(width, int(height/10));
  
  
  // Scrolling bars
  ScrollingAfrican1 = new ScrollingObject(scrolling_img, 1, 0,0);
  ScrollingAfrican0 = new ScrollingObject(scrolling_img, 0, 0, height-scrolling_img.height);
  
  Tree0 = new ProcessingTree(new PVector(int(width/2),height)); // Inspired by a Processing tutorial
  
  GrowingTree0 = new GrowingTree(new PVector(width-10,int(height/2)),4*PI/3, color(255,0,0));
  GrowingArray_right0 = new GrowingArray(0, 100, 15, 50, PI/3, color(0,255,0)); // (inx, iny, 15 trees, 50 pxls of distance) 
  GrowingArray_right1 = new GrowingArray(100, 100, 15, 50, PI/3, color(255)); // (inx, iny, 15 trees, 50 pxls of distance) 
  GrowingArray_right2 = new GrowingArray(200, 100, 15, 50, PI/3, color(255,255,0)); // (inx, iny, 15 trees, 50 pxls of distance) 

  Drum0 = new SvgPic("DrumRed2.svg",450,700);
  Drum0.svg.scale(1.1);
  Drum0.svg.rotate(-PI/2);

}


void draw(){
  background(bg);
 
  GrowingTree0.display();  // We can create an array of GrowingTree
  //GrowingTree1.display();
  //GrowingTree2.display();
  GrowingArray_right0.display();
  GrowingArray_right1.display();
  GrowingArray_right2.display();

  ScrollingAfrican1.scroll();
  ScrollingAfrican0.scroll();
  Drum0.display();

}
