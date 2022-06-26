import tweepy
import pandas as pd
from datetime import datetime
import time
import os

consumer_key = "CONSUMER KEY"
consumer_secret = "CONSUMER SECRET"
access_tkn = "ACCESS TOKEN"
access_tkn_secret = "ACCESS TOKEN SECRET"

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_tkn, access_tkn_secret)

api = tweepy.API(auth, wait_on_rate_limit=True)


#Capturing
def capture(Query = "#Abdala,#Soberana02"):
    num_tweet = 0
    lTweet = []
    for tweet in tweepy.Cursor(api.search_tweets, q = Query, tweet_mode = "extended", lang = "es").items():
        lTweet.append((tweet.full_text, str(tweet.created_at), tweet.user.screen_name, tweet.id, hasattr(tweet, "retweeted_status")))
        num_tweet += 1
        if num_tweet % 1000 == 0:
            print(f"Processed: {num_tweet}")
	    
            partialData = pd.DataFrame([tweet[0] for tweet in lTweet], columns=['Tweets'])
            partialData['Fecha'] = [tweet[1] for tweet in lTweet]
            partialData['Autor'] = [tweet[2] for tweet in lTweet]
            partialData['Id'] = [tweet[3] for tweet in lTweet]
            partialData['RT'] = [str(tweet[4]) for tweet in lTweet]

            date = datetime.now().strftime('%d-%m-%Y-%H-%M')
            
            partialData.to_json(f"captures/partial/file_partial_{num_tweet}_{date}.json")


    print(f"-----------------------\nFinished: {num_tweet}")

    date = datetime.now().strftime('%d-%m-%Y-%H-%M')
    
    data = pd.DataFrame([tweet[0] for tweet in lTweet], columns=['Tweets'])
    data['Fecha'] = [tweet[1] for tweet in lTweet]
    data['Autor'] = [tweet[2] for tweet in lTweet]
    data['Id'] = [tweet[3] for tweet in lTweet]
    data['RT'] = [str(tweet[4]) for tweet in lTweet]

    data.to_json(f"captures/file_{date}.json")

    return data
