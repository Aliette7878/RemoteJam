import netP5.*;
import oscP5.*;

// Framerate
int fps=60;        // Framerate per seconds
// Modes and levels
boolean level2=false, previouslevel2;
boolean darkmode = true;


// Connexion
OscP5 oscP5;
NetAddress superColliderLocation;

// List of the connected IPs
ArrayList<String> IPdevices;

int minAcc = 6;
float minPeriodBtwShaking = 400; //ms

int numberOfUsers = 3;
// Variables in arrays for all the users
float[] pitchs = new float[numberOfUsers];
float[] rolls = new float[numberOfUsers];
boolean[] orientationsUpdated = new boolean[numberOfUsers];
String[] exPositions = new String[numberOfUsers];
String[] positions = new String[numberOfUsers];
float[][] accelerationBuffers = new float[numberOfUsers][];
float[] lastShakeTimes = new float[numberOfUsers];
float[] lastActivityTimes = new float[numberOfUsers];

// Tree
Warlitree redTree, greenTree, blueTree;
// Birds
BirdArray Birds;
// Background
Background bg; 

Character[] people;
int populationSize;


void setup() {
  frameRate(fps); 
  size(1200, 800); 

  // VISUAL
  bg = new Background();
  Birds = new BirdArray(); 
  redTree = new Warlitree(new PVector(0, 400), PI/12, "red"); 
  greenTree = new Warlitree(new PVector(width/2, 0), PI-PI/12, "green");
  blueTree = new Warlitree(new PVector(width, 400), -PI/6, "blue");

  populationSize = 15;
  people = new Character[populationSize];
  for (int i=0; i<populationSize; i++) {
    people[i] = new Character(random(85, 105), random(1.5, 5), 680);
  }
  // Stickmen
  for (Character charact : people) {
    charact.dancing=false;
  }

  // OSC
  /* start oscHook. go to IP/port setup. Look at the port value in oscHook*/
  /* change the port numner in the line below to what you just saw on oscHook */
  /* for the example below, the port number is 7400 */
  /* If it doesn't work, try also to change 127.0.0.1 into your pc IPV4 adress.
  /* You can also try to change the sending rate on your OSC app.*/
  oscP5 = new OscP5(this, 7400);
  superColliderLocation = new NetAddress("127.0.0.1", 57120);
  IPdevices = new ArrayList<String>();
  // Initialisation of the user OSC variables
  for (int i=0; i<numberOfUsers; i++) {
    orientationsUpdated[i] = false;
    lastShakeTimes[i] = 0;
    lastActivityTimes[i] = 0;
    accelerationBuffers[i] = new float[6];  // Keeping the 6 last messages (2 timestams, 3 dimention), to be sure to get the highest intensity of a movement
    exPositions[i] = "init";
  }
}


void draw() {

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
  
  previouslevel2 = level2;

}


// SHOULD BE MAPPED TO OSC MESSAGES
void mousePressed() {
    greenTree.shake(); // USER2 SHAKING - mapped, ok

  redTree.shake(); // USER 1 SHAKING - mapped, ok
  blueTree.shake(); // USER3 SKAKING - not mapped yet (or is it? feel free to add some TODO: ;) bc easy to ctrl+F, and some IDE even automatically check for TODOs)
  Birds.accelerate(millis());
  level2 = true;
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
    if (theOscMessage.checkAddrPattern("/accelerometer/linear/x")==true || theOscMessage.checkAddrPattern("/accelerometer/linear/y")==true || theOscMessage.checkAddrPattern("/accelerometer/linear/z")==true) {
      accelerationBuffers[ipIndex] = pushInBuffer(accelerationBuffers[ipIndex], theOscMessage.get(0).floatValue());
      if (abs(accelerationBuffers[ipIndex][5])>minAcc && abs(1000*second()+millis()-lastShakeTimes[ipIndex])>minPeriodBtwShaking) {
        lastActivityTimes[ipIndex]=1000000*minute()+1000*second()+millis();
        float accMaxValue = max(accelerationBuffers[ipIndex]);
        lastShakeTimes[ipIndex]=1000*second()+millis();
        println("IP"+ipIndex+" shaken");
        if (ipIndex==0) {
          redTree.shake(); // 1st USER SHAKING
        } else if (ipIndex==1) {
          greenTree.shake(); // 2nd USER SHAKING
        } else if (ipIndex==2) {
          blueTree.shake(); // 3rd USER SHAKING
        }

        OscMessage m = new OscMessage("/IP"+ipIndex+"/shaken");
        m.add(accMaxValue);
        oscP5.send(m, superColliderLocation);
      }
    }

    // Updating the orientation of the phone
    else if (theOscMessage.checkAddrPattern("/orientation/pitch")==true) {
      pitchs[ipIndex] = theOscMessage.get(0).floatValue();   // Between -90 (phone pointing down) and +90 (phone pointing up) (and 0 when phone horizontally pointing towards you..) 
      //println("IP"+ipIndex+" pitch: "+pitchs[ipIndex]);
      orientationsUpdated[ipIndex] = true;
    } else if (theOscMessage.checkAddrPattern("/orientation/roll")==true) {
      rolls[ipIndex] = theOscMessage.get(0).floatValue();    // To move between -90 (phone on its right spine) and +90 (phone on its left spine) (and 0 when phone at flat position) 
      //println("IP"+ipIndex+" roll: "+rolls[ipIndex]);
      orientationsUpdated[ipIndex] = true;
    }

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
        positions[ipIndex] = "Position D";
      } else {
        positions[ipIndex] = "Position E";
      }
      if (positions[ipIndex] != exPositions[ipIndex]) {lastActivityTimes[ipIndex]=1000000*minute()+1000*second()+millis();}

      println("IP"+ipIndex+" position: "+positions[ipIndex]);

      OscMessage m = new OscMessage("/IP"+ipIndex+"/position");
      m.add(positions[ipIndex]);
      oscP5.send(m, superColliderLocation);

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
