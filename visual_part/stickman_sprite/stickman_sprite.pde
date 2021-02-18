Character[] people;
int populationSize;


void setup() {
  size (1080, 720);
  frameRate(120);

  populationSize = 40;
  people = new Character[populationSize];
  for (int i=0; i<populationSize; i++) {
    people[i] = new Character();
  }
}


void draw() {
  background(240);

  for (Character charact : people) {
    charact.UpdateChar();
    charact.DrawCharacter();
  }
  println(frameRate);
}
//void mouseClicked() {
//  for (Character charact : people) {
//    charact.dancing=false;
//  }
//}
