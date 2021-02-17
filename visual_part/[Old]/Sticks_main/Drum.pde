class Drum {
  PVector position; // Position
  PImage img;
  ArrayList<Particle> particles;


  Drum(String name, float posx, float posy, float period) {
    img = loadImage("DrumForPart.jpg");
    img.resize(0, 400);
    position = new PVector(posx,posy);
    this.particles = new ArrayList<Particle>();
  }
  
  
  void addParticle(){
      int x = int(random(img.width));
      int y = int(random(img.height));
      color pix = img.get(x, y);
      float lifespan = 255-brightness(pix);
      this.particles.add(new Particle(new PVector(x+this.position.x,y+this.position.y), 3, lifespan));   
  }
  
  void display(){
      Particle p;
      float force1 = 1;
      for(int i=this.particles.size()-1; i>=0; i--){
        p=this.particles.get(i);
        if (mousePressed==true){force1=100; p.lifespan+=2;}; // can be mapped with a special effect, such as the shaker instead of mouseP
        p.applyForce(new PVector(force1*random(-0.01, 0.01), force1*random(-0.01,0.01)));
        p.action();
        p.lifespan-=3;
        if(p.isDead()){
           particles.remove(i);
           this.addParticle();
      }
  }
}
}
