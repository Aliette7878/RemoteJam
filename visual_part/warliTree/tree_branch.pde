float adult_age = TimeBranch*fps ; // nb frame before the branch is adult

class warlitree{
  
  float bias;
  PVector position;
  ArrayList<branch> branches;
  int side = 1, age=0;
  String col;
  int L, countershaker;
  
  
  warlitree(PVector Position, float Bias, String colorName ){  
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
// end of warlitree class





////////////////////////////////////////////////////////////////
//////////////// BRANCH CLASS ///////////////////////////////////
////////////////////////////////////////////////////////////////


class branch{
  int Lx, Ly, fLx, fLy, age=0, opacity, countershakes, c;
  PVector A, B, C,end;
  PVector pos;
  leaf leaf1, leaf2;
  float t;
  boolean falling=false, dying=false, shaking = false;
  float bias;
  float s=2;
  
    branch(int Lengthx, int Lengthy, PVector position, String col, float biasoftree){  
      fLx = Lengthx;
      fLy = Lengthy;
      Lx=1; Ly=1;
      pos = position;
      leaf1 = new leaf(col);
      leaf2 = new leaf(col);
      leaf2.svg.setVisible(false);
      t = random(0.1,0.95);
      A = new PVector(pos.x, pos.y-Ly);
      B = new PVector(pos.x - Lx, pos.y-Ly);
      end = new PVector( pos.x-Lx, pos.y-Ly/2); // END
      bias = biasoftree;
      opacity=255;
      countershakes=0;
    }
    
    // shake :
    void shake(int c){
      s = s*0.99;
      float x=s*cos(c*10*millis()/1000);  
      //A.add(s,s);
      //B.add(x,x);
      end.add(c*x,c*x);
      if (leaf1.isfalling==false){leaf1.position = new PVector(pos.x*pow(1-t,3)+3*A.x*t*(1-t)*(1-t)+3*B.x*t*t*(1-t)+end.x*t*t*t, pos.y*pow(1-t,3)+3*A.y*t*(1-t)*(1-t)+3*B.y*t*t*(1-t)+end.y*t*t*t);
      }
      if (leaf2.isfalling==false){leaf2.position = new PVector(end.x, end.y);}
      countershakes++;
      if (countershakes>100){shaking=false; countershakes=0;s=2;}
    }
    
    // Display leaf and branch
    void display(){
      A = new PVector(pos.x, pos.y-Ly);
      B = new PVector(pos.x - Lx, pos.y-Ly);
      end = new PVector( pos.x-Lx, pos.y-1.5*Ly/2); // END
      if (shaking){shake(c);}
      noFill();
      stroke(0,0,0,opacity);
      strokeWeight(1);
      beginShape();
      vertex(pos.x, pos.y); // BEGINNING      
      bezier(pos.x,pos.y, A.x, A.y, B.x, B.y, end.x, end.y);
      if (leaf1.isfalling){leaf1.fall(bias);}
      if (leaf2.isfalling){leaf2.fall(bias);}
      leaf1.display();
      leaf2.display();
      endShape();
    }
    

    // Make the branch and its leaf grow
    void grow(){
       age++;
       leaf1.grow();
       leaf2.grow();
       if (age<adult_age) {
           Lx=int(map(age,1,adult_age,0,fLx));
           Ly = int(map(age, 1, adult_age, 0, fLy));
           leaf1.position = new PVector(pos.x*pow(1-t,3)+3*A.x*t*(1-t)*(1-t)+3*B.x*t*t*(1-t)+end.x*t*t*t, pos.y*pow(1-t,3)+3*A.y*t*(1-t)*(1-t)+3*B.y*t*t*(1-t)+end.y*t*t*t);
           leaf2.position = new PVector(end.x, end.y);
       }
       if (leaf1.position.y>height){
         leaf1.reset();       
         leaf1.position = new PVector(pos.x*pow(1-t,3)+3*A.x*t*(1-t)*(1-t)+3*B.x*t*t*(1-t)+end.x*t*t*t, pos.y*pow(1-t,3)+3*A.y*t*(1-t)*(1-t)+3*B.y*t*t*(1-t)+end.y*t*t*t);
       }
       if (leaf2.position.y>height){leaf2.reset();leaf2.position = new PVector(end.x, end.y);}
       if (dying){
         opacity--;
         if (opacity==0){age=-1;}}
    }
    

    
}
