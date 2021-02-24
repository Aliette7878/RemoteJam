// VARIABLES that can be changed 
int fps=60;        // Framerate per seconds
int TimeBranch = 8; // Number of seconds before a branch is fully grown up
int TimeLeaf = 12; // Number of seconds before a leaf is fully grown up
float pleaf = 1; // Probability to produce a leaf on each branch
int globalL = 180;        // Length of the 1rst branch
float sizeMax = 6; // Number maximum of branches on 1 tree

// OBJECTS
warlitree redTree, greenTree, blueTree;
Background bg ;


void setup() {
  size(1200,800);
  frameRate(fps); 
  bg  = new Background();
  
  redTree = new warlitree(new PVector(0,400),PI/12, "red"); 
  greenTree = new warlitree(new PVector(width/2,0),PI-PI/12, "green");
  blueTree = new warlitree(new PVector(width,400),-PI/6, "blue");
}


void draw(){
  bg.draw_background();
  
  redTree.display();
  greenTree.display();
  blueTree.display();
  
  //println(frameRate);
}
 
 
void mouseClicked(){
  redTree.fall();
  
}
