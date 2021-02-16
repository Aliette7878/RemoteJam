import netP5.*;
import oscP5.*;

// Variables
PImage bg, sun, sun2, black;

void setup() {
  frameRate(60); 
  size(1200,800); 
  
  // Images
  bg = loadImage("bg-warli.png");
  bg.resize(width,height);
  
  sun = loadImage("sun.png");
  sun2 = loadImage("sun.png");
  
  black = loadImage("black.png");
  
  //Bluring filters
  bg.filter(BLUR, 1);
  sun.filter(BLUR, 1);
  sun2.filter(BLUR, 1);
  black.filter(BLUR, 1);

}


void draw(){
  
  draw_background();
  
}

void draw_background(){
  
  //Yellow background
  background(bg);
  
  //The sun (two of them on top of each other)
  tint(255, 80); //transparency
  image(sun, width/2 - 375, height/2 + 50, 750, 500);
  image(sun2, width/2 - 375*0.9, height/2 + 50*1.4, 750*0.9, 500*0.9);
  
  //The black horizon
  tint(255);
  image(black, 0, 600, width, 250);
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
