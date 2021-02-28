// Bird array
int lasttimeshake = 0;


class BirdArray{
    ArrayList<Bird> birds;
    AttractionPoint AttractionPoint;
    boolean accelerationMode = false;
    float Pbird=Pbird1;
    
    void accelerate(int time0){
      accelerationMode=true;
      lasttimeshake = time0;
    }
    
    BirdArray(){
    this.birds = new ArrayList<Bird>();
    AttractionPoint =  new AttractionPoint();
    addBird();
    }
    
    void addBird(){
    this.birds.add(new Bird());   
    }
    
    void display(){
      if (level2){Pbird=Pbird2; }
      else {Pbird=Pbird1;}
      
      if (millis()-lasttimeshake>shakingduration){accelerationMode=false;}

      theta = theta(frameCount, accelerationMode); // theta in [-0.5,0]; 
      if (random(1)<Pbird && this.birds.size()<sizeMaxBird){addBird();}
      if (accelerationMode && (random(1)<0.03)){addBird();}
      deleteBird();
      
      Bird b;
      AttractionPoint.walk(accelerationMode);
      
      for(int i=this.birds.size()-1; i>=0; i--){
        b=this.birds.get(i);
        b.Walker.applyAttraction(AttractionPoint.location);
        b.display(accelerationMode); 
      }
    }
    
    
    void deleteBird(){
      Bird b;
      for(int i=this.birds.size()-1; i>=0; i--){
        b=this.birds.get(i);
        if ((b.Walker.outofscreen())||(b.N<5)){
          birds.remove(i);
        }
      }
    }
       
}

// Update of theta - the angle for the wings
float theta(int N, boolean accelerationMode){
  float theta = -abs(cos(N*f1))*0.5;
  if (accelerationMode){theta = -abs(cos(N*f2))*0.5;}
  return(theta);
}
