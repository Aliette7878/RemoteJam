// ParticleSystem class for cpac

// Additional option : mouse pressed --> more particles

class ParticleSystem{
  ArrayList<Particle> particles;
  PVector origin;
  float force1=1;
  int N;
  
  ParticleSystem(PVector origin, int NParticles){
    this.particles = new ArrayList<Particle>();
    this.origin=origin.copy(); 
    N = NParticles;
  }
  
  void addParticle(){
    this.particles.add(new Particle(this.origin, 3, random(50,255)));   
  }
  
  void updateOrigin(Segment segment){    // the origin of the particleSystem is randomly placed on the stick
  float i = random(1);
  origin.x = int(i*segment.pos1.x + (1-i)*segment.pos2.x);
  origin.y = int(i*segment.pos1.y + (1-i)*segment.pos2.y);
  }  
  
  void action(){
    Particle p;
    //float previous_theta = theta(frameCount-1); // previous theta
    for(int i=this.particles.size()-1; i>=0; i--){
      p=this.particles.get(i);
      // When mousePressed, particles get wilder
      if (mousePressed==true){force1=10; p.lifespan+=2;}; // can be mapped with a special effect, such as the shaker instead of mouseP
      // When sticks are hiting, particles bounce 
      /*if ((theta>-0.03)&&(theta>previous_theta)&&(forsticks==1)){p.applyForce(new PVector(force1*random(-0.1,0.1), -0.3*force1));}*/
      p.applyForce(new PVector(force1*random(-0.1, 0.1), force1* random(-0.1,0.1))); 
      force1=1; // reset force1

      p.action();
      p.lifespan-=5;
      if(p.isDead()){
         particles.remove(i);
         if (this.particles.size()<N){this.addParticle();}
      }
    
    }
  }

}
