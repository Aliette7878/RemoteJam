float sizeMax = pow(2,9); //nbMax branches
// PI/2 = en bas, 0 = à droite; --> rajouter des -  

class tree{
  float nbBranch;
  int age = 0;
  int L= 80;
  float speed = frameRate*10; // speed of development for every branch
  ArrayList<branch> branches;  
  branch branch1;
  float bias;
  String col;

  tree(PVector startingPoint, float directionBias, String colorName) {
    nbBranch = 0;
    col=colorName;
    bias = directionBias;
    branch1 = new branch(startingPoint, L, bias+PI/4, col);
    branches = new ArrayList<branch>();
    this.branches.add(branch1);
}
  
  void display(){
    branch branch;
    for(int i=this.branches.size()-1; i>=0; i--){
        branch=this.branches.get(i);
        branch.display();}}
  
  void add2Branch(PVector startingPoint, int Length){
    this.branches.add(new branch(startingPoint, Length, bias + random(0,PI/2),col)); // = PI/8 + PI/4 ou -PI/4 = PI/8 +- (
    this.branches.add(new branch(startingPoint, Length, bias + random(-PI/2,0),col));}
    
  void add1Branch(PVector startingPoint, int Length){
    this.branches.add(new branch(startingPoint, Length, bias+random(-PI/2,PI/2),col));
  }

        
  void grow(){
    age++;
    branch branch;
     for(int i=this.branches.size()-1; i>=0; i--){
       branch=this.branches.get(i);
       branch.grow(); 
       if (branch.becomes_adult && (nbBranch<sizeMax)){
         L=max(int(random(30,40)),int(L*0.95));
         println(L);
         println(" ");
         if (nbBranch<pow(2,4)){
         nbBranch=nbBranch+2;
         add2Branch(branch.end,L);}
         else { nbBranch++; add1Branch(branch.mid,L);}
       }    
  }    
  }


}
