# Import our Twitter credentials from credentials.py
import tweepy
from time import sleep
from credentials import *

# Access and authorize our Twitter credentials from credentials.py
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)
api = tweepy.API(auth)

#api.update_status("Hello!")

def get_award(name):
    pass

def get_name_from_tweet(tweet):
    pass

def reply(award):
    api.update_status(award)


class MLBListener(tweepy.StreamListener):
    
    def on_status(self, status):
        if "@bestinmlb" in status.text:
            print(status.text)


if __name__ == "__main__":
    listener = MLBListener()
    stream = tweepy.Stream(auth=api.auth, listener=listener)
    stream.userstream()