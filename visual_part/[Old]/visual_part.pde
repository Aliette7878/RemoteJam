// Script not meant to be used anymore

import netP5.*;
import oscP5.*;

// Connexion
OscP5 oscP5;
NetAddress superColliderLocation;


// Bird image
PImage img;
float posX;
float posY;
float speedX;
float speedY;

// List of the connected IPs
ArrayList<String> IPdevices;

// Variables for IP 1
float azimuthOrientation;
float pitchOrientation;
float rollOrientation;
boolean orientationUpdated;
String pattern;

float linearAcc;
float lastShakeTime;
int minAcc = 6;

// Variables for IP 2
float telephone2Inclination;
float telephone2Roll;
String timbre;


 
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
  lastShakeTime = 0;
  
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
  //oscP5.send(theOscMessage, superColliderLocation);

// the First IP received will be given for role the drum machine. the orientation of the phone will determine the pattern of the rythm, and shaking the phone will result into a "crash" hit.
  if(IPdevices.indexOf(address)==0){

    // Checking if the phone has been shaken.
    if (theOscMessage.checkAddrPattern("/accelerometer/linear/x")==true || theOscMessage.checkAddrPattern("/accelerometer/linear/y")==true || theOscMessage.checkAddrPattern("/accelerometer/linear/z")==true) {
      linearAcc = theOscMessage.get(0).floatValue();
      if(abs(linearAcc)>minAcc && abs(1000*second()+millis()-lastShakeTime)>400){
        speedX = linearAcc;
        lastShakeTime=1000*second()+millis();
        println("IP1 shaken");
        
        OscMessage m = new OscMessage("/IP1/shaken");
        m.add(1);
        oscP5.send(m, superColliderLocation);
      }
    }
    
    
    orientationUpdated = false;

    // Updating the orientation of the phone
    //if (theOscMessage.checkAddrPattern("/orientation/azimuth")==true) {
    //  azimuthOrientation = theOscMessage.get(0).floatValue();  
    //  println("azimuth: "+azimuthOrientation);
    //  orientationUpdated = true;
    //}
  
    if (theOscMessage.checkAddrPattern("/orientation/pitch")==true) {
      pitchOrientation = theOscMessage.get(0).floatValue();   // Between -90 (phone pointing down) and +90 (phone pointing up) (and 0 when phone horizontally pointing towards you..) 
      //println("IP1 pitch: "+pitchOrientation);
      orientationUpdated = true;
    }
  
    if (theOscMessage.checkAddrPattern("/orientation/roll")==true) {
      rollOrientation = theOscMessage.get(0).floatValue();    // To move between -90 (phone on its right spine) and +90 (phone on its left spine) (and 0 when phone at flat position) 
      //println("IP1 roll: "+rollOrientation);
      orientationUpdated = true;
    }
    
    // Updating the category for the rythmic pattern
    if(orientationUpdated){
      if(-45<pitchOrientation && pitchOrientation<45){
        if(-45<rollOrientation && rollOrientation<45){
          pattern = "Pattern A";
        }
        else if(rollOrientation>45){
          pattern = "Pattern B";
        }
        else{
          pattern = "Pattern C";
        }
      }
      else if(pitchOrientation>45){
        pattern = "Pattern D";
      }
      else{
        pattern = "Pattern E";
      }
      
      println("IP1 pattern: "+pattern);
      
      OscMessage m = new OscMessage("/IP1/pattern");
      m.add(pattern);
      oscP5.send(m, superColliderLocation);  
    }
  }
  
  // The second IP (player) controlls the melodical part.
  else if(IPdevices.indexOf(address)==1){
  
    if (theOscMessage.checkAddrPattern("/orientation/pitch")==true) {
      telephone2Inclination = theOscMessage.get(0).floatValue();  // Between -90 (phone pointing up) and +90 (phone pointing down) (and 0 when phone horizontally pointing towards you..)
      println("IP2 pitch: "+telephone2Inclination);
      
      OscMessage m = new OscMessage("/IP2/pitch");
      m.add(telephone2Inclination);
      oscP5.send(m, superColliderLocation);
    }
    
    
  
    if (theOscMessage.checkAddrPattern("/orientation/roll")==true) {
      telephone2Roll = theOscMessage.get(0).floatValue();    // To move between -90 (phone on its right spine) and +90 (phone on its left spine) (and 0 when phone at flat position) 
      //println("IP2 roll: "+telephone2Roll);
      
      if(telephone2Roll<-45){ timbre = "timbre A";}
      else if(telephone2Roll>45){ timbre = "timbre C";}
      else{ timbre = "timbre B";}
      
      
      println("IP2 timbre: "+timbre);
      OscMessage m = new OscMessage("/IP2/timbre");
      m.add(timbre);
      oscP5.send(m, superColliderLocation);
      
    }
  }
  else{
    println("Too many devices connected (max 2)");
  }
}
