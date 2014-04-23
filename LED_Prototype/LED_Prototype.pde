import twitter4j.util.*;
import twitter4j.*;
import twitter4j.management.*;
import twitter4j.api.*;
import twitter4j.conf.*;
import twitter4j.json.*;
import twitter4j.auth.*;
boolean hasQueriedTwitter = false;

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

  //Acreditacion
  cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey("bfFtHzTKwxpLCrlgDICdL5c7M");
  cb.setOAuthConsumerSecret("7eHcGHAUCpgzOnp17F9v0cQC0Qh5dw2UEVbfNhWkAGrDMjDOnJ");
  cb.setOAuthAccessToken("2413199406-VjHLIDDk0mSFMyhGgD8HjeC7Sfzbljbz1ovhg0V");
  cb.setOAuthAccessTokenSecret("uqrqObhJwqRft49N0LJVTpxhXBapR6Sc74alwVNe4DYwq");

  //Make the twitter object and prepare the query
  twitter = new TwitterFactory(cb.build()).getInstance();

  queryTwitter();
}

void draw() {

  background(0);

  strokeWeight(3);
  stroke(255);

  if (messageReceived) {
    led.on();
    fill(255);
    if (hasQueriedTwitter == false) {
      queryTwitter();
      hasQueriedTwitter = true;
    }
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

void queryTwitter() {
  //BUSCAR NUEVO TWITTER
  query = new Query("#cityghosts");
  query.setCount(10);
  try {
    QueryResult result = twitter.search(query);
    List<Status> tweets = result.getTweets();
    println("New Tweet : ");
    for (Status tw : tweets) {
      String msg = tw.getText();
      println("tweet : " + msg);
    }
  }
  catch (TwitterException te) {
    println("Couldn't connect: " + te);
  }
}

//void timeline() {
//  try {
//    words.clear();
//    User user = twitter.showUser("CGenerativo");
//    println(user.getName());
//    if (user.getStatus() != null) {
//      List statusess = twitter.getUserTimeline(user.getName());
//      screenName = user.getScreenName();
//      for (Status status3 : statusess) {
//        println(status3.getText());
//        words.add(status3.getText());
//      }
//    }
//  }
//  catch(TwitterException te) {
//    println("Couldn't connect: " + te);
//  }
//}

