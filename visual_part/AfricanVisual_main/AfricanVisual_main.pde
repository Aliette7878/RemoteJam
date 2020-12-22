// Parameters linked to OSC messages //
// User 1 - continuous : angle of PTree0 = PTree0.angle (line 71-72-73) for now linked to the mouse, in [0-90°], or [20-70°] if you prefer the style
// User 2 - continuous : size of PTree0 = PTree.size (line 71) for now linked to the mouse, in [0 - 130], or [20-120], less weird

// Pattern A - yes/no : opacity of the GrowingArray = GrowingArray_yellow.opac; should be mapped in {60 ; 200} (line 69, example)
// Pattern B - yes/no : opacity of the GrowingArray = GrowingArray_white.opac; should be mapped in {60 ; 200}, 60=no, 200=yes
// Pattern C - yes/no : opacity of the GrowingArray = GrowingArray_green.opac; should be mapped in {60 ; 200}, 60=no, 200=yes


// Variables
PImage bg; 
PImage scrolling_img;
float drum_period=500;
SvgPic Drum0;
ScrollingObject ScrollingAfrican0, ScrollingAfrican1;
GrowingTree GrowingTree0;
ProcessingTree PTree0;                                 
GrowingArray GrowingArray_green,GrowingArray_white,GrowingArray_yellow ;

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
  GrowingArray_green = new GrowingArray(0, 100, 15, 50, PI/3, color(0,255,0), 60);  // (inx, iny, 15 trees, 50 pxls of distance, green, 255 opacity) 
  GrowingArray_white = new GrowingArray(100, 100, 15, 50, PI/3, color(255), 60);
  GrowingArray_yellow = new GrowingArray(200, 100, 15, 50, PI/3, color(255,255,0), 60);

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

  GrowingArray_green.display();
  GrowingArray_white.display();
  GrowingArray_yellow.display();

  Drum0.display();
  GrowingArray_white.opac=200;
  PTree0.angle =(mouseX / (float) width) * 90f;
  PTree0.size =(mouseY / (float) height) *130;
  PTree0.display(); // Careful to always display this tree at the very end (issues with translate(), will solve it later)
}
