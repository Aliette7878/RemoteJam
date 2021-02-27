// Display the background 

class Background{
  PImage bg, black;
  PShape blackline;

  Background(){
    // Images
    bg = loadImage("bg-warli.png");
    bg.resize(width,height);
    blackline = loadShape("powerpoint_line.svg");
    blackline.scale(1.5);
    blackline.disableStyle();
  }


void draw_background(){
  
  // Yellow background
  background(bg);
  
  // The sun
  fill(255, 240, 0, 100);
  stroke(250, 200, 50, 80);
  strokeWeight(10);
  ellipse(width/2, height/2 + 200, 500, 500);
    
  // The black horizon
  fill(20,5,5);
  shape(blackline,-20, 650);
  noStroke();
  //rect(-20, 700, width + 40, 250);
}


}
