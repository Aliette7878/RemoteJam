float theta;
BirdArray Birds ;
Background bg ;
tree redTree, greenTree, blueTree;


void setup() {
  frameRate(60); 
  size(1200,800);
  Birds = new BirdArray();
  bg  = new Background();
  redTree = new tree(new PVector(0,80),PI/8, "red"); // l'arbre va entre PI/2 et -PI/2
  greenTree = new tree(new PVector(width,80),PI/2+PI/4, "green"); // l'arbre va entre PI/2 et -PI/2
  blueTree = new tree(new PVector(width/2,0),PI/2, "blue"); // l'arbre va entre PI/2 et -PI/2

}


void draw(){
  bg.draw_background();
  println(frameRate);
  theta = theta(frameCount); // theta in [-0.5,0]; 
  if (random(1)<0.007){Birds.addBird();}
  if (mousePressed && (random(1)<0.01)){Birds.addBird();}
  Birds.display();
  Birds.deleteBird();
  redTree.grow();
  redTree.display();
  greenTree.grow();
  greenTree.display();
  blueTree.grow();
  blueTree.display();
}
 
void mouseClicked(){
  redTree.falling=true;
  }


// Update of theta - the angle for the wings
float theta(int N){
  float theta = -abs(cos(N*0.02))*0.5;
  if (mousePressed){theta = -abs(cos(N*0.04))*0.5;}
  return(theta);
}
