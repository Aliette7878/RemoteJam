import netP5.*;
import oscP5.*;

// Connexion
OscP5 oscP5;
NetAddress superColliderLocation;

// List of the connected IPs
ArrayList<String> IPdevices;

// Variables for IP 
float IP1Pitch;
float IP1Roll;
boolean orientationUpdated;
String drumPattern;

float linearAcc;
float lastShakeTime;
int minAcc = 6;

// Variables for IP 2
float IP2Pitch;
float IP2Roll;
String timbre;

// Variables
PImage bg; 
PImage scrolling_img;
float drum_period=500;
SvgPic Drum0;
ScrollingObject ScrollingAfrican0, ScrollingAfrican1;
GrowingTree GrowingTree0;
ProcessingTree PTree0;                                 
GrowingArray GrowingArray_green,GrowingArray_white,GrowingArray_yellow ;


void setup() {
  frameRate(60); // default frameRate = 60/sec = 3600/min --> How to synchronize with supercollider ? 
  size(1200,800); // Switch to full size ?
  
  // Images
  bg = loadImage("Asset 7.png"); // Can also try Savane1 or Savane2
  bg.resize(width,height);
  scrolling_img = loadImage("frise1.png");
  scrolling_img.resize(width, int(height/10));
  
  // Scrolling bars
  ScrollingAfrican1 = new ScrollingObject(scrolling_img, 1, 0,0);
  ScrollingAfrican0 = new ScrollingObject(scrolling_img, 0, 0, height-scrolling_img.height);
  
  // Arrays of trees
  GrowingArray_green = new GrowingArray(800, 100, 15, 50, PI/3, color(0,255,0), 60);  // (inx, iny, 15 trees, 50 pxls of distance, green, 255 opacity) 
  GrowingArray_white = new GrowingArray(200, 100, 15, 50, PI/3, color(255), 60);
  GrowingArray_yellow = new GrowingArray(320, 100, 15, 50, PI/3, color(255,255,0), 60);

  // Drum
  Drum0 = new SvgPic("djembe.svg", 391, 240, drum_period);
  Drum0.svg.scale(0.85);
  
  // Processing Tree
  PTree0 = new ProcessingTree(new PVector(width-220,height-82)); // Inspired by a Processing tutorial
  
  
  /* start oscHook. go to IP/port setup. Look at the port value in oscHook*/
  /* change the port numner in the line below to what you just saw on oscHook */
  /* for the example below, the port number is 7400 */
  /* If it doesn't work, try also to change 127.0.0.1 into your pc IPV4 adress.
  /* You can also try to change the sending rate on your OSC app.*/
  oscP5 = new OscP5(this, 7400);
  superColliderLocation = new NetAddress("127.0.0.1", 57120);
  lastShakeTime = 0;
  IPdevices = new ArrayList<String>();
}


void draw(){
  
  background(bg);
  
  ScrollingAfrican1.scroll();
  ScrollingAfrican0.scroll(); 

  GrowingArray_green.display();
  GrowingArray_white.display();
  GrowingArray_yellow.display();

  Drum0.display();
  //PTree0.angle =(mouseX / (float) width) * 90f;
  //PTree0.size =(mouseY / (float) height) *130;
  PTree0.display(); // Careful to always display this tree at the very end (issues with translate(), will solve it later)
}

// Visual parameters linked to OSC messages //
// User 1 - continuous : angle of PTree0 = PTree0.angle (line 71-72-73) for now linked to the mouse, in [0-90°], or [20-70°] if you prefer the style
// User 2 - continuous : size of PTree0 = PTree0.size (line 71) for now linked to the mouse, in [0 - 130], or [20-120], less weird

// Pattern A - yes/no : opacity of the GrowingArray = GrowingArray_yellow.opac; should be mapped in {60 ; 200} (line 69, example)
// Pattern B - yes/no : opacity of the GrowingArray = GrowingArray_white.opac; should be mapped in {60 ; 200}, 60=no, 200=yes
// Pattern C - yes/no : opacity of the GrowingArray = GrowingArray_green.opac; should be mapped in {60 ; 200}, 60=no, 200=yes



void oscEvent(OscMessage theOscMessage) {
  /* check if theOscMessage has the address pattern we are looking for. */
  
  String address = theOscMessage.netAddress().address();
  
  if(!IPdevices.contains(address)){
    IPdevices.add(address);
    println(address+" connected successfully");
  }

  // the First IP received will be given for role the drum machine. the orientation of the phone will determine the pattern of the rythm, and shaking the phone will result into a "crash" hit.
  if(IPdevices.indexOf(address)==0){
    
    orientationUpdated = false;  // Reseting it to detect if then it was updated by this incomming message, or through pitch, or roll

    // Checking if the phone has been shaken.
    if (theOscMessage.checkAddrPattern("/accelerometer/linear/x")==true || theOscMessage.checkAddrPattern("/accelerometer/linear/y")==true || theOscMessage.checkAddrPattern("/accelerometer/linear/z")==true) {
      linearAcc = theOscMessage.get(0).floatValue();
      if(abs(linearAcc)>minAcc && abs(1000*second()+millis()-lastShakeTime)>400){
        lastShakeTime=1000*second()+millis();
        println("IP1 shaken");
        
        OscMessage m = new OscMessage("/IP1/shaken");
        m.add(1);
        oscP5.send(m, superColliderLocation);
      }
    }

    // Updating the orientation of the phone
    else if (theOscMessage.checkAddrPattern("/orientation/pitch")==true) {
      IP1Pitch = theOscMessage.get(0).floatValue();   // Between -90 (phone pointing down) and +90 (phone pointing up) (and 0 when phone horizontally pointing towards you..) 
      //println("IP1 pitch: "+IP1Pitch);
      orientationUpdated = true;
    }
  
    else if (theOscMessage.checkAddrPattern("/orientation/roll")==true) {
      IP1Roll = theOscMessage.get(0).floatValue();    // To move between -90 (phone on its right spine) and +90 (phone on its left spine) (and 0 when phone at flat position) 
      //println("IP1 roll: "+IP1Roll);
      orientationUpdated = true;
      
      PTree0.angle = (IP1Roll+110)/2.5;  // [8°-80°]
    }
    
    // Updating the category for the rythmic pattern
    if(orientationUpdated){
      if(-45<IP1Pitch && IP1Pitch<45){
        if(-45<IP1Roll && IP1Roll<45){
          drumPattern = "Pattern A";
        }
        else if(IP1Roll>45){
          drumPattern = "Pattern B";
        }
        else{
          drumPattern = "Pattern C";
        }
      }
      else if(IP1Pitch>45){
        drumPattern = "Pattern B";  // could be D if we augment the number of pattern
      }
      else{
        drumPattern = "Pattern C";  // could be E if we augment the number of pattern
      }
      
      println("IP1 pattern: "+drumPattern);
      
      OscMessage m = new OscMessage("/IP1/pattern");
      m.add(drumPattern);
      oscP5.send(m, superColliderLocation);
      
      // Updating the visual according to the pattern:
      GrowingArray_yellow.opac = (drumPattern=="Pattern A") ? 200 : 60;
      GrowingArray_white.opac = (drumPattern=="Pattern B") ? 200 : 60;
      GrowingArray_green.opac = (drumPattern=="Pattern C") ? 200 : 60;
    }
  }
  
  // The second IP (player) controlls the melodical part.
  else if(IPdevices.indexOf(address)==1){
  
    if (theOscMessage.checkAddrPattern("/orientation/pitch")==true) {
      IP2Pitch = theOscMessage.get(0).floatValue();  // Between -90 (phone pointing up) and +90 (phone pointing down) (and 0 when phone horizontally pointing towards you..)
      println("IP2 pitch: "+IP2Pitch);
      
      OscMessage m = new OscMessage("/IP2/pitch");
      m.add(IP2Pitch);
      oscP5.send(m, superColliderLocation);
      
      PTree0.size = (130-IP2Pitch)/2;   // [20-110]
    }
    
    // Checking if the phone has been shaken. //THIS SHOULD BE CHANGED LATER BC RIGHT NOW IT SENDS IT AS THE 1ST USER
    if (theOscMessage.checkAddrPattern("/accelerometer/linear/x")==true || theOscMessage.checkAddrPattern("/accelerometer/linear/y")==true || theOscMessage.checkAddrPattern("/accelerometer/linear/z")==true) {
      linearAcc = theOscMessage.get(0).floatValue();
      if(abs(linearAcc)>minAcc && abs(1000*second()+millis()-lastShakeTime)>400){
        lastShakeTime=1000*second()+millis();
        println("IP2 shaken");
        
        OscMessage m = new OscMessage("/IP2/shaken");
        m.add(1);
        oscP5.send(m, superColliderLocation);
      }
    }
    
    else if (theOscMessage.checkAddrPattern("/orientation/roll")==true) {
      IP2Roll = theOscMessage.get(0).floatValue();    // To move between -90 (phone on its right spine) and +90 (phone on its left spine) (and 0 when phone at flat position) 
      //println("IP2 roll: "+telephone2Roll);
      
      if(IP2Roll<-45){ timbre = "timbre A";}
      else if(IP2Roll>45){ timbre = "timbre C";}
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
