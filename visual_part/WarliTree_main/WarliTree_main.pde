    // VARIABLES that can be changed 
int fps=60;        // Framerate per seconds
int TimeBranch = 8; // Number of seconds before a branch is fully grown up
int TimeLeaf = 8; // Number of seconds before a leaf is fully grown up
float crook = 0.1;  // How twisted the branch will be
float pleaf = 1; // Probability to produce a leaf on each branch
int L = 120;        // Length of the 1rst branch
float sizeMax = pow(2,4); // Number maximum of branches on 1 tree
float t = 0.1; // 0 : child branch start at the beginning of parent branch. 1 : chil branch starts at the end of parent branch.

// OBJECTS

treeWarli tree;
void setup() {
  size(1200,800);
  frameRate(60);
  tree = new treeWarli(PI/3, new PVector(width/2,height/2));
}


void draw(){
  tree.display();

}
 
void mouseClicked(){
  tree.addBranch();
}
    
 
