// Main code for one single bird

// VARIABLES
float PbirdLvl1 = 0.003;  // Probability of bird aparition in lvl 1
float PbirdLvl2 = 0.009;   // Probability of bird aparition in lvl 2
int shakingDuration = 2000; // Acceleration time during a shaker
float f1 = 0.02, f2 = 0.06; // Frequency of wings movement
int maxNumberOfBirds = 14; 

// Do not modify
float theta;
float density = 0.5;
int WingsLength = 30;

class Bird {
  PVector pos; // Position
  int L; // Wings length
  float N; // Number of particles
  Walker Walker;
  Segment SegR, SegL; 
  ParticleSystem PSR, PSL;

  Bird() {
    L = WingsLength;
    N = density*L; 
    Walker = new Walker();
    pos = Walker.location; 

    // Right wing
    SegR = new Segment(pos, 1, L); // geometric support for the particles
    PSR = new ParticleSystem(SegR.pos2, int(N)); // fix a particle system on the invisible segment
    // Left wing
    SegL = new Segment(pos, -1, L);
    PSL = new ParticleSystem(SegL.pos2, int(N));

    // Create particles
    for (int p=0; p<N; p++) {
      PSR.addParticle(); 
      PSL.addParticle();
    }
  } 

  void move(boolean accelerationMode) {  
    Walker.walk(accelerationMode);
    SegL.update(); // Update segment's angle according to theta
    SegR.update(); 
    SegL.pos1 = Walker.location; // Update segment's position
    SegR.pos1 = Walker.location;
    PSR.updateOrigin(SegR); // Update the PS position
    PSL.updateOrigin(SegL);
  }

  void shrink(boolean accelerationMode) {
    N = max(0, N-N*0.001);
    if (accelerationMode==true) {
      N = N-N*0.007; // particles disappear sooner
      SegR.L=int(N/density*0.90);
    } else {
      SegR.L=int(N/density);
    }
    SegL.L=SegR.L;
    PSR.N = int(N); 
    PSL.N = int(N);
  }

  void display(boolean accelerationMode) {
    shrink(accelerationMode);
    move(accelerationMode);    
    PSR.action(accelerationMode);// Update & display particles (forces, dead, lifespan)
    PSL.action(accelerationMode);
  }
}
