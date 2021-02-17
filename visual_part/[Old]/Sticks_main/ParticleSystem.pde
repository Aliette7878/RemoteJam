// ParticleSystem class for cpac
// Additional options : mouse pressed --> more particles

class ParticleSystem{
  ArrayList<Particle> particles;
  PVector origin;
  float force1=1;
  
  ParticleSystem(){
    this.particles = new ArrayList<Particle>();
  }
  ParticleSystem(PVector origin){
    this.particles = new ArrayList<Particle>();
    this.origin=origin.copy();
  }
  void addParticle(){
    this.particles.add(new Particle(this.origin, 3, random(0,255)));   
  }
  
  // the origin of the particleSystem is randomly placed on the stick
  void updateOrigin(StickLeft StickLeft){ 
  float i = random(1);
  origin.x = int(i*StickLeft.pos1.x + (1-i)*StickLeft.pos2.x);
  origin.y = int(i*StickLeft.pos1.y + (1-i)*StickLeft.pos2.y);
  }  
  
  void action(int forsticks){
    Particle p;
    float previous_theta = theta(frameCount-1); // previous theta
    for(int i=this.particles.size()-1; i>=0; i--){
      p=this.particles.get(i);
      // When mousePressed, particles get wilder
      if (mousePressed==true){force1=10; p.lifespan+=2;}; // can be mapped with a special effect, such as the shaker instead of mouseP
      // When sticks are hiting, particles bounce 
      if ((theta>-0.03)&&(theta>previous_theta)&&(forsticks==1)){p.applyForce(new PVector(force1*random(-0.1,0.1), -0.3*force1));}
      p.applyForce(new PVector(force1*random(-0.1, 0.1), force1* random(-0.1,0.1)));
      force1=1; // reset force1

      p.action();
      p.lifespan-=3;
      if(p.isDead()){
         particles.remove(i);
         this.addParticle();
      }
    
    }
  }

}
