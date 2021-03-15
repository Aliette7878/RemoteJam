// Display the background 

class Background {
  PImage bg, black;
  PShape blackline;
  float r, g, b;
  float sunStep, sunDirection, sunAmplitude=30;
  float darkTransparency;


  Background() {
    // Images
    bg = loadImage("bg-warli.png");
    bg.resize(width, height);
    blackline = loadShape("powerpoint_line.svg");
    blackline.scale(1.2);
    blackline.disableStyle();
    r = 220; 
    g = 40; 
    b = 40;
    sunStep = 0;
    sunDirection = +0.25;
    darkTransparency = 0;
  }


  void draw_background() {

    // Yellow background
    background(bg);

    // The sun
    if (level2) {
      r = min(r*1.02, 250); 
      g = min(g*1.02, 250); 
      b = min(b*1.02, 100);
    }
    if (darkmode) {
      r *= 0.9; 
      g *= 0.9; 
      b *= 0.9;
      darkTransparency+=5;
    } else {
      r = 220; 
      g = 40; 
      b = 40;
      darkTransparency=0;
    }
    fill(r, g, b, 100);
    stroke(250, 200, 50, 80);
    strokeWeight(10);
    ellipse(width/2, height/2 + 250, 500+sunStep, 500+sunStep);

    sunStep+=sunDirection;
    if (abs(sunStep)>sunAmplitude) {
      sunDirection*=-1;
    }

    // The black horizon
    fill(30, 15, 15);
    shape(blackline, -40, 703);
    noStroke();
    //

    if (darkmode) {
      fill(10, 10, 10, min(55, darkTransparency));
      rect(0, 0, 3000, 3000);
    }
  }
}
