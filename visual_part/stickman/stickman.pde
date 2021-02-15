Character people;


void setup() {
  size (1080, 720);
  frameRate(30);
  
  people = new Character();
}


void draw() {
  background(240);
  
  people.UpdateChar();
  people.DrawCharacter();
}
