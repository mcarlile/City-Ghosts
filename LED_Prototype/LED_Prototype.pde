import twitter4j.util.*;
import twitter4j.*;
import twitter4j.management.*;
import twitter4j.api.*;
import twitter4j.conf.*;
import twitter4j.json.*;
import twitter4j.auth.*;
String msg;
boolean hasQueriedTwitter = false;
boolean msgIsNull = true;
int savedTime;
int totalTime = 5000;
int passedTime;
int savedTimeLED;
int totalTimeLED = 100;
int passedTimeLED;
String lastStoredMessage;
boolean lastStoredMessageInitialized = false;
boolean newMessageReceived = false;

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
import twitter4j.conf.*;
import twitter4j.api.*;
import twitter4j.*;
import java.util.*;

ConfigurationBuilder   cb;
Query query;
Twitter twitter;


Arduino arduino;

//declare the joystick
TKLed led;
TKButton but;


//circle parameters
int r;
float cx, cy;
boolean messageReceived;

//String myPhoneNumber = “(573) 677-4189″;
//String accountSID = “AC9c788fa1cb145edc104210039f6db93e″;
//String authToken = “032375196f5225b536b27c1eb8f81db1″


void setup() {  

  size(256, 256);

  arduino = new Arduino(this, Arduino.list()[5], 57600);      
  //for every tinkerkit component we have to pass
  //the arduino and the port
  led = new TKLed(arduino, TK.O0);
  but = new TKButton(arduino, TK.I0);


  cx = width/2;
  cy = height/2;
  r = 20;

  smooth();

  //Acreditacion
  cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey("bfFtHzTKwxpLCrlgDICdL5c7M");
  cb.setOAuthConsumerSecret("7eHcGHAUCpgzOnp17F9v0cQC0Qh5dw2UEVbfNhWkAGrDMjDOnJ");
  cb.setOAuthAccessToken("2413199406-VjHLIDDk0mSFMyhGgD8HjeC7Sfzbljbz1ovhg0V");
  cb.setOAuthAccessTokenSecret("uqrqObhJwqRft49N0LJVTpxhXBapR6Sc74alwVNe4DYwq");

  //Make the twitter object and prepare the query
  twitter = new TwitterFactory(cb.build()).getInstance();
  savedTime = millis();
  savedTimeLED = millis();
  queryTwitter();
}

void draw() {

  background(0);
  // Calculate how much time has passed
  passedTime = millis() - savedTime;
  // Has five seconds passed?
  if (passedTime > totalTime) {
    queryTwitter();
    println( "5 seconds have passed! Checking for new memories..." );
    savedTime = millis(); // Save the current time to restart the timer!
  }
  strokeWeight(3);
  stroke(255);

  //  if (messageReceived) {
  //    led.on();
  //    fill(255);
  //  } 
  //  else {
  //    led.off();
  //    noFill();
  //    hasQueriedTwitter = false;
  //  }

  ellipse(cx, cy, r*2, r*2);

  if (but.read() == TK.HIGH) {
    if (hasQueriedTwitter == false) {
      queryTwitter();
      hasQueriedTwitter = true;
    }
  }
  else {
    hasQueriedTwitter = false;
  };

  if (msgIsNull == false) {
    led.on();
  }
  //  println ("seconds until next check: " + (60 - (passedTime/1000)));

  if (newMessageReceived == false) {
    led.off();
  }
  if (newMessageReceived == true) {
    // Calculate how much time has passed
    passedTimeLED = millis() - savedTimeLED;
    // Has five seconds passed?
    if ((passedTimeLED > 0) &&(passedTimeLED <= totalTimeLED/2)) {
      led.on();
    }
    if (passedTimeLED > totalTimeLED/2) {
      led.off();
    }
    if (passedTimeLED > totalTimeLED) {
      savedTimeLED = millis(); // Save the current time to restart the timer!
    }
  }
}

void mousePressed() {

  //check if mouse is inside the circle
  float d = dist(mouseX, mouseY, cx, cy);

  if (d < r) {
    messageReceived = !messageReceived;
  }
}

void queryTwitter() {
  //BUSCAR NUEVO TWITTER
  query = new Query("#CTIN486Demo");
  query.setCount(1);
  try {
    QueryResult result = twitter.search(query);
    List<Status> tweets = result.getTweets();
    //    println("Latest Memories from #SCIBeacon : ");
    for (Status tw : tweets) {
      msg = tw.getText();
    }
    if (lastStoredMessageInitialized == false) {
      lastStoredMessage = msg;
      lastStoredMessageInitialized = true;
    } 
    else {
      if (lastStoredMessage.equals(msg) == false) {
        lastStoredMessage = msg;
        newMessageReceived = true;
        println("we got a new message: " + msg);
      } 
      else {
        println ("no messages yet");
        newMessageReceived = false;
      }
    }
  }
  catch (TwitterException te) {
    println("Couldn't connect: " + te);
  }
}

