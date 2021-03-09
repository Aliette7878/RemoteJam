// One branch of a tree welcomes 1 or 2 leaves

class branch {
  int Lx, Ly, fLx, fLy, age=0, opacity, shakeIteration, c;
  PVector A, B, C, end;
  PVector pos;
  leaf leaf1, leaf2;
  float t;
  boolean falling=false, dying=false, shaking = false;
  float bias;
  float s=2;


  branch(int Lengthx, int Lengthy, PVector position, String col, float biasoftree) {  
    fLx = Lengthx;
    fLy = Lengthy;
    Lx=1; 
    Ly=1;
    pos = position;
    leaf1 = new leaf(col);
    leaf2 = new leaf(col);
    leaf2.svg.setVisible(false);
    t = random(0.1, 0.75);
    A = new PVector(pos.x, pos.y-Ly);
    B = new PVector(pos.x - Lx, pos.y-Ly);
    end = new PVector( pos.x-Lx, pos.y-Ly/2); // END
    bias = biasoftree;
    opacity=255;
    shakeIteration=0;
  }

  // One branch shakes and can loose its leaves
  void shakeBranch(int c) {
    s = s*0.99;
    float x=s*cos(c*10*millis()/1000);  
    end.add(c*x, c*x);
    if (leaf1.isfalling==false) {
      leaf1.position = new PVector(pos.x*pow(1-t, 3)+3*A.x*t*(1-t)*(1-t)+3*B.x*t*t*(1-t)+end.x*t*t*t, pos.y*pow(1-t, 3)+3*A.y*t*(1-t)*(1-t)+3*B.y*t*t*(1-t)+end.y*t*t*t);
    }
    if (leaf2.isfalling==false) {
      leaf2.position = new PVector(end.x, end.y);
    }
    shakeIteration++;
    if (shakeIteration>100) {
      shaking=false; 
      shakeIteration=0;
      s=2;
    }
  }

  // Display leaf and branch
  void display() {
    A = new PVector(pos.x, pos.y-Ly);
    B = new PVector(pos.x - Lx, pos.y-Ly);
    end = new PVector( pos.x-Lx, pos.y-1.5*Ly/2); // END
    if (shaking) {
      shakeBranch(c);
    }
    noFill();
    stroke(0, 0, 0, opacity);
    strokeWeight(1);
    beginShape();
    vertex(pos.x, pos.y); // BEGINNING      
    bezier(pos.x, pos.y, A.x, A.y, B.x, B.y, end.x, end.y);
    if (leaf1.isfalling) {
      leaf1.fall(bias);
    }
    if (leaf2.isfalling) {
      leaf2.fall(bias);
    }
    leaf1.display();
    leaf2.display();
    endShape();
  }


  // Make the branch and its leaves grow
  void grow() {
    age++;
    leaf1.grow();
    leaf2.grow();
    if (age<adult_age) {
      Lx=int(map(age, 1, adult_age, 0, fLx));
      Ly = int(map(age, 1, adult_age, 0, fLy));
      leaf1.position = new PVector(pos.x*pow(1-t, 3)+3*A.x*t*(1-t)*(1-t)+3*B.x*t*t*(1-t)+end.x*t*t*t, pos.y*pow(1-t, 3)+3*A.y*t*(1-t)*(1-t)+3*B.y*t*t*(1-t)+end.y*t*t*t);
      leaf2.position = new PVector(end.x, end.y);
    }

    // We use the Bezier polynomial equation of the branch to place the leaf.
    if (leaf1.position.y>height || leaf2.position.y<-height) {
      leaf1.reset();       
      leaf1.position = new PVector(pos.x*pow(1-t, 3)+3*A.x*t*(1-t)*(1-t)+3*B.x*t*t*(1-t)+end.x*t*t*t, pos.y*pow(1-t, 3)+3*A.y*t*(1-t)*(1-t)+3*B.y*t*t*(1-t)+end.y*t*t*t);
    }
    if (leaf2.position.y>height || leaf2.position.y<-height) {
      leaf2.reset();
      leaf2.position = new PVector(end.x, end.y);
    }
    if (dying) {
      opacity--;
      if (opacity==0) {
        age=-1;
      }
    }
  }
}
