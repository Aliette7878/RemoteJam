// ParticleSystem class inspired from cpac
// One particle system is one wing, and stick to one segment

float c = 0.01; // controls the force applied to each particles (smallest level)

class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  int N; 
  boolean accelerationmode;
  float l1, l2; // Upper and lower limits for the lifespan of new-created particles

  ParticleSystem(PVector origin, int NParticles) {
    this.particles = new ArrayList<Particle>();
    this.origin=origin.copy(); 
    N = NParticles;
    l1 = 20;
    l2 = 240;
  }

  void addParticle() {
    this.particles.add(new Particle(this.origin, 3, random(55, 255)));
  }

  void updateOrigin(Segment segment) {    // the origin of the particleSystem is randomly placed on the stick
    float i = random(1);
    origin.x = int(i*segment.pos1.x + (1-i)*segment.pos2.x);
    origin.y = int(i*segment.pos1.y + (1-i)*segment.pos2.y);
  }  


  void action(boolean accelerationmode) {
    Particle p;
    if (accelerationmode==true) {
      if (millis()-lastTimeShake < 0.7*shakingDuration) {
        l1=100; 
        l2=200;
      } else {
        l1 = map(millis()-lastTimeShake, 0.7*shakingDuration, shakingDuration, 100, 20); // l1 = 100--> 20, l2 = 200-->240
        l2 = map(millis()-lastTimeShake, 0.7*shakingDuration, shakingDuration, 200, 240);
      }
    }

    for (int i=this.particles.size()-1; i>=0; i--) {
      p=this.particles.get(i);
      if (accelerationmode==false) {
        p.applyForce(new PVector(c*random(-1, 1), c* random(-1, 1*c)));
      }
      if ((p.lifespan<l1)|| (p.lifespan>l2)) {
        particles.remove(i);
        this.addParticle();
      }
      p.action();
      p.lifespan-=5;
      if (p.isDead()) {
        particles.remove(i);
        if (this.particles.size()<N) {
          this.addParticle();
        }
      }
    }
  }
}
