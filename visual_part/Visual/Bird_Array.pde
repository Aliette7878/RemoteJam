// Bird array

class BirdArray{
    ArrayList<Bird> birds;
    AttractionPoint AttractionPoint;
    boolean accelerationMode = false;
    
    void accelerate(int time0){
      accelerationMode=true;
      if (millis()-time0>2000){accelerationMode=false;}
    }
    
    BirdArray(){
    this.birds = new ArrayList<Bird>();
    AttractionPoint =  new AttractionPoint();
    }
    
    void addBird(){
    this.birds.add(new Bird());   
    }
    
    void display(){
      theta = theta(frameCount, accelerationMode); // theta in [-0.5,0]; 
      if (random(1)<0.007){addBird();}
      if (accelerationMode && (random(1)<0.01)){addBird();}
      deleteBird();
      
      Bird b;
      AttractionPoint.walk();
      
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
  if (accelerationMode){theta = -abs(cos(N*0.04))*0.5;}
  return(theta);
}
