#Import the necessary methods from tweepy library
from tweepy.streaming import StreamListener
from tweepy import OAuthHandler
from tweepy import Stream
import preprocessor as p
import re
import time
import json
#Variables that contains the user credentials to access Twitter API
access_token = "780478082469785601-Em9OdZ3tA01bPwV6GfkU3SLRdfemsbE"
access_token_secret = "9888AimNpnW4dM8QFl1zoUm1tHPRAYvUp9ZMlycHNltkH"
consumer_key = "fqMLvPZqNSViSpl60THKALhYg"
consumer_secret = "dJni0XgoxEci7qcrM2i6hUnuzoZoeaUKfCyANWWQL0vifCpjGI"


#This is a basic listener that just prints received tweets to stdout.
class StdOutListener(StreamListener):

    def on_data(self, data):
        try:
            time_start = data.index("\"created_at\":\"")
            time_end = data[time_start:].index("\",\"")+time_start
            time = data[time_start+14:time_end]
            t_start = data.index("\"text\":\"")
            t_end = data[t_start:].index("\",\"") + t_start

            text = str(data[t_start+8: t_end])
            text = re.sub(r"http\S+", "", text)
            text = re.sub(r'\\u[0-9abcdef][0-9abcdef][0-9abcdef][0-9abcdef]', '', text)
            cell = 'N.A'
            if 'Twitter for iPhone' in data:
                cell = 'iPhone'
            elif 'Twitter for Android' in data:
                cell = 'Android'

            dic = {'text' : text, 'time':time, 'cell':cell}
            with open('fetched_tweets.txt', 'a') as file:
                file.write(json.dumps(dic)+'\n')



            #text =  r.sub(' ', text)

            #print text
            #print p.clean(text)

        except:
            print('bug')
            pass

        return True

    def on_error(self, status):
        print(status)

if __name__ == '__main__':

    #This handles Twitter authetification and the connection to Twitter Streaming API
    l = StdOutListener()
    auth = OAuthHandler(consumer_key, consumer_secret)
    auth.set_access_token(access_token, access_token_secret)
    stream = Stream(auth, l)

    #This line filter Twitter Streams to capture data by the keywords: 'python', 'javascript', 'ruby'
    stream.filter(track=[ 'NBA', 'nba'])
