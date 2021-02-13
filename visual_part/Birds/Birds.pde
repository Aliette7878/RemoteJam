ParticleSystem PSR, PSL, PSR2, PSL2;
Segment Seg1, Seg2, Seg3, Seg4;
float theta;
int Nparticles=40;


void setup() {
  frameRate(60); //
  size(1200,800); //
  
  // Segments
  Seg1 = new Segment(new PVector(500,400), 1, 60);
  Seg2 = new Segment(new PVector(500,400), -1, 60);

  Seg3 = new Segment(new PVector(600,600), 1, 30);
  Seg4 = new Segment(new PVector(600,600), -1, 30);

  // ParticleSytems
  PSR = new ParticleSystem();
  PSR.origin=Seg1.pos2;
  PSL = new ParticleSystem();
  PSL.origin=Seg2.pos2;
  PSR2 = new ParticleSystem();
  PSR2.origin=Seg3.pos2;
  PSL2 = new ParticleSystem();
  PSL2.origin=Seg4.pos2;
  for(int p=0; p<Nparticles; p++){
    PSR.addParticle(); PSL.addParticle();
    PSR2.addParticle(); PSL2.addParticle();
  } 
}


void draw(){
  background(255,165,0);

  theta = theta(frameCount); // theta in [-0.5,0];
  Seg1.display();
  Seg2.display();
  Seg3.display();
  Seg4.display();
  Seg1.pos1.mult(1.0003);
  Seg2.pos1.mult(1.0003);
  Seg1.L=max(30,Seg1.L-int(0.001*frameCount));
  Seg2.L=max(30,Seg2.L-int(0.001*frameCount));

  PSR.updateOrigin(Seg1);
  PSR.action(1);

  PSL.updateOrigin(Seg2);
  PSL.action(1);
  
  PSR2.updateOrigin(Seg3);
  PSR2.action(1);

  PSL2.updateOrigin(Seg4);
  PSL2.action(1);
  

  
}



// Update of theta - to synchronise with rythm
float theta(int N){
  return (-abs(cos(N*0.02))*0.5);
}
