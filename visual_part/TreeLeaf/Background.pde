class Background{
  PImage bg, black;
  
  Background(){
    // Images
    bg = loadImage("bg-warli.png");
    bg.resize(width,height);
    
    //black = loadImage("black.png");
  }


void draw_background(){
  
  //Yellow background
  background(bg);
  
  //The sun
  // The transparency parameters and the stroke slow the thing a bit
  fill(255, 240, 0, 100);
  //noStroke();
  stroke(250, 200, 50, 80);
  strokeWeight(10);
  ellipse(width/2, height/2 + 200, 500, 500);
    
  //The black horizon
  fill(15,5,5);
  //stroke(200,250,200,15);
  //strokeWeight(14);
  rect(-20, 700, width + 40, 250);
  //image(black, 0, 600, width, 250);
}

}
