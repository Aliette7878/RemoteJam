// Display the background 

class Background{
  PImage bg, black;
  PShape blackline;
  float r,g,b;
  

  Background(){
    // Images
    bg = loadImage("bg-warli.png");
    bg.resize(width,height);
    blackline = loadShape("powerpoint_line.svg");
    blackline.scale(1.2);
    blackline.disableStyle();
    r=220; g=40; b=40;
    
  }


void draw_background(){
  
  // Yellow background
  background(bg);
  
  // The sun
  if (level2){g=min(g*1.05,250); r = min(r*1.05, 250); b=min(b*1.05, 100);}
  fill(r, g, b, 100);
  stroke(250, 200, 50, 80);
  strokeWeight(10);
  ellipse(width/2, height/2 + 200, 500, 500);
    
  // The black horizon
  fill(30,15,15);
  shape(blackline,-40, 655);
  noStroke();
  //rect(-20, 700, width + 40, 250);
}


}
