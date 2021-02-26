
class tree{
  float nbBranch;
  int age = 0;
  int opacity = 255;
  ArrayList< branch> branches;  
   branch branch1;
  float bias;
  String col;
  boolean falling;
  PVector start;

  tree(PVector startingPoint, float directionBias, String colorName) {
    start = startingPoint;
    nbBranch = 0;
    col=colorName;
    bias = directionBias;
    branches = new ArrayList< branch>();
    branch1 = new  branch(start, L, bias+PI/4, col);
    this.branches.add(branch1);
    falling = false;
}
  
  void reborn(){
    nbBranch=0;
    branch1 = new  branch(start, L, bias+PI/4, col);
    branches = new ArrayList< branch>();
    this.branches.add(branch1);
    falling = false;
    age=0;
    opacity=255;
    L=80;
  }
  
  void display(){
     branch branch;
    if (falling){opacity=opacity-1;}
    if (opacity == 0){
      reborn();
    }
    for(int i=this.branches.size()-1; i>=0; i--){
        branch=this.branches.get(i);
        branch.display(opacity);
        if (falling){branch.falling=true;}
    }      
  }
  
  void add2Branch(PVector startingPoint, int Length){
    this.branches.add(new  branch(startingPoint, Length, bias + random(0,PI/2),col)); 
    this.branches.add(new  branch(startingPoint, Length, bias + random(-PI/2,0),col));}
    
  void add1Branch(PVector startingPoint, int Length){
    this.branches.add(new  branch(startingPoint, Length, bias+random(-PI/2,PI/2),col));
  }

        
  void grow(){
    age++;
     branch branch;
     for(int i=this.branches.size()-1; i>=0; i--){
       branch=this.branches.get(i);
       
       if (falling) { // No growth for branch or leaves
         branch.falling = true;
       }
       
       else {
         // Growth
         branch.grow_branch(); 
         branch.grow_leaf();
         // Branch creation
         if (branch.adultSwitch && (nbBranch<sizeMax)){
           L=max(int(random(30,80)),int(L*0.95));
           if (nbBranch<pow(2,2)){  // After 2 levels, we stop computing 2 branches from 1
             nbBranch=nbBranch+2;
             add2Branch(branch.end,L);
             branch.adultSwitch=false;}
           else { if (random(1)<0.3){nbBranch++; add1Branch(branch.mid,L); branch.adultSwitch=false;}} // slow down a bit the growth after a while
         }    
      }
      
    }
  }
  

}
