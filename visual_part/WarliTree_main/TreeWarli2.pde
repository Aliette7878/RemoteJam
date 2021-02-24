class treeWarli{
  
  float bias;
  PVector position;
  ArrayList<curv> branches;
  int lengthTree = 200;
  int side = 1;
  
  treeWarli(float Bias, PVector Position){  
    bias = Bias;
    position = Position;
    branches = new ArrayList<curv>();
    branches.add(new curv(-100,100, new PVector(0, -lengthTree)));
  }
  
  void display(){
    pushMatrix();
    translate(position.x, position.y);
    rotate(bias);   
    noFill();
    stroke(0);
    strokeWeight(3);
    beginShape();
    line(0, 0, 0, -lengthTree);
    curv c;
    for(int i=this.branches.size()-1; i>=0; i--){
         c=this.branches.get(i);
         c.display();
    }
    endShape();;    
    popMatrix();
  }
  
  
  void addBranch(){
      int lengthy = int(random(0, lengthTree));
      curv c = new curv(side*int(random(0, lengthy)),lengthy, new PVector(0,random(-lengthTree,0))); 
      side=-side;
      branches.add(c);
  }
}


////////////////////////////////////////////////////////////////
//////////////// CURVE CLASS ///////////////////////////////////
////////////////////////////////////////////////////////////////


class curv{
  int Lx, Ly;
  PVector pos;
  
    curv(int Lengthx, int Lengthy, PVector position){  
      Lx = Lengthx;
      Ly = Lengthy;
      pos = position;
    }
    
    void display(){
      noFill();
      stroke(0);
      strokeWeight(1);
      beginShape();
      vertex(pos.x, pos.y); // BEGINNING
      PVector A = new PVector(pos.x, pos.y-Ly);
      PVector B = new PVector(pos.x - Lx, pos.y-Ly);
      PVector end = new PVector( pos.x-Lx, pos.y-Ly/2); // END
      bezier(pos.x,pos.y, A.x, A.y, B.x, B.y, end.x, end.y);
      endShape();
    }

}
