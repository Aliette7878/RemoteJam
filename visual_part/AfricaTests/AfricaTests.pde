// Loading images
PImage bg; 
PShape MaskZulu;
PImage scrolling_img;

AfricanMask AfricanMask0, AfricanMask1, AfricanMask2; // 3 masks
ScrollingObject ScrollingAfrican0, ScrollingAfrican1; // 2 scrolling bars
GrowingTree GrowingTree0,GrowingTree1,GrowingTree2;   // 3 growingTrees
ProcessingTree Tree0;                                 // 1 ProcessingTree

void setup() {
  frameRate(200); // default frameRate = 60/sec = 3600/min --> How to synchronize with supercollider ? 
  size(1200,800); // Switch to full size ?
  
  // Load and resize images & SVG
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
  
  Tree0 = new ProcessingTree(new PVector(int(width/2),height)); // Inspired by a Processing tutorial
  
  GrowingTree0 = new GrowingTree(new PVector(0,int(height/2)),PI/3);
  GrowingTree1 = new GrowingTree(new PVector(0,int(height/2)+50),PI/3);
  GrowingTree2 = new GrowingTree(new PVector(0,int(height/2)-50),PI/3);

}


void draw(){
  background(bg);
  ScrollingAfrican1.scroll();
  ScrollingAfrican0.scroll();
  AfricanMask0.display();
  AfricanMask1.display();
  AfricanMask2.display();
 
  GrowingTree0.display();  // We can create an array of GrowingTree
  GrowingTree1.display();
  GrowingTree2.display();
  Tree0.display(); 

}
 
 
