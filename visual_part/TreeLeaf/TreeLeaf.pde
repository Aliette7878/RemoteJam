// VARIABLES that can be changed 
int fps=60;        // Framerate per seconds
int TimeBranch = 8; // Number of seconds before a branch is fully grown up
int TimeLeaf = 8; // Number of seconds before a leaf is fully grown up
float crook = 0.1;  // How twisted the branch will be
float pleaf = 1; // Probability to produce a leaf on each branch
int L = 120;        // Length of the 1rst branch
float sizeMax = pow(2,4); // Number maximum of branches on 1 tree


// OBJECTS
tree redTree, greenTree, blueTree;
Background bg ;


void setup() {
  size(1200,800);
  frameRate(fps); 
  bg  = new Background();
  
  redTree = new tree(new PVector(0,80),PI/8, "red"); 
  greenTree = new tree(new PVector(width,0),PI/2+PI/8, "green");
  blueTree = new tree(new PVector(width/2,0),PI/2, "blue");
}


void draw(){
  bg.draw_background();
  redTree.grow();
  redTree.display();
  greenTree.grow();
  greenTree.display();
  blueTree.grow();
  blueTree.display();
  println(frameRate);
}
 
 
void mouseClicked(){
  redTree.falling=true;
}
