// ParticleSystem class inspired from cpac
// One particle system is one wing, and stick to one segment

float c = 0.005; // controls the force applied to each particles 

class ParticleSystem{
  ArrayList<Particle> particles;
  PVector origin;
  int N;
  boolean accelerationmode;
  float l1, l2;
  
  ParticleSystem(PVector origin, int NParticles){
    this.particles = new ArrayList<Particle>();
    this.origin=origin.copy(); 
    N = NParticles;
    l1 = 20;
    l2 = 240;
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
    if (accelerationmode==true){
      if (millis()-lasttimeshake < 0.7*shakingduration){
        l1=100; l2=200;
      }
      else {
         l1 = map(millis()-lasttimeshake, 0.7*shakingduration, shakingduration,100, 20); // l1 = 100--> 0, l2 = 200-->250
         l2 = map(millis()-lasttimeshake,  0.7*shakingduration, shakingduration,200, 240);
      }
    }

    for(int i=this.particles.size()-1; i>=0; i--){
      p=this.particles.get(i);
      // When mousePressed, particles get wilder

      //}
      if (accelerationmode==false) {p.applyForce(new PVector(c*random(-1,1), c* random(-1,1*c)));
      }
      if ((p.lifespan<l1)|| (p.lifespan>l2)){
        particles.remove(i);this.addParticle();
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
