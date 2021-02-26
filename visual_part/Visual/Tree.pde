// Main code for one tree

// VARIABLES
int TimeBranch = 5; // Number of seconds before a branch is fully grown up
int TimeLeaf = 5; // Number of seconds before a leaf is fully grown up
int globalL = 180;        // Length of the 1rst branch
float sizeMax = 10; // Number maximum of branches on 1 tree

// Not modify
float adult_age = TimeBranch*fps; // nb frame before the branch is adult : has to be higher if 

class Warlitree{
  
  float bias;
  PVector position;
  ArrayList<branch> branches;
  int side = 1, age=0;
  String col;
  int L, countershaker;
  
  
  Warlitree(PVector Position, float Bias, String colorName ){  
    println(adult_age);
    bias = Bias;
    countershaker = 0;
    position = Position;
    branches = new ArrayList<branch>();
    col=colorName;
    L = globalL +int(random(-10,80));
    branches.add(new branch(int(random(-globalL,-globalL*0.7)),int(random(globalL*0.7,globalL)), new PVector(0, -L),col, bias));
  }
  
  
  void display(){
    grow();
    pushMatrix();
    translate(position.x, position.y);
    rotate(bias);   
    noFill();
    stroke(0);
    strokeWeight(1);
    beginShape();
    line(0, 0, 0, -L);
    branch c;
    for(int i=this.branches.size()-1; i>=0; i--){
         c=this.branches.get(i);
         c.display();
    }
    endShape();;    
    popMatrix();}
  
  void shake(){
      countershaker++;
      branch b;
      for(int i=int(this.branches.size()-1); i>=0; i--){
        b=this.branches.get(i);
        b.c=countershaker;
        b.shaking = true;}
      if (countershaker==3){fall(); countershaker=0;}

  }
  
  void fall(){
    branch b;
      for(int i=int(this.branches.size()-1); i>=0; i--){
         b=this.branches.get(i);
         b.leaf1.isfalling = true;
         b.leaf2.isfalling = true;
         if (random(1)<0.3 && b.age>adult_age){b.dying=true;}
  }}
  
  
  void addBranch(){
      int lengthy = int(random(20, L));
      if (col=="red" && (lengthy<80)){side = 1; } 
      else if (col=="blue" && (lengthy<80)){side = -1;} 
      branch c = new branch(side*int(random(20, lengthy)),lengthy, new PVector(0,random(-L,0)),col, bias); 
      branches.add(c);
      side = -side;
    }
  
  // Make each branch grow (and their leaves)
  void grow(){
    age++;
    branch b;
    for(int i=this.branches.size()-1; i>=0; i--){
      b=this.branches.get(i);
      b.grow();
      if (b.age == adult_age && this.branches.size()<sizeMax){addBranch();}
      if (b.age == -1){this.branches.remove(i);}
    }
  }
  
}
