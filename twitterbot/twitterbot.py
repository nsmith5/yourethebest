# Import our Twitter credentials from credentials.py
import tweepy
import requests
import nltk
from nltk.tag.stanford import StanfordNERTagger

#sudo pip install -U nltk
#sudo pip install -U numpy

nltk.download('maxent_ne_chunker')
nltk.download('words')

import json
import re
import time

from time import sleep
from credentials import *

# Access and authorize our Twitter credentials from credentials.py
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)
api = tweepy.API(auth)

qual_to_adj = {
    "born": "was ",
    "comicbook": "has a ",
    "left": "is ",
}


class Player(object):
    def __init__(self, name):
        self.name = name

class MLBListener(tweepy.StreamListener):
   
    def on_status(self, status):
        if "@bestinmlb" in status.text:
            name = self.get_name_from_tweet(status.text)
            award = self.get_award(name)
            username = self.get_user(status)
            if award:
                self.reply(username, award)
            else:
                self.reply_error(username)

    def get_name_from_tweet(self, text):
        """
            Fetch player name from the text in 
            a tweet
        """
        body = text.replace("@bestinmlb ", "")

        return self.format_name(self.processLanguage(text.replace("@bestinmlb ", "")))

    def processLanguage(self, text):

       # try:
        tager = StanfordNERTagger('../stanford-ner-2012-11-11/classifiers/english.all.3class.distsim.crf.ser.gz',
               '../stanford-ner-2012-11-11/stanford-ner.jar') 
        tokenized_text = nltk.word_tokenize(text)
        t = tager.tag(tokenized_text)
        for item in t:
            print(item)
        return t
        #except Exception, e:
            #print ("error " + str(e))
    
    def format_name(self, tokens):
        name = ""
        for pair in tokens:
            print(pair)
            if (pair[1] == "PERSON"):
                name += pair[0] +" "
        print("name is" + name)
        return name

    def get_award(self, name):
        """
            From name return award as a sentence using
            the server API 
        """
        url = "http://138.197.157.99"
        payload = {"player": name}

        r = requests.post(url, data=json.dumps(payload))

        return self.response_to_award(r.text)
    
    def response_to_award(self, response):
        dictionary = json.loads(response)
        if "error" in dictionary:
            return None
        else:
            award = dictionary["player"] + " is the player with the best " + dictionary['metric'] 
            for quality in dictionary['filters'][0:-1]:
                indicator = quality.partition(' ')[0].lower()
                award += " that " + qual_to_adj[indicator] + quality.lower()
            quality = dictionary['filters'][-1]
            indicator = quality.partition(' ')[0].lower()
            award += " and that "  + qual_to_adj[indicator] + quality.lower()
            return award

    def reply(self, username, award):
        """
            Reply to user who tweeted us with award
        """
        
        words = award.split(" ")
        words.reverse()
        tweets = []
        
        while words:
            string = []
            
            while len(" ".join(string)) < 100 and words:
                string.append(words.pop())
            
            tweets.append(" ".join(string))
        
        for i, tweet in enumerate(tweets):
            fulltweet = "@" 
            + username + ' ' + tweet + " (" 
            + str(i + 1) + "/" + str(len(tweets)) + ")"
            self.tweet(fulltweet)

    def reply_error(self, username):
        self.tweet("@" + username + " sorry can't find that player!")

    def tweet(self, tweet):
        try: 
            api.update_status(tweet)
            print("Tweet succeeded")
        except tweepy.error.TweepError:
            print("Twitter error...passing")

    def get_user(self, status):
        return status.user.screen_name


if __name__ == "__main__":
    listener = MLBListener()
    stream = tweepy.Stream(auth=api.auth, listener=listener)
    stream.userstream()

