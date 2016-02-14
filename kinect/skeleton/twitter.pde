///*
//** http://codasign.com/tutorials/processing-and-twitter/
//** 
//** need to create a tab called "twitterKeys" to store your keys
//** consumerKey, consumerSecret, accessToken, and accessTokenSecret
//*/

//import twitter4j.conf.*;
//import twitter4j.*;
//import twitter4j.auth.*;
//import twitter4j.api.*;

//import java.util.*;

//HashMap seenTweets;

//Twitter twitter;
//List<Status> tweets;
//String searchQuery = "@sigmusicuiuc";
//String prevTweet = "";

//// update delay in seconds
//int updateDelay = 10;

//void setupTwitter() {
//  // setting up being able to only accept new tweets
//  seenTweets = new HashMap();
  
//  // Twitter initialization
//  ConfigurationBuilder cb = new ConfigurationBuilder();
//  cb.setOAuthConsumerKey(consumerKey);
//  cb.setOAuthConsumerSecret(consumerSecret);
//  cb.setOAuthAccessToken(accessToken);
//  cb.setOAuthAccessTokenSecret(accessTokenSecret);

//  TwitterFactory tf = new TwitterFactory(cb.build());

//  twitter = tf.getInstance(); 
  
//  getNewTweets(searchQuery);
  
  
   
//  // starts a thread that constantly refreshes the tweets
//  thread("refreshTweets");
//}

//void getNewTweets(String searchString)
//{
//    try
//    {
//        Query query = new Query(searchString);

//        QueryResult result = twitter.search(query);

//        tweets = result.getTweets();
//    }
//    catch (TwitterException te)
//    {
//        System.out.println("Failed to search tweets: " + te.getMessage());
//        System.exit(-1);
//    }
//}

//void refreshTweets()
//{
//    while (true)
//    {
//        getNewTweets(searchQuery);
//        try {
//          println("array length:" + tweets.size());
//          Status status = tweets.get(0);
//          String curTweet = status.getText();
//          if (!curTweet.equals(prevTweet))
//          {
//            // a tweet was found
//            prevTweet = status.getText();
//            println(curTweet);
//          }
//        }
//        catch(Exception e) {
//          System.out.println("No Tweets found");
//        }
//        println("Updated Tweets");

//        delay(updateDelay * 1000);
//    }
//}

//void sendOSCTwitter() {
//  // do stuff
//  OscMessage msg = new OscMessage("/twitter");     
//  sendOSCMessage(msg);
//}