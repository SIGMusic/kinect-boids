/*
** http://codasign.com/tutorials/processing-and-twitter/
** 
** need to create a tab called "twitterKeys" to store your keys
** consumerKey, consumerSecret, accessToken, and accessTokenSecret
*/

import twitter4j.conf.*;
import twitter4j.*;
import twitter4j.auth.*;
import twitter4j.api.*;

import java.util.*;

String consumerKey = "";
String consumerSecret = "";
String accessToken = "";
String accessTokenSecret = "";

ArrayList<Status> seenTweets;
LinkedList<Status> tweetQueue;

Twitter twitter;
List<Status> tweets;
String searchQuery = "sigmusic eoh";
String curTweet = "";


// update delay in seconds
int queueDelay = 5;

// twitter update delay in order to avoid rate limiting
int twitterDelay = 60;

void setupTwitter() {
 // setting up being able to only accept new tweets
 seenTweets = new ArrayList<Status>();
 tweetQueue = new LinkedList<Status>();
 
 // Twitter initialization
 try {
 ConfigurationBuilder cb = new ConfigurationBuilder();
 cb.setOAuthConsumerKey(consumerKey);
 cb.setOAuthConsumerSecret(consumerSecret);
 cb.setOAuthAccessToken(accessToken);
 cb.setOAuthAccessTokenSecret(accessTokenSecret);

 TwitterFactory tf = new TwitterFactory(cb.build());

 twitter = tf.getInstance(); 
 } catch(Exception e) {
   
 }
     
 // starts a thread that constantly refreshes the tweets
 thread("refreshTweet");
 thread("queueTweets");
}

void getNewTweets(String searchString)
{
   try
   {
       Query query = new Query(searchString);

       QueryResult result = twitter.search(query);

       tweets = result.getTweets();
       for (Status s : tweets) {
         if (!seenTweets.contains(s)) {
           seenTweets.add(s);
           tweetQueue.add(s);
         }
       }
   }
   catch (TwitterException te)
   {
       System.out.println("Failed to search tweets: " + te.getMessage());
       System.exit(-1);
   }
}

void queueTweets() {
  while(true) { 
    getNewTweets(searchQuery); 
    sendOSCTwitter(curTweet);
    try{
      Thread.sleep(twitterDelay * 1000);
    }
    catch(InterruptedException ex) {
      Thread.currentThread().interrupt();
    }
  }
}

void refreshTweet()
{
   while (true)
   {
       // pops from front of queue
       try {
         curTweet = tweetQueue.pop().getText();
         
       }
       catch(Exception e) {
         System.out.println("No Tweets found");
       }
       
       
       try{
          Thread.sleep(queueDelay * 1000);
        }
        catch(InterruptedException ex) {
          Thread.currentThread().interrupt();
        }
   }
}

void sendOSCTwitter(String tweet) {
 // do stuff
 OscMessage msg = new OscMessage("/twitter"); 
 msg.add(tweet.length());
 sendOSCMessage(msg);
}