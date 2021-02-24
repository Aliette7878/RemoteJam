float adult_age = TimeBranch*fps ;

class warlitree{
  
  float bias;
  PVector position;
  ArrayList<branch> branches;
  int side = 1, age=0;
  String col;
  int L;
  
  
  warlitree(PVector Position, float Bias, String colorName ){  
    bias = Bias;
    position = Position;
    branches = new ArrayList<branch>();
    col=colorName;
    L = globalL +int(random(-10,80));
    branches.add(new branch(int(random(-globalL,-globalL*0.7)),int(random(globalL*0.7,globalL)), new PVector(0, -L),col));
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
  
  void fall(){
    branch b;
      for(int i=this.branches.size()-1; i>=0; i--){
         b=this.branches.get(i);
         b.falling = ! b.falling;
  }}
  
  
  void addBranch(){
      int lengthy = int(random(20, L));
      println(lengthy);
      if (col=="red" && (lengthy<80)){side = 1; println(side);} 
      else if (col=="blue" && (lengthy<80)){side = -1;} 
      branch c = new branch(side*int(random(20, lengthy)),lengthy, new PVector(0,random(-L,0)),col); 
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
    }
  }
  

  
  
}
// end of warlitree class





////////////////////////////////////////////////////////////////
//////////////// BRANCH CLASS ///////////////////////////////////
////////////////////////////////////////////////////////////////


class branch{
  int Lx, Ly, fLx, fLy, age=0;
  PVector A, B, C,end;
  PVector pos;
  float leaf_angle;
  leaf leaf1, leaf2;
  float t;
  boolean falling=false;
  
    branch(int Lengthx, int Lengthy, PVector position, String col){  
      fLx = Lengthx;
      fLy = Lengthy;
      Lx=1; Ly=1;
      pos = position;
      leaf1 = new leaf(col);
      leaf2 = new leaf(col);
      leaf_angle = random(-PI,PI);
      t = random(0.7,1);
      A = new PVector(pos.x, pos.y-Ly);
      B = new PVector(pos.x - Lx, pos.y-Ly);
      end = new PVector( pos.x-Lx, pos.y-Ly/2); // END
    }
    
    // Display leaf and branch
    void display(){
      noFill();
      stroke(0);
      strokeWeight(1);
      beginShape();
      vertex(pos.x, pos.y); // BEGINNING      
      A = new PVector(pos.x, pos.y-Ly);
      B = new PVector(pos.x - Lx, pos.y-Ly);
      end = new PVector( pos.x-Lx, pos.y-Ly/2); // END
      bezier(pos.x,pos.y, A.x, A.y, B.x, B.y, end.x, end.y);
      displayLeaf();
      endShape();
    }
    
    // Make the branch and its leaf grow
    void grow(){
       age++;
       if (age<adult_age) {
           leaf1.grow();
           //leaf2.grow();
           Lx=int(map(age,1,adult_age,0,fLx));
           Ly = int(map(age, 1, adult_age, 0, fLy));
           leaf1.position = new PVector(pos.x*pow(1-t,3)+3*A.x*t*(1-t)*(1-t)+3*B.x*t*t*(1-t)+end.x*t*t*t, pos.y*pow(1-t,3)+3*A.y*t*(1-t)*(1-t)+3*B.y*t*t*(1-t)+end.y*t*t*t);
           //leaf2.position = new PVector(end.x*pow(1-t,3)+3*B.x*t*(1-t)*(1-t)+3*A.x*t*t*(1-t)+pos.x*t*t*t, end.y*pow(1-t,3)+3*B.y*t*(1-t)*(1-t)+3*A.y*t*t*(1-t)+pos.y*t*t*t);

     }
    }
    
    void displayLeaf(){
      if (falling){
            leaf1.position.add(new PVector(random(-1,1),random(2,3)));
            //leaf2.position.add(new PVector(random(-1,1),random(2,3)));
            leaf_angle=leaf_angle+random(-PI/12,PI/12);
            if (leaf1.position.y>height){falling = false;}
      }
      leaf1.display(leaf_angle);
      leaf2.display(leaf_angle);

    }
    
    
}
