import twitter4j.conf.*;
import twitter4j.*;
import twitter4j.auth.*;
import twitter4j.api.*;

import java.util.*;

Twitter twitter;
List<Status> tweets;

void setupTwitter() {
  ConfigurationBuilder cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey(consumerKey);
  cb.setOAuthConsumerSecret(consumerSecret);
  cb.setOAuthAccessToken(accessToken);
  cb.setOAuthAccessTokenSecret(accessTokenSecret);

  TwitterFactory tf = new TwitterFactory(cb.build());

  twitter = tf.getInstance(); 
  
  getNewTweets("sigmusic");
  Status status = tweets.get(0);
  
  print(status.getText());
}

void getNewTweets(String searchString)
{
    try
    {
        Query query = new Query(searchString);

        QueryResult result = twitter.search(query);

        tweets = result.getTweets();
    }
    catch (TwitterException te)
    {
        System.out.println("Failed to search tweets: " + te.getMessage());
        System.exit(-1);
    }
}