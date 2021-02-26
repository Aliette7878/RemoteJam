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

// Tree
Warlitree redTree, greenTree, blueTree;
// Birds
BirdArray Birds;
// Background
Background bg; 

//Stickmen
Character[] people;
int populationSize;



void setup() {
  frameRate(120); 
  size(1200,800); 
  
  // VISUAL
  bg = new Background();
  Birds = new BirdArray(); 
  redTree = new Warlitree(new PVector(0,400),PI/12, "red"); 
  greenTree = new Warlitree(new PVector(width/2,0),PI-PI/12, "green");
  blueTree = new Warlitree(new PVector(width,400),-PI/6, "blue");
  
  // Stickmen
  populationSize = 15;
  people = new Character[populationSize];
  for (int i=0; i<populationSize; i++) {
    people[i] = new Character(random(85,105),random(1.5,5),680);
  }
  
  // OSC
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
  
  println(frameRate);
  
  bg.draw_background();
  Birds.display();
  redTree.display();
  greenTree.display();
  blueTree.display();
  
  // Stickmen
  for (Character charact : people) {
    charact.UpdateChar();
    charact.DrawCharacter();
  }
  
}


// SHOULD BE MAPPED TO OSC MESSAGES
void mousePressed(){ 
  redTree.shake(); // USER 1 SHAKING - mapped, ok
  greenTree.shake(); // USER2 SHAKING - mapped, ok
  blueTree.shake(); // USER3 SKAKING - not mapped yet
  Birds.accelerate(millis()); 
  println(millis());
  
  // Stickmen
  for (Character charact : people) {
    charact.dancing=false;
  }
}







// ************** OSC MESSAGES ************** //



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
        redTree.shake(); // USER 1 SHAKING
        
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
      
      //PTree0.angle = (IP1Roll+110)/2.5;  // [8°-80°]
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
      //GrowingArray_yellow.opac = (drumPattern=="Pattern A") ? 200 : 60;
      //GrowingArray_white.opac = (drumPattern=="Pattern B") ? 200 : 60;
      //GrowingArray_green.opac = (drumPattern=="Pattern C") ? 200 : 60;
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
      
      //PTree0.size = (130-IP2Pitch)/2;   // [20-110]
    }
    
    // Checking if the phone has been shaken. //THIS SHOULD BE CHANGED LATER BC RIGHT NOW IT SENDS IT AS THE 1ST USER
    if (theOscMessage.checkAddrPattern("/accelerometer/linear/x")==true || theOscMessage.checkAddrPattern("/accelerometer/linear/y")==true || theOscMessage.checkAddrPattern("/accelerometer/linear/z")==true) {
      linearAcc = theOscMessage.get(0).floatValue();
      if(abs(linearAcc)>minAcc && abs(1000*second()+millis()-lastShakeTime)>400){
        lastShakeTime=1000*second()+millis();
        println("IP2 shaken");
        greenTree.shake(); // USER 1 SHAKING

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
