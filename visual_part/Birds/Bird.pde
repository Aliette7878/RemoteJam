// Bird class
float density = 0.5;
int WingLength = 60;

class Bird{
  PVector pos; // Position
  int L; // Wings length
  float N; // Number of particles
  Walker Walker;
  Segment SegR, SegL; 
  ParticleSystem PSR, PSL;
  
  Bird() {
      L = WingLength;
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
      for(int p=0; p<N; p++){
        PSR.addParticle(); PSL.addParticle();
      }
    } 

  void move(){    
    SegL.update(); // Update segment's angle according to theta
    SegR.update();
    //SegL.pos1.mult(1.0003); // Update segment's position
    SegL.pos1 = Walker.location;
    SegR.pos1 = Walker.location;
    PSR.updateOrigin(SegR); // Update the PS position
    PSL.updateOrigin(SegL); 
    Walker.walk();
  }
  
  void shrink(){
    N = max(0,N-N*0.001);
    SegR.L=int(N/density);
    SegL.L=SegR.L;
    PSR.N = int(N); PSL.N = int(N);
  }
  
  void display(){
    shrink();
    move();    
    PSR.action();// Update & display particles (forces, dead, lifespan)
    PSL.action();

  }
}
