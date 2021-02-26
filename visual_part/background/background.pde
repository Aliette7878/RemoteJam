import netP5.*;
import oscP5.*;

// Variables
PImage bg, black;
PShape blackline;

void setup() {
  frameRate(60); 
  size(1200,800); 
  
  // Images
  bg = loadImage("bg-warli.png");
  bg.resize(width,height);
  
  //black = loadImage("black.png");
  blackline = loadShape("powerpoint_line.svg");
  blackline.scale(1.5);
  blackline.disableStyle();

}


void draw(){
  
  draw_background();
  println(frameRate);
  
}

void draw_background(){
  
  //Yellow background
  background(bg);
  
  //The sun (two of them on top of each other)
  fill(255, 240, 0, 100);
  //noStroke();
  stroke(250, 200, 50, 80);
  strokeWeight(10);
  ellipse(width/2, height/2 + 200, 500, 500);
    
  //The black horizon
  
  fill(20,5,5);
    shape(blackline,-20, 650);
  //stroke(200,250,200,15);
  //strokeWeight(14);
  noStroke();
  rect(-20, 700, width + 40, 250);

  //image(black, 0, 600, width, 250);
}




/* //from the CMLS project, gradient just in case we need it

void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {

  noFill();

  if (axis == 1) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i+=2) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  }  
  else if (axis == 2) {  // Left to right gradient
    for (int i = x; i <= x+w; i+=2) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
}

 //in draw
  setGradient(20, percentY(85), 430, percentY(12), darkblue, sidePanColor, 2);
  setGradient(450, percentY(85), 430, percentY(12), sidePanColor, darkblue, 2);
*/
