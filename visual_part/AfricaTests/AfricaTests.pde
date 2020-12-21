// Parametered linked to OSC messages //
// User 1 - continuous : angle of PTree0 = PTree0.angle (line 65) for now linked to the mouse, in [0-90°]
// User 2 - continuous : size of PTree0 = PTree.size (line 66) for now linked to the mouse, in [0 - 130]


// Variables
PImage bg; 
PImage scrolling_img;
float drum_period=500;
SvgPic Drum0;
ScrollingObject ScrollingAfrican0, ScrollingAfrican1;
GrowingTree GrowingTree0;
ProcessingTree PTree0;                                 
GrowingArray GrowingArray_right0,GrowingArray_right1,GrowingArray_right2 ;

// OSC setup
import netP5.*;
import oscP5.*;

OscP5 oscP5;
NetAddress Location;


void setup() {
  frameRate(200); // default frameRate = 60/sec = 3600/min --> How to synchronize with supercollider ? 
  size(1200,800); // Switch to full size ?
  
  oscP5 = new OscP5(this, 7400);
  
  // Images
  bg = loadImage("bgforms.jpg"); // Can also try Savane1 or Savane2
  bg.resize(width,height);
  scrolling_img = loadImage("frise1.png");
  scrolling_img.resize(width, int(height/10));
  
  // Scrolling bars
  ScrollingAfrican1 = new ScrollingObject(scrolling_img, 1, 0,0);
  ScrollingAfrican0 = new ScrollingObject(scrolling_img, 0, 0, height-scrolling_img.height);
  
  // Arrays of trees
  GrowingArray_right0 = new GrowingArray(0, 100, 15, 50, PI/3, color(0,255,0), 255);  // (inx, iny, 15 trees, 50 pxls of distance, green, 255 opacity) 
  GrowingArray_right1 = new GrowingArray(100, 100, 15, 50, PI/3, color(255), 100);
  GrowingArray_right2 = new GrowingArray(200, 100, 15, 50, PI/3, color(255,255,0), 20);

  // Drum
  Drum0 = new SvgPic("DrumRed2.svg",440,700, drum_period);
  Drum0.svg.scale(1.1);
  Drum0.svg.rotate(-PI/2);
  
  // Processing Tree
  PTree0 = new ProcessingTree(new PVector(width-220,height-82)); // Inspired by a Processing tutorial
  
}


void draw(){
  
  background(bg);
  
  ScrollingAfrican1.scroll();
  ScrollingAfrican0.scroll(); 

  GrowingArray_right0.display();
  GrowingArray_right1.display();
  GrowingArray_right2.display();
  
  Drum0.display();
  
  PTree0.angle =(mouseX / (float) width) * 90f;
  PTree0.size =(mouseY / (float) height) *130;
  PTree0.display(); // Careful to always display this tree at the very end (issues with translate(), will solve it later)
}
