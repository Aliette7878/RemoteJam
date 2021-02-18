// Bird array

class BirdArray{
    ArrayList<Bird> birds;
    AttractionPoint AttractionPoint;
    
    BirdArray(){
    this.birds = new ArrayList<Bird>();
    AttractionPoint =  new AttractionPoint();
    }
    
    void addBird(){
    this.birds.add(new Bird());   
    }
    
    void display(){
      Bird b;
      AttractionPoint.walk();
      //fill(255,255,255);
      //strokeWeight(100);
      //point(AttractionPoint.location.x, AttractionPoint.location.y);
      for(int i=this.birds.size()-1; i>=0; i--){
        b=this.birds.get(i);
        b.Walker.applyAttraction(AttractionPoint.location);
        b.display(); 
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
