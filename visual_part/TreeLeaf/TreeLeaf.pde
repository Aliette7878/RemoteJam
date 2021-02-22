tree redTree, greenTree, blueTree;
Background bg ;


void setup() {
  size(1200,800); // Switch to full size ?
  frameRate(60); // default frameRate = 60/sec 
  bg  = new Background();
  redTree = new tree(new PVector(0,80),PI/8, "red"); // l'arbre va entre PI/2 et -PI/2
  greenTree = new tree(new PVector(width,80),PI/2+PI/8, "green"); // l'arbre va entre PI/2 et -PI/2
  blueTree = new tree(new PVector(0,80),PI/8, "blue"); // l'arbre va entre PI/2 et -PI/2

}

void draw(){
  bg.draw_background();
  redTree.grow();
  redTree.display();
  greenTree.grow();
  greenTree.display();
  println(greenTree.bias);
  
  
}
 
