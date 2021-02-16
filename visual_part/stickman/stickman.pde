Character[] people;
int populationSize;


void setup() {
  size (1080, 720);
  frameRate(30);

  populationSize = 8;
  people = new Character[populationSize];
  for (int i=0; i<populationSize; i++) {
    people[i] = new Character(20);
  }
}


void draw() {
  background(240);

  for (Character charact : people) {
    charact.UpdateChar();
    charact.DrawCharacter();
  }
}
  void mouseClicked() {
  for (Character charact : people) {
    charact.dancing=false;
  }
  }
