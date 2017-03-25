# Import our Twitter credentials from credentials.py
import tweepy
from time import sleep
from credentials import *

# Access and authorize our Twitter credentials from credentials.py
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)
api = tweepy.API(auth)

class MLBListener(tweepy.StreamListener):
    
    def on_status(self, status):
        if "@bestinmlb" in status.text:
            name = self.get_name_from_tweet(status.text)
            award = self.get_award(name)
            username = self.get_user(status)
            self.reply(username, award)

    def get_name_from_tweet(self, text):
        """
            Fetch player name from the text in 
            a tweet
        """
        return text.replace("@bestinmlb ", "")

    def get_award(self, name):
        """
            From name return award as a sentence using
            the server API 
        """
        return " " + name + " is just the best!"

    def reply(self, username, award):
        """
            Reply to user who tweeted us with award
        """
        api.update_status("@" + username + award)

    def get_user(self, status):
        return status.user.screen_name



if __name__ == "__main__":
    listener = MLBListener()
    stream = tweepy.Stream(auth=api.auth, listener=listener)
    stream.userstream()