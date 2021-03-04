import netP5.*;
import oscP5.*;

// Framerate
int fps=60;        // Framerate per seconds
// Modes and levels
boolean level2=false, previouslevel2;
boolean darkmode = false;
boolean exDarkmode = false;
int luminosityTreshold = 8;
int countdownLevelOne = 10 * 1000; // 10 seconds


// Connexion
OscP5 oscP5;
NetAddress superColliderLocation;

// List of the connected IPs
ArrayList<String> IPdevices;

int minAcc = 4;
float minPeriodBtwShaking = 400; //ms
int numberOfUsers = 3;

// Variables in arrays for all the users
float[] pitchs = new float[numberOfUsers];
float[] rolls = new float[numberOfUsers];
float[] luminosities = new float[numberOfUsers];
boolean[] orientationsUpdated = new boolean[numberOfUsers];
String[] exPositions = new String[numberOfUsers];
String[] positions = new String[numberOfUsers];
float[][] accelerationBuffers = new float[numberOfUsers][];
float[] lastShakeTimes = new float[numberOfUsers];
float lastShakeTimeTogether;
float[] lastActivityTimes = new float[numberOfUsers];

// Tree
Warlitree redTree, greenTree, blueTree;
// Birds
BirdArray Birds;
// Background
Background bg; 

Character[] people;
int populationSize;
int stickmenYcoor = 720;


void setup() {
  frameRate(fps); 
  size(1200, 800); 

  // VISUAL
  bg = new Background();
  Birds = new BirdArray(); 
  redTree = new Warlitree(new PVector(0, 350), PI/6, "red"); 
  greenTree = new Warlitree(new PVector(width/2, -10), PI-PI/12, "green");
  blueTree = new Warlitree(new PVector(width, 400), -PI/6, "blue");

  populationSize = 18;
  people = new Character[populationSize];
  for (int i=0; i<populationSize; i++) {
    people[i] = new Character(random(95, 115), random(1, 2), stickmenYcoor);
  }

  // OSC
  /* start oscHook. go to IP/port setup. Look at the port value in oscHook*/
  /* change the port numner in the line below to what you just saw on oscHook */
  /* for the example below, the port number is 7400 */
  /* If it doesn't work, try also to change 127.0.0.1 into your pc IPV4 adress.
  /* You can also try to change the sending rate on your OSC app.*/
  oscP5 = new OscP5(this, 7400);
  superColliderLocation = new NetAddress("127.0.0.1", 57120);
  OscMessage m = new OscMessage("/processing/start");
  m.add(1);
  oscP5.send(m, superColliderLocation);
  IPdevices = new ArrayList<String>();
  lastShakeTimeTogether = 0;
  // Initialisation of the user OSC variables
  for (int i=0; i<numberOfUsers; i++) {
    orientationsUpdated[i] = false;
    luminosities[i] = 2*luminosityTreshold;
    lastShakeTimes[i] = 0;
    lastActivityTimes[i] = 0;
    accelerationBuffers[i] = new float[12];  // Keeping the 12 last messages (4 timestams, 3 dimention), to be sure to get the highest intensity of a movement
    exPositions[i] = "init";
  }
}


void draw() {

  //println(frameRate);

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
  updStickmanInterractions();

  previouslevel2 = level2;
}

void updStickmanInterractions() {
  for (Character stick1 : people) {
    for (Character stick2 : people) {
      if (abs(stick1.centerX-stick2.centerX)<1.5 && stick1!=stick2) {
        stick1.jump(5);
        stick2.jump(5);

        OscMessage m = new OscMessage("/stickmen/jumped");
        m.add(1);
        oscP5.send(m, superColliderLocation);
      }
    }
  }
}


//// SHOULD BE MAPPED TO OSC MESSAGES
void mousePressed() {
  greenTree.shake(); // USER2 SHAKING - mapped, ok

  redTree.shake(); // USER 1 SHAKING - mapped, ok
  blueTree.shake(); // USER3 SKAKING - not mapped yet (or is it? feel free to add some TODO: ;) bc easy to ctrl+F, and some IDE even automatically check for TODOs)
  Birds.accelerate(millis());
  level2 = true;

  // Stickmen
  for (Character charact : people) {
    charact.jump(5);
  }
}



// ************** OSC MESSAGES ************** //


void oscEvent(OscMessage theOscMessage) {
  /* check if theOscMessage has the address pattern we are looking for. */

  String address = theOscMessage.netAddress().address();

  if (!IPdevices.contains(address)) {
    IPdevices.add(address);
    println(address+" connected successfully");
  }

  // Checking if the IP sending the message is one of the 3 first in the IPdevices array (bc only 3 players max for now)
  if (IPdevices.indexOf(address)<numberOfUsers) {
    int ipIndex = IPdevices.indexOf(address);
    // Checking if the phone has been shaken. Working with a buffer to attend to get the highest value in an accelleration movement.
    if (theOscMessage.checkAddrPattern("/linear_acceleration/x")==true || theOscMessage.checkAddrPattern("/linear_acceleration/y")==true || theOscMessage.checkAddrPattern("/linear_acceleration/z")==true) {
      accelerationBuffers[ipIndex] = pushInBuffer(accelerationBuffers[ipIndex], theOscMessage.get(0).floatValue());
      if (abs(accelerationBuffers[ipIndex][5])>minAcc && abs(millis()-lastShakeTimes[ipIndex])>minPeriodBtwShaking) {
        lastActivityTimes[ipIndex] = millis();
        float accMaxValue = max(accelerationBuffers[ipIndex]);
        lastShakeTimes[ipIndex]=millis();
        println("IP"+ipIndex+" shaken");
        if (ipIndex==0) {
          redTree.shake(); // 1st USER SHAKING
          for (int i=0; i<populationSize/3; i++) {
            people[i].startWalking();
            people[i].jump(2);
          }
        } else if (ipIndex==1) {
          greenTree.shake(); // 2nd USER SHAKING
          for (int i=populationSize/3; i<2*populationSize/3; i++) {
            people[i].startWalking();
            people[i].jump(2);
          }
        } else if (ipIndex==2) {
          blueTree.shake(); // 3rd USER SHAKING
          for (int i=2*populationSize/3; i<populationSize; i++) {
            people[i].startWalking();
            people[i].jump(2);
          }
        }
        println("shaken");
        OscMessage m = new OscMessage("/IP"+ipIndex+"/shaken");
        m.add(accMaxValue);
        oscP5.send(m, superColliderLocation);
      }
      float[] maxAccPerUser = new float[numberOfUsers];
      for (int j=0; j<numberOfUsers; j++) {
        maxAccPerUser[j] = max(accelerationBuffers[j]);
      }
      if (min(maxAccPerUser)>minAcc) {  // Everyone shaking at the same time
        level2 = true;
        lastShakeTimeTogether = millis();
        OscMessage m = new OscMessage("/level2");
        m.add(true);
        oscP5.send(m, superColliderLocation);
        println("LEVEL 2");
        for (int i=0; i<populationSize; i++) {
          people[i].setDancingAmplitude(45);
          people[i].setWalkingAmplitude(45);
          people[i].setWalkingSpeed(random(1.5, 3));
        }
      } else if (millis()-lastShakeTimeTogether>countdownLevelOne) {  // No together shaking for a certain amount of time
        level2 = false;
        lastShakeTimeTogether = millis(); // Just to avoid getting in this block each frame
        OscMessage m = new OscMessage("/level2");
        m.add(false);
        oscP5.send(m, superColliderLocation);
        println("LEVEL 1");
        for (int i=0; i<populationSize; i++) {
          people[i].setDancingAmplitude(30);
          people[i].setWalkingAmplitude(30);
          people[i].setWalkingSpeed(random(1, 2));
        }
      }
    }

    // Updating the orientation of the phone
    else if (theOscMessage.checkAddrPattern("/orientation/beta")==true) {
      pitchs[ipIndex] = theOscMessage.get(0).floatValue();   // Between -90 (phone pointing down) and +90 (phone pointing up) (and 0 when phone horizontally pointing towards you..) 
      //println("IP"+ipIndex+" pitch: "+pitchs[ipIndex]);
      orientationsUpdated[ipIndex] = true;
    } else if (theOscMessage.checkAddrPattern("/orientation/gamma")==true) {
      rolls[ipIndex] = theOscMessage.get(0).floatValue();    // To move between -90 (phone on its right spine) and +90 (phone on its left spine) (and 0 when phone at flat position) 
      //println("IP"+ipIndex+" roll: "+rolls[ipIndex]);
      orientationsUpdated[ipIndex] = true;
    } else if (theOscMessage.checkAddrPattern("/light")==true) {
      luminosities[ipIndex] = theOscMessage.get(0).floatValue();
      if (min(luminosities)<luminosityTreshold) {  // TODO: figure out if we rather want the mean under a certain treshold, etc...
        darkmode=true;
        for (int i=0; i<populationSize; i++) {
          people[i].setDancingAmplitude(15);
          people[i].setWalkingAmplitude(15);
          people[i].setWalkingSpeed(random(0.5, 1));
        }
      } else {
        darkmode=false;
        for (int i=0; i<populationSize; i++) {
          people[i].setDancingAmplitude(30);
          people[i].setWalkingAmplitude(30);
          people[i].setWalkingSpeed(random(1, 2));
        }
      }
      if (darkmode != exDarkmode) {
        exDarkmode = darkmode;
        OscMessage m = new OscMessage("/IP"+ipIndex+"/luminosity");
        m.add(luminosities[ipIndex]);
        oscP5.send(m, superColliderLocation);
      }
    }
    //TODO: last tmhing with distance btw phone ? (each phone needs to have exposure notifications on)

    // Updating the "category" of the Position
    if (orientationsUpdated[ipIndex]) {
      orientationsUpdated[ipIndex] = false;  // Reseting it to detect if then it was updated by this incomming message, or through pitch, or roll
      exPositions[ipIndex] = positions[ipIndex];
      if (-45<pitchs[ipIndex] && pitchs[ipIndex]<45) {
        if (-45<rolls[ipIndex] && rolls[ipIndex]<45) {
          positions[ipIndex] = "Position A";
        } else if (rolls[ipIndex]>45) {
          positions[ipIndex] = "Position B";
        } else {
          positions[ipIndex] = "Position C";
        }
      } else if (pitchs[ipIndex]>45) {
        positions[ipIndex] = "Position B";
      } else {
        positions[ipIndex] = "Position C";
      }
      if (positions[ipIndex] != exPositions[ipIndex]) {
        println("IP"+ipIndex+" position: "+positions[ipIndex]);
        lastActivityTimes[ipIndex] = millis();
        for (int i=ipIndex*populationSize/numberOfUsers; i<(ipIndex+1)*populationSize/numberOfUsers; i++) {
          people[i].startDancing();
        }
        OscMessage m = new OscMessage("/IP"+ipIndex+"/position");
        m.add(positions[ipIndex]);
        oscP5.send(m, superColliderLocation);
      }

      // Updating the visual according to the pattern:
      //GrowingArray_yellow.opac = (drumPattern=="Pattern A") ? 200 : 60;
      //GrowingArray_white.opac = (drumPattern=="Pattern B") ? 200 : 60;
      //GrowingArray_green.opac = (drumPattern=="Pattern C") ? 200 : 60;
    }
  } else {
    println("Too many devices connected (max 3)");
  }
}


float[] pushInBuffer(float[] a, float element) {
  float[] b = new float[a.length];
  b[0] = element;
  System.arraycopy(a, 0, b, 1, a.length-1);
  return b;
}
