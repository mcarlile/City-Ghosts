//Twilio+Processing Code:

//import com.twilio.sdk.TwilioRestClient;
//import com.twilio.sdk.TwilioRestException;
//import com.twilio.sdk.resource.factory.SmsFactory;
//import com.twilio.sdk.resource.instance.Account;
//import com.twilio.sdk.resource.instance.Sms;
import com.tinkerkit.*;
import org.firmata.*;
import cc.arduino.*;
import processing.serial.*;
import cc.arduino.*;
import com.tinkerkit.*;

Arduino arduino;

//declare the joystick
TKLed led;

//circle parameters
int r;
float cx, cy;
boolean messageReceived;

//String myPhoneNumber = “(573) 677-4189″;
//String accountSID = “AC9c788fa1cb145edc104210039f6db93e″;
//String authToken = “032375196f5225b536b27c1eb8f81db1″

void setup() {  

  size(256, 256);

  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[5], 57600);      
  //for every tinkerkit component we have to pass
  //the arduino and the port
  led = new TKLed(arduino, TK.O0);

  cx = width/2;
  cy = height/2;
  r = 20;

  smooth();
}

void draw() {

  background(0);

  strokeWeight(3);
  stroke(255);

  if (messageReceived) {
    led.on();
    fill(255);
  } 
  else {
    led.off();
    noFill();
  }

  ellipse(cx, cy, r*2, r*2);
}

void mousePressed() {

  //check if mouse is inside the circle
  float d = dist(mouseX, mouseY, cx, cy);

  if (d < r) {
    messageReceived = !messageReceived;
  }
}

