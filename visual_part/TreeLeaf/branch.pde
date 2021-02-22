// VARIABLES
float adult_age = TimeBranch*fps ;


class branch {
  PVector start, end, mid, random_mid;
  int final_L, L, age, opacity = 250;
  float direction, leaf_angle;
  leaf leaf;
  boolean adultSwitch=false, falling=false,yesleaf;
  
  
  branch(PVector startingPoint, int Length, float dir, String col){
    final_L = Length;
    L=1;
    age=0;
    direction = dir;
    start = new PVector(int(startingPoint.x),int(startingPoint.y));
    end = new PVector(int(start.x+L*cos(direction)),int(start.y+L*sin(direction)));
    random_mid = new PVector(random(-crook*final_L,crook*final_L), random(-crook*final_L,crook*final_L));
    mid = new PVector(int((start.x+end.x)/2),int((start.y+end.y)/2)).add(random_mid);
    yesleaf = random(1)<pleaf; 
    if (yesleaf){leaf = new leaf(col);leaf_angle = random(-PI,PI);}
  }
  
  void display(int opacity){
    noFill();
    stroke(0,0,0,opacity);
    strokeWeight(1);
    beginShape();
    curveVertex(start.x,start.y); // the first control point
    curveVertex(start.x,start.y); // is also the start point of curve
    curveVertex(mid.x, mid.y); // the last point of curve
    curveVertex(end.x, end.y); // the last point of curve
    curveVertex(end.x, end.y); // is also the last control point
    endShape();
    
    // display leaf
    if (yesleaf){
      if (falling){
        leaf.position.add(new PVector(random(-1,1),random(2,3)));
        leaf_angle=leaf_angle+random(-PI/12,PI/12);
        leaf.display(leaf_angle);
      }
      else {leaf.display(leaf_angle);}
    }
  }

  
  void grow_branch(){    
    if (age<adult_age) {
      L=int(map(age,1,adult_age,0,final_L));
      if (yesleaf){leaf.position = mid;}
      end = new PVector(int(start.x+L*cos(direction)),int(start.y+L*sin(direction)));
      mid = new PVector(int((start.x+end.x)/2),int((start.y+end.y)/2)).add(random_mid);
    }
    if (age==adult_age){adultSwitch=true;}
    age++;
  }
  
  void grow_leaf(){
      if (age>adult_age && yesleaf){
        leaf.grow();
      }
  }
  
  

  
}
