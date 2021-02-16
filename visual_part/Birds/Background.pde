class Background{
  PImage bg, sun, sun2, black;
  
  Background(){
    // Images
    bg = loadImage("bg-orange.jpg");
    bg.resize(width,height);
    
    sun = loadImage("sun.png");
    sun2 = loadImage("sun.png");
    
    black = loadImage("black.png");
  }




void draw_background(){
  
  //Yellow background
  background(bg);
  
  //----------------
  // -------- THE FOLLOWING LINES CHANGE THE SPEED OF THE ALGORITHM -------
  //------------------
  
  //The sun (two of them on top of each other)
  tint(255, 80); //transparency
  image(sun, width/2 - 375, height/2 + 50, 750, 500);
  image(sun2, width/2 - 375*0.9, height/2 + 50*1.4, 750*0.9, 500*0.9);
  
  //The black horizon
  tint(255);
  image(black, 0, 600, width, 250);
  } 

}
