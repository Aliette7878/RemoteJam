// Bird array

class BirdArray{
    ArrayList<Bird> birds;
    AttractionPoint AttractionPoint;
    boolean accelerationMode = false;
    int lasttimeshake = 0;
    
    void accelerate(int time0){
      accelerationMode=true;
      lasttimeshake = time0;
    }
    
    BirdArray(){
    this.birds = new ArrayList<Bird>();
    AttractionPoint =  new AttractionPoint();
    }
    
    void addBird(){
    this.birds.add(new Bird());   
    }
    
    void display(){
      if (millis()-lasttimeshake>3000){accelerationMode=false;}

      theta = theta(frameCount, accelerationMode); // theta in [-0.5,0]; 
      if (random(1)<0.007){addBird();}
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
  float theta = -abs(cos(N*0.02))*0.5;
  if (accelerationMode){theta = -abs(cos(N*0.6))*0.5;}
  return(theta);
}
