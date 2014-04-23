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

  //  queryTwitter();
}

void draw() {

  background(0);

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
  query = new Query("#SCIBeacon");
  query.setCount(10);
  try {
    QueryResult result = twitter.search(query);
    List<Status> tweets = result.getTweets();
    println("Latest Memories from #SCIBeacon : ");
    for (Status tw : tweets) {
      msg = tw.getText();
      println(msg);
    }
    if (msg != null) {
      msgIsNull = false;
      println ("message was not null");
    } 
    else {
      println ("message was null");
    }
  }
  catch (TwitterException te) {
    println("Couldn't connect: " + te);
  }
}

