// ParticleSystem class inspired from cpac
// One particle system is one wing, and stick to one segment

float c = 0.005; // controls the force applied to each particles 

class ParticleSystem{
  ArrayList<Particle> particles;
  PVector origin;
  int N;
  boolean accelerationmode;
  
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
  
  void action(boolean accelerationmode){
    Particle p;
    //float previous_theta = theta(frameCount-1); // previous theta
    for(int i=this.particles.size()-1; i>=0; i--){
      p=this.particles.get(i);
      // When mousePressed, particles get wilder
      if (accelerationmode==true){if ((p.lifespan<100)|| (p.lifespan>200)){particles.remove(i);this.addParticle();}} // can be mapped with a special effect, such as the shaker instead of mouseP
      else {p.applyForce(new PVector(c*random(-1,1), c* random(-1,1*c)));
    }

      p.action();
      p.lifespan-=5;
      if(p.isDead()){
         particles.remove(i);
         if (this.particles.size()<N){this.addParticle();}
      }
    
    }
  }

}
