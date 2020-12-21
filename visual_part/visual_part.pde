import netP5.*;
import oscP5.*;


OscP5 oscP5;
NetAddress superColliderLocation;

float accelX;
float accelY;
float accelZ;

PImage img;
float posX;
float posY;
float speedX;
float speedY;

float azimuthOrientation;
float pitchOrientation;
float rollOrientation;

float lastAccTime;

int minAcc = 5;

ArrayList<String> IPdevices;
 
void setup()
{
  
  size(1000, 800);
  frameRate(25);
  
  /* start oscHook. go to IP/port setup. Look at the port value in oscHook*/
  /* change the port numner in the line below to what you just saw on oscHook */
  /* for the example below, the port number is 7400 */
  /* If it doesn't work, try also to change 127.0.0.1 into your pc IPV4 adress.
  /* You can also try to change the sending rate on your OSC app.*/
  oscP5 = new OscP5(this, 7400);
  superColliderLocation = new NetAddress("127.0.0.1", 57120);
  
  img = loadImage("flying-birds-clip-art_666444.png");
  
  posX = width/2-width/20;
  posY = height/2-height/20;
  speedX = 0;
  speedY = 0;
  lastAccTime = 0;
  
  IPdevices = new ArrayList<String>();
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
  
  String address = theOscMessage.netAddress().address();
  
  if(!IPdevices.contains(address)){
    IPdevices.add(address);
    println(address+" connected successfully");
  }
  // forwarding the message to SC (need to be reformated depending on the IP?)
  oscP5.send(theOscMessage, superColliderLocation);

// the First IP received will be given for role the drum machine. the orientation of the phone will determine the pattern of the rythm, and shaking the phone will result into a "crash" hit.
  if(IPdevices.indexOf(address)==0){

    if (theOscMessage.checkAddrPattern("/accelerometer/raw/x")==true) {
      accelX = theOscMessage.get(0).floatValue();
      if(abs(accelX)>minAcc && abs(1000*second()+millis()-lastAccTime)>500){
        speedX = accelX;
        lastAccTime=1000*second()+millis();
        //println("speedX: "+speedX+", speedY: "+speedY);
      }
    }
    
    if (theOscMessage.checkAddrPattern("/accelerometer/raw/y")==true) {
      accelY = theOscMessage.get(0).floatValue();
      if(abs(accelY)>minAcc && abs(1000*second()+millis()-lastAccTime)>500){
        speedY = accelY;
        lastAccTime=1000*second()+millis();
        //println("speedX: "+speedX+", speedY: "+speedY);
      }
    }
  
    if (theOscMessage.checkAddrPattern("/accelerometer/raw/z")==true) {
      accelZ = theOscMessage.get(0).floatValue();  
      //println("z: "+accelZ);
    }
    
    
  
    if (theOscMessage.checkAddrPattern("/orientation/azimuth")==true) {
      azimuthOrientation = theOscMessage.get(0).floatValue();  
      println("azimuth: "+azimuthOrientation);
    }
  
    if (theOscMessage.checkAddrPattern("/orientation/pitch")==true) {
      pitchOrientation = theOscMessage.get(0).floatValue();  
      println("pitch: "+pitchOrientation);
    }
  
    if (theOscMessage.checkAddrPattern("/orientation/roll")==true) {
      rollOrientation = theOscMessage.get(0).floatValue();  
      println("roll: "+rollOrientation);
    }
  }
  
  else if(IPdevices.indexOf(address)==1){
    println("message from IP1, not implemented yet");
  }
  else{
    println("Too many devices connected (max 2)");
  }
  
}
