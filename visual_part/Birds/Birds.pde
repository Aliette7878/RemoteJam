float theta;
BirdArray Birds ;
Background bg ;

void setup() {
  frameRate(60); 
  size(1200,800);
  Birds = new BirdArray();
  bg  = new Background();

}


void draw(){
  bg.draw_background();
  theta = theta(frameCount); // theta in [-0.5,0]; 
  if (random(1)<0.01){Birds.addBird();}
  Birds.display();
  Birds.deleteBird();
  println(frameRate);
}



// Update of theta - to synchronise with sound rythm ?
float theta(int N){
  return (-abs(cos(N*0.02))*0.5);
}
