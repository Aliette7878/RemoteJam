StickLeft StickLeft,StickRight ;
ParticleSystem PSL, PSR;
Drum Drum1;
float theta;
int Nparticles=2000;


void setup() {
  frameRate(60); //
  size(1200,800); //
  
  // Sticks
  StickLeft = new StickLeft(new PVector(300,400), 1);
  StickRight = new StickLeft(new PVector(900,400), -1);

  // ParticleSytems
  PSR = new ParticleSystem();
  PSR.origin=StickRight.pos2;
  PSL = new ParticleSystem();
  PSL.origin=StickLeft.pos2;
  for(int p=0; p<Nparticles; p++){
    PSR.addParticle(); PSL.addParticle();
  }
  
  // Drum
  Drum1 = new Drum("DrumRed2",310,400,500);  
  for(int p=0; p<Nparticles; p++){
    Drum1.addParticle();
  }
 
}

void draw(){
  background(0);
  Drum1.display();

  theta = theta(frameCount); // theta in [-0.5,0];
  StickRight.display();
  StickLeft.display();
  
  PSR.updateOrigin(StickRight);
  PSR.action(1);

  PSL.updateOrigin(StickLeft);
  PSL.action(1);
  
}



// Update of theta - to synchronise with rythm
float theta(int N){
  return (-abs(cos(N*0.02))*0.5);
}
