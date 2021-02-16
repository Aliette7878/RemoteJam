// Bird array

class BirdArray{
    ArrayList<Bird> birds;
    
    BirdArray(){
    this.birds = new ArrayList<Bird>();
    }
    
    void addBird(){
    this.birds.add(new Bird());   
    }
    
    void display(){
      Bird b;
      for(int i=this.birds.size()-1; i>=0; i--){
        b=this.birds.get(i);
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
