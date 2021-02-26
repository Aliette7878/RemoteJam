float theta;
BirdArray Birds ;


void setup() {
  frameRate(60); 
  size(1200,800);
  Birds = new BirdArray();
}


void draw(){
  bg.draw_background();
  println(frameRate);
  theta = theta(frameCount); // theta in [-0.5,0]; 
  if (random(1)<0.007){Birds.addBird();}
  if (mousePressed && (random(1)<0.01)){Birds.addBird();}
  Birds.display();
  Birds.deleteBird();
}


// Update of theta - the angle for the wings
float theta(int N){
  float theta = -abs(cos(N*0.02))*0.5;
  if (mousePressed){theta = -abs(cos(N*0.04))*0.5;}
  return(theta);
}
