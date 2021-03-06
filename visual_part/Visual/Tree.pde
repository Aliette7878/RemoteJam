// Main code for one tree

// BRANCH VARIABLES
int TimeBranch1 = 7, TimeBranch2 = 2; // Number of seconds before a branch is fully grown up
int sizeMax1 = 5, sizeMax2 = 8;  // Number maximum of branches on 1 tree
int globalL = 180;        // Length of the 1rst branch

// *** do not modify ***
int TimeBranch = TimeBranch1;
float sizeMax = sizeMax1;
float adult_age = TimeBranch*fps; // nb frame before the branch is adult
int maxOscAmp=60;

class Warlitree {

  PVector position;
  float angle; // controls the inclination of the tree
  ArrayList<branch> branches;
  int side = 1, age=0;
  String col;
  int L, shakesCounter; 
  float oscAmp, oscFreq;


  Warlitree(PVector treePosition, float ang, String colorName ) {  
    angle = ang;
    shakesCounter = 0;
    position = treePosition;
    branches = new ArrayList<branch>();
    col=colorName;
    L = globalL +int(random(-10, 80));
    oscAmp = 8;
    oscFreq = 0.5;
    branches.add(new branch(int(random(-globalL, -globalL*0.7)), int(random(globalL*0.7, globalL)), new PVector(0, -L), col, angle));
  }


  void display() {
    oscAmp=min(oscAmp, maxOscAmp);
    grow();
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle+oscAmp/300*cos(2*PI*oscFreq*millis()/1000));   
    noFill();
    stroke(0);
    strokeWeight(1);
    beginShape();
    line(0, 0, 0, -L);
    branch b;
    for (int i=this.branches.size()-1; i>=0; i--) {
      b=this.branches.get(i);
      b.display(oscAmp, oscFreq);
    }   
    endShape();
    popMatrix();
  }



  // All branches grow, levels parameters are updated, some branches can disappear
  void grow() {
    updateLevel();
    spontaneousDeath();
    age++;
    branch b;
    for (int i=this.branches.size()-1; i>=0; i--) {
      b=this.branches.get(i);
      b.grow();
      if (b.age == int(adult_age) && this.branches.size()<sizeMax ) {
        addBranch();
      }
      if (b.age == -1) {
        this.branches.remove(b); 
        addBranch();
      }
    }
  }


  // All branches shake a bit, function fall() is triggered after 3 shake()
  void shakeTree() {
    shakesCounter++;
    for (branch b : this.branches) {
      b.treeShakeIt=shakesCounter;
      b.shaking = true;
    }
    if (shakesCounter==3) {
      fall(); 
      shakesCounter=0;
    }
  }


  // All branches loose leaves, some of the branches disappear
  void fall() {
    for (branch b : this.branches) {
      b.leaf1.isfalling = true;
      b.leaf2.isfalling = true;
      if (random(1)<0.3 && b.age>adult_age) {
        b.dying=true;
      }
    }
  }


  void addBranch() {
    int lengthy = int(random(20, L));
    if (col=="red" && (lengthy<80)) {
      side = 1;
    } else if (col=="blue" && (lengthy<80)) {
      side = -1;
    } 
    branch c = new branch(side*int(random(20, lengthy)), lengthy, new PVector(0, random(-L, 0)), col, angle); 
    branches.add(c);
    side = -side;
  }


  // When the tree is almost complete and nothing happens, it randomly looses branches & leaves
  void spontaneousDeath() {
    if (random(1)<0.01 && this.branches.size()>sizeMax-2 && level2) {
      branch b;
      b = this.branches.get(1);
      b.dying = true;
      b.leaf1.isfalling = true;
      b.leaf2.isfalling = true;
    }
  }


  // Parameters changes for level 1 & level 2
  void updateLevel() {
    if (level2) {
      adult_age = max(adult_age*0.95, TimeBranch*fps);// update
      colored=1;
    } else {
      adult_age = min(adult_age*1.05, TimeBranch*fps);
    }
    if (previouslevel2!=level2) {
      addBranch();
      if (level2) {
        TimeLeaf=TimeLeaf2; 
        TimeBranch=TimeBranch2; 
        sizeMax = sizeMax2;
      } else {
        TimeLeaf=TimeLeaf1; 
        TimeBranch=TimeBranch1;
        sizeMax = sizeMax1;
        colored = 0; // we don't want level 1 to make leave black anymore
      }
    }
  }
}
