import netP5.*;
import oscP5.*;


OscP5 oscP5;
NetAddress myRemoteLocation;

float accelX;
float accelY;
float accelZ;

PImage img;
float posX;
float posY;
float speedX;
float speedY;

float lastAccTime;

int minAcc = 5;
 
void setup()
{
  
  size(1000, 800);
  frameRate(25);
  
  /* start oscHook. go to IP/port setup. Look at the port value in oscHook*/
  /* change the port numner in the line below to what you just saw on oscHook */
  /* for the example below, the port number is 7400 */
  oscP5 = new OscP5(this, 7400);
  
  img = loadImage("flying-birds-clip-art_666444.png");
  
  posX = width/2-width/20;
  posY = height/2-height/20;
  speedX = 0;
  speedY = 0;
  lastAccTime = 0;
}
 
void draw()
{
  background(255);
  posX += speedX/5;
  posY += speedY/5;
  if(posX<0){
    posX += width;
  }
  else if(posX>width){
    posX -= width;
  }
  if(posY<0){
    posY += height;
  }
  else if(posY>height){
    posY -= height;
  }
  image(img, posX, posY, width/10, height/10);
}


void oscEvent(OscMessage theOscMessage) {
  /* check if theOscMessage has the address pattern we are looking for. */
  
  //println(theOscMessage);


  if (theOscMessage.checkAddrPattern("/accelerometer/raw/x")==true) {
    accelX = theOscMessage.get(0).floatValue();
    if(abs(accelX)>minAcc && abs(1000*second()+millis()-lastAccTime)>500){
      speedX = accelX;
      lastAccTime=1000*second()+millis();
      println("speedX: "+speedX+", speedY: "+speedY);
    }
  }
  
  if (theOscMessage.checkAddrPattern("/accelerometer/raw/y")==true) {
    accelY = theOscMessage.get(0).floatValue();
    if(abs(accelY)>minAcc && abs(1000*second()+millis()-lastAccTime)>500){
      speedY = accelY;
      lastAccTime=1000*second()+millis();
      println("speedX: "+speedX+", speedY: "+speedY);
    }
  }
  /*
  if (theOscMessage.checkAddrPattern("/accelerometer/raw/z")==true) {
    accelZ = theOscMessage.get(0).floatValue();  
    println("z: "+accelZ);
  }
  */
}
