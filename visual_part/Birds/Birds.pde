float theta;
BirdArray Birds ;

void setup() {
  frameRate(60); 
  size(1200,800);
  Birds = new BirdArray();
  Birds.addBird();
  

}


void draw(){
  background(255,165,0);
  theta = theta(frameCount); // theta in [-0.5,0];  
  Birds.display();
  Birds.deleteBird();
  if (random(1)<0.008){Birds.addBird();}

}



// Update of theta - to synchronise with sound rythm ?
float theta(int N){
  return (-abs(cos(N*0.02))*0.5);
}
