// Tree going left for now

float crook = 0.1;  // how twisted the branch will be
float adult_age = 3*frameRate ; // 12 seconds - how long we do a rescaling before staying at the same size (here 12sec)

  
class branch {
  PVector start, end, mid, random_mid;
  int final_L, L, age;
  float direction, leaf_angle;
  leaf leaf;
  boolean becomes_adult=false;
  boolean noleaf;
  
  branch(PVector startingPoint, int Length, float dir, String col){
    final_L = Length;
    L=1;
    age=0;
    direction = dir;
    start = new PVector(int(startingPoint.x),int(startingPoint.y));
    end = new PVector(int(start.x+L*cos(direction)),int(start.y+L*sin(direction)));
    random_mid = new PVector(random(-crook*final_L,crook*final_L), random(-crook*final_L,crook*final_L));
    mid = new PVector(int((start.x+end.x)/2),int((start.y+end.y)/2)).add(random_mid);
    leaf = new leaf(col);
    leaf_angle = random(-PI,PI);
    noleaf = random(1)<0.5; 
  }
  
  void display(){  
    noFill();
    stroke(0);
    strokeWeight(1);
    beginShape();
    curveVertex(start.x,start.y); // the first control point
    curveVertex(start.x,start.y); // is also the start point of curve
    curveVertex(mid.x, mid.y); // the last point of curve
    curveVertex(end.x, end.y); // the last point of curve
    curveVertex(end.x, end.y); // is also the last control point
    endShape();
  }
  
  void grow(){
    if (age<adult_age) {
      L=int(map(age,1,adult_age,0,final_L));
      end = new PVector(int(start.x+L*cos(direction)),int(start.y+L*sin(direction)));
      mid = new PVector(int((start.x+end.x)/2),int((start.y+end.y)/2)).add(random_mid);
    } // if born less than 5sec ago
    if (age==adult_age){
      leaf.display(mid, leaf_angle);
      becomes_adult = true;
    }
    if (age>adult_age){
      becomes_adult = false;
      if (noleaf) {
        leaf.grow();
        leaf.display(mid, leaf_angle);
      }
    }
    age++;
  }
}
