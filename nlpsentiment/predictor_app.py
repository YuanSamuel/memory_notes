import flask
from flask import request
from predictor_api import make_prediction
from flask import jsonify
# Imports the Google Cloud client library
from google.cloud import language
from google.cloud.language import enums
from google.cloud.language import types
# Initialize the app
from bs4 import BeautifulSoup
from selenium import webdriver
#import qgrid
from urllib.request import Request, urlopen
import numpy as np
import pandas as pd
import random
import json

app = flask.Flask(__name__)

# An example of routing:
# If they go to the page "/" (this means a GET request
# to the page http://127.0.0.1:5000/), return a simple
# page that says the site is up!

urls = ['https://www.allmusic.com/mood/acerbic-xa0000000931', 'https://www.allmusic.com/mood/aggressive-xa0000000694', 'https://www.allmusic.com/mood/agreeable-xa0000000715', 'https://www.allmusic.com/mood/airy-xa0000000932', 'https://www.allmusic.com/mood/ambitious-xa0000000933', 'https://www.allmusic.com/mood/amiable-good-natured-xa0000000934', 'https://www.allmusic.com/mood/angry-xa0000000695', 'https://www.allmusic.com/mood/angst-ridden-xa0000000935', 'https://www.allmusic.com/mood/anguished-distraught-xa0000000696', 'https://www.allmusic.com/mood/angular-xa0000000936', 'https://www.allmusic.com/mood/animated-xa0000000937', 'https://www.allmusic.com/mood/apocalyptic-xa0000000938', 'https://www.allmusic.com/mood/arid-xa0000000939', 'https://www.allmusic.com/mood/athletic-xa0000000940', 'https://www.allmusic.com/mood/atmospheric-xa0000000941', 'https://www.allmusic.com/mood/austere-xa0000000942', 'https://www.allmusic.com/mood/autumnal-xa0000000943', 'https://www.allmusic.com/mood/belligerent-xa0000000698', 'https://www.allmusic.com/mood/benevolent-xa0000000944', 'https://www.allmusic.com/mood/bitter-xa0000000945', 'https://www.allmusic.com/mood/bittersweet-xa0000000946', 'https://www.allmusic.com/mood/bleak-xa0000000947', 'https://www.allmusic.com/mood/boisterous-xa0000000699', 'https://www.allmusic.com/mood/bombastic-xa0000000948', 'https://www.allmusic.com/mood/brash-xa0000000949', 'https://www.allmusic.com/mood/brassy-xa0000000950', 'https://www.allmusic.com/mood/bravado-xa0000000951', 'https://www.allmusic.com/mood/bright-xa0000000952', 'https://www.allmusic.com/mood/brittle-xa0000000953', 'https://www.allmusic.com/mood/brooding-xa0000000954', 'https://www.allmusic.com/mood/calm-peaceful-xa0000000701', 'https://www.allmusic.com/mood/campy-xa0000000955', 'https://www.allmusic.com/mood/capricious-xa0000000956', 'https://www.allmusic.com/mood/carefree-xa0000000702', 'https://www.allmusic.com/mood/cartoonish-xa0000000957', 'https://www.allmusic.com/mood/cathartic-xa0000000958', 'https://www.allmusic.com/mood/celebratory-xa0000000703', 'https://www.allmusic.com/mood/cerebral-xa0000000959', 'https://www.allmusic.com/mood/cheerful-xa0000000704', 'https://www.allmusic.com/mood/child-like-xa0000000960', 'https://www.allmusic.com/mood/circular-xa0000000961', 'https://www.allmusic.com/mood/clinical-xa0000000962', 'https://www.allmusic.com/mood/cold-xa0000000963', 'https://www.allmusic.com/mood/comic-xa0000000705', 'https://www.allmusic.com/mood/complex-xa0000000964', 'https://www.allmusic.com/mood/concise-xa0000000965', 'https://www.allmusic.com/mood/confident-xa0000000748', 'https://www.allmusic.com/mood/confrontational-xa0000000966', 'https://www.allmusic.com/mood/cosmopolitan-xa0000000967', 'https://www.allmusic.com/mood/crunchy-xa0000000968', 'https://www.allmusic.com/mood/cynical-sarcastic-xa0000000969', 'https://www.allmusic.com/mood/dark-xa0000000970', 'https://www.allmusic.com/mood/declamatory-xa0000000971', 'https://www.allmusic.com/mood/defiant-xa0000000706', 'https://www.allmusic.com/mood/delicate-xa0000000972', 'https://www.allmusic.com/mood/demonic-xa0000000973', 'https://www.allmusic.com/mood/desperate-xa0000000974', 'https://www.allmusic.com/mood/detached-xa0000000707', 'https://www.allmusic.com/mood/devotional-xa0000000975', 'https://www.allmusic.com/mood/difficult-xa0000000976', 'https://www.allmusic.com/mood/dignified-noble-xa0000000977', 'https://www.allmusic.com/mood/dramatic-xa0000000708', 'https://www.allmusic.com/mood/dreamy-xa0000000709', 'https://www.allmusic.com/mood/driving-xa0000000978', 'https://www.allmusic.com/mood/druggy-xa0000000979', 'https://www.allmusic.com/mood/earnest-xa0000000980', 'https://www.allmusic.com/mood/earthy-xa0000000981', 'https://www.allmusic.com/mood/ebullient-xa0000000982', 'https://www.allmusic.com/mood/eccentric-xa0000000983', 'https://www.allmusic.com/mood/ecstatic-xa0000000984', 'https://www.allmusic.com/mood/eerie-xa0000000985', 'https://www.allmusic.com/mood/effervescent-xa0000000986', 'https://www.allmusic.com/mood/elaborate-xa0000000987', 'https://www.allmusic.com/mood/elegant-xa0000000988', 'https://www.allmusic.com/mood/elegiac-xa0000000989', 'https://www.allmusic.com/mood/energetic-xa0000000990', 'https://www.allmusic.com/mood/enigmatic-xa0000000991', 'https://www.allmusic.com/mood/epic-xa0000000992', 'https://www.allmusic.com/mood/erotic-xa0000000710', 'https://www.allmusic.com/mood/ethereal-xa0000000993', 'https://www.allmusic.com/mood/euphoric-xa0000000711', 'https://www.allmusic.com/mood/exciting-xa0000000994', 'https://www.allmusic.com/mood/exotic-xa0000000995', 'https://www.allmusic.com/mood/explosive-xa0000000700', 'https://www.allmusic.com/mood/extroverted-xa0000000996', 'https://www.allmusic.com/mood/exuberant-xa0000000997', 'https://www.allmusic.com/mood/fantastic-fantasy-like-xa0000000998', 'https://www.allmusic.com/mood/feral-xa0000000999', 'https://www.allmusic.com/mood/feverish-xa0000001000', 'https://www.allmusic.com/mood/fierce-xa0000001001', 'https://www.allmusic.com/mood/fiery-xa0000001002', 'https://www.allmusic.com/mood/flashy-xa0000001003', 'https://www.allmusic.com/mood/flowing-xa0000000713', 'https://www.allmusic.com/mood/fractured-xa0000001004', 'https://www.allmusic.com/mood/freewheeling-xa0000001005', 'https://www.allmusic.com/mood/fun-xa0000001006', 'https://www.allmusic.com/mood/funereal-xa0000001007', 'https://www.allmusic.com/mood/gentle-xa0000001008', 'https://www.allmusic.com/mood/giddy-xa0000001009', 'https://www.allmusic.com/mood/gleeful-xa0000001010', 'https://www.allmusic.com/mood/gloomy-xa0000000714', 'https://www.allmusic.com/mood/graceful-xa0000001011', 'https://www.allmusic.com/mood/greasy-xa0000001012', 'https://www.allmusic.com/mood/grim-xa0000001013', 'https://www.allmusic.com/mood/gritty-xa0000001014', 'https://www.allmusic.com/mood/gutsy-xa0000001015', 'https://www.allmusic.com/mood/happy-xa0000001016', 'https://www.allmusic.com/mood/harsh-xa0000001017', 'https://www.allmusic.com/mood/hedonistic-xa0000001018', 'https://www.allmusic.com/mood/heroic-xa0000001019', 'https://www.allmusic.com/mood/hostile-xa0000001020', 'https://www.allmusic.com/mood/humorous-xa0000000717', 'https://www.allmusic.com/mood/hungry-xa0000001021', 'https://www.allmusic.com/mood/hymn-like-xa0000001022', 'https://www.allmusic.com/mood/hyper-xa0000000718', 'https://www.allmusic.com/mood/hypnotic-xa0000000719', 'https://www.allmusic.com/mood/improvisatory-xa0000001023', 'https://www.allmusic.com/mood/indulgent-xa0000001024', 'https://www.allmusic.com/mood/innocent-xa0000001025', 'https://www.allmusic.com/mood/insular-xa0000001026', 'https://www.allmusic.com/mood/intense-xa0000000721', 'https://www.allmusic.com/mood/intimate-xa0000000722', 'https://www.allmusic.com/mood/introspective-xa0000001027', 'https://www.allmusic.com/mood/ironic-xa0000000723', 'https://www.allmusic.com/mood/irreverent-xa0000001028', 'https://www.allmusic.com/mood/jovial-xa0000000725', 'https://www.allmusic.com/mood/joyous-xa0000001029', 'https://www.allmusic.com/mood/kinetic-xa0000001030', 'https://www.allmusic.com/mood/knotty-xa0000001031', 'https://www.allmusic.com/mood/laid-back-mellow-xa0000001032', 'https://www.allmusic.com/mood/languid-xa0000001033', 'https://www.allmusic.com/mood/lazy-xa0000001034', 'https://www.allmusic.com/mood/light-xa0000001035', 'https://www.allmusic.com/mood/literate-xa0000001036', 'https://www.allmusic.com/mood/lively-xa0000000726', 'https://www.allmusic.com/mood/lonely-xa0000000727', 'https://www.allmusic.com/mood/lush-xa0000001037', 'https://www.allmusic.com/mood/lyrical-xa0000001038', 'https://www.allmusic.com/mood/macabre-xa0000001039', 'https://www.allmusic.com/mood/magical-xa0000001040', 'https://www.allmusic.com/mood/majestic-xa0000000728', 'https://www.allmusic.com/mood/malevolent-xa0000001041', 'https://www.allmusic.com/mood/manic-xa0000001042', 'https://www.allmusic.com/mood/marching-xa0000000729', 'https://www.allmusic.com/mood/martial-xa0000001043', 'https://www.allmusic.com/mood/meandering-xa0000001044', 'https://www.allmusic.com/mood/mechanical-xa0000000731', 'https://www.allmusic.com/mood/meditative-xa0000000732', 'https://www.allmusic.com/mood/melancholy-xa0000000734', 'https://www.allmusic.com/mood/menacing-xa0000001045', 'https://www.allmusic.com/mood/messy-xa0000001046', 'https://www.allmusic.com/mood/mighty-xa0000000736', 'https://www.allmusic.com/mood/monastic-xa0000001047', 'https://www.allmusic.com/mood/monumental-xa0000001048', 'https://www.allmusic.com/mood/motoric-xa0000001049', 'https://www.allmusic.com/mood/mysterious-xa0000000738', 'https://www.allmusic.com/mood/mystical-xa0000000739', 'https://www.allmusic.com/mood/naive-xa0000001050', 'https://www.allmusic.com/mood/narcotic-xa0000001051', 'https://www.allmusic.com/mood/narrative-xa0000001052', 'https://www.allmusic.com/mood/negative-xa0000000740', 'https://www.allmusic.com/mood/nervous-jittery-xa0000000741', 'https://www.allmusic.com/mood/nihilistic-xa0000001053', 'https://www.allmusic.com/mood/nocturnal-xa0000001054', 'https://www.allmusic.com/mood/nostalgic-xa0000000742', 'https://www.allmusic.com/mood/ominous-xa0000001055', 'https://www.allmusic.com/mood/optimistic-xa0000000744', 'https://www.allmusic.com/mood/opulent-xa0000001056', 'https://www.allmusic.com/mood/organic-xa0000001057', 'https://www.allmusic.com/mood/ornate-xa0000001058', 'https://www.allmusic.com/mood/outraged-xa0000001059', 'https://www.allmusic.com/mood/outrageous-xa0000001060', 'https://www.allmusic.com/mood/paranoid-xa0000001061', 'https://www.allmusic.com/mood/passionate-xa0000001062', 'https://www.allmusic.com/mood/pastoral-xa0000000745', 'https://www.allmusic.com/mood/patriotic-xa0000001063', 'https://www.allmusic.com/mood/perky-xa0000000724', 'https://www.allmusic.com/mood/philosophical-xa0000001064', 'https://www.allmusic.com/mood/plain-xa0000001065', 'https://www.allmusic.com/mood/plaintive-xa0000001066', 'https://www.allmusic.com/mood/playful-xa0000001067', 'https://www.allmusic.com/mood/poignant-xa0000001068', 'https://www.allmusic.com/mood/positive-xa0000000746', 'https://www.allmusic.com/mood/powerful-xa0000000747', 'https://www.allmusic.com/mood/precious-xa0000001069', 'https://www.allmusic.com/mood/provocative-xa0000001070', 'https://www.allmusic.com/mood/pulsing-xa0000000750', 'https://www.allmusic.com/mood/pure-xa0000000751', 'https://www.allmusic.com/mood/quirky-xa0000000743', 'https://www.allmusic.com/mood/rambunctious-xa0000001071', 'https://www.allmusic.com/mood/ramshackle-xa0000001072', 'https://www.allmusic.com/mood/raucous-xa0000001073', 'https://www.allmusic.com/mood/reassuring-consoling-xa0000001074', 'https://www.allmusic.com/mood/rebellious-xa0000001075', 'https://www.allmusic.com/mood/reckless-xa0000000752', 'https://www.allmusic.com/mood/refined-xa0000001076', 'https://www.allmusic.com/mood/reflective-xa0000000753', 'https://www.allmusic.com/mood/regretful-xa0000000754', 'https://www.allmusic.com/mood/relaxed-xa0000000755', 'https://www.allmusic.com/mood/reserved-xa0000001077', 'https://www.allmusic.com/mood/resolute-xa0000001078', 'https://www.allmusic.com/mood/restrained-xa0000000756', 'https://www.allmusic.com/mood/reverent-xa0000000757', 'https://www.allmusic.com/mood/rhapsodic-xa0000001079', 'https://www.allmusic.com/mood/rollicking-xa0000001080', 'https://www.allmusic.com/mood/romantic-xa0000000758', 'https://www.allmusic.com/mood/rousing-xa0000000759', 'https://www.allmusic.com/mood/rowdy-xa0000001081', 'https://www.allmusic.com/mood/rustic-xa0000001082', 'https://www.allmusic.com/mood/sacred-xa0000000760', 'https://www.allmusic.com/mood/sad-xa0000000761', 'https://www.allmusic.com/mood/sarcastic-xa0000001083', 'https://www.allmusic.com/mood/sardonic-xa0000001084', 'https://www.allmusic.com/mood/satirical-xa0000001085', 'https://www.allmusic.com/mood/savage-xa0000001086', 'https://www.allmusic.com/mood/scary-xa0000000762', 'https://www.allmusic.com/mood/scattered-xa0000001087', 'https://www.allmusic.com/mood/searching-xa0000001088', 'https://www.allmusic.com/mood/self-conscious-xa0000001089', 'https://www.allmusic.com/mood/sensual-xa0000000764', 'https://www.allmusic.com/mood/sentimental-xa0000000765', 'https://www.allmusic.com/mood/serious-xa0000000766', 'https://www.allmusic.com/mood/severe-xa0000001090', 'https://www.allmusic.com/mood/sexual-xa0000001091', 'https://www.allmusic.com/mood/sexy-xa0000000770', 'https://www.allmusic.com/mood/shimmering-xa0000001092', 'https://www.allmusic.com/mood/silly-xa0000001093', 'https://www.allmusic.com/mood/sleazy-xa0000001094', 'https://www.allmusic.com/mood/slick-xa0000001095', 'https://www.allmusic.com/mood/smooth-xa0000001096', 'https://www.allmusic.com/mood/snide-xa0000000767', 'https://www.allmusic.com/mood/soft-quiet-xa0000001097', 'https://www.allmusic.com/mood/somber-xa0000001098', 'https://www.allmusic.com/mood/soothing-xa0000001099', 'https://www.allmusic.com/mood/sophisticated-xa0000001100', 'https://www.allmusic.com/mood/spacey-xa0000001101', 'https://www.allmusic.com/mood/sparkling-xa0000001102', 'https://www.allmusic.com/mood/sparse-xa0000001103', 'https://www.allmusic.com/mood/spicy-xa0000001104', 'https://www.allmusic.com/mood/spiritual-xa0000001105', 'https://www.allmusic.com/mood/spontaneous-xa0000001106', 'https://www.allmusic.com/mood/spooky-xa0000001107', 'https://www.allmusic.com/mood/sprawling-xa0000001108', 'https://www.allmusic.com/mood/sprightly-xa0000001109', 'https://www.allmusic.com/mood/springlike-xa0000001110', 'https://www.allmusic.com/mood/stately-xa0000001111', 'https://www.allmusic.com/mood/street-smart-xa0000001112', 'https://www.allmusic.com/mood/striding-xa0000000771', 'https://www.allmusic.com/mood/strong-xa0000000772', 'https://www.allmusic.com/mood/stylish-xa0000001113', 'https://www.allmusic.com/mood/suffocating-xa0000001114', 'https://www.allmusic.com/mood/sugary-xa0000001115', 'https://www.allmusic.com/mood/summery-xa0000001116', 'https://www.allmusic.com/mood/suspenseful-xa0000001117', 'https://www.allmusic.com/mood/swaggering-xa0000001118', 'https://www.allmusic.com/mood/sweet-xa0000000773', 'https://www.allmusic.com/mood/swinging-xa0000000774', 'https://www.allmusic.com/mood/technical-xa0000000775', 'https://www.allmusic.com/mood/tender-xa0000001119', 'https://www.allmusic.com/mood/tense-anxious-xa0000000697', 'https://www.allmusic.com/mood/theatrical-xa0000001120', 'https://www.allmusic.com/mood/thoughtful-xa0000001121', 'https://www.allmusic.com/mood/threatening-xa0000000777', 'https://www.allmusic.com/mood/thrilling-xa0000000776', 'https://www.allmusic.com/mood/thuggish-xa0000001122', 'https://www.allmusic.com/mood/tragic-xa0000001123', 'https://www.allmusic.com/mood/transparent-translucent-xa0000001124', 'https://www.allmusic.com/mood/trashy-xa0000001125', 'https://www.allmusic.com/mood/trippy-xa0000000749', 'https://www.allmusic.com/mood/triumphant-xa0000001126', 'https://www.allmusic.com/mood/tuneful-xa0000001127', 'https://www.allmusic.com/mood/turbulent-xa0000001128', 'https://www.allmusic.com/mood/uncompromising-xa0000001129', 'https://www.allmusic.com/mood/understated-xa0000001130', 'https://www.allmusic.com/mood/unsettling-xa0000001131', 'https://www.allmusic.com/mood/uplifting-xa0000001132', 'https://www.allmusic.com/mood/urgent-xa0000001133', 'https://www.allmusic.com/mood/virile-xa0000001134', 'https://www.allmusic.com/mood/visceral-xa0000001135', 'https://www.allmusic.com/mood/volatile-xa0000001136', 'https://www.allmusic.com/mood/vulgar-xa0000001137', 'https://www.allmusic.com/mood/warm-xa0000001138', 'https://www.allmusic.com/mood/weary-xa0000001139', 'https://www.allmusic.com/mood/whimsical-xa0000001140', 'https://www.allmusic.com/mood/wintry-xa0000001141', 'https://www.allmusic.com/mood/wistful-xa0000001142', 'https://www.allmusic.com/mood/witty-xa0000001143', 'https://www.allmusic.com/mood/wry-xa0000001144', 'https://www.allmusic.com/mood/yearning-xa0000000733']

def get_preset_from_sent(sent):
    sent_presets = [6, 100, 232, 210, 131, 30, 182, 106, 38, 85]
    a = 2
    s = round((sent+1)*4.5)
    for i in range(0,10):
        if s==i:
            a = sent_presets[s]
            
    print("PRESET" + str(a))
    return a
            
        
@app.route("/song/", methods=["GET"])
def get_song():
    sentiment = float(request.args['sentiment'].strip(' "'))
    mood = request.args['mood']
    storage = None
    with open('data.txt') as json_file:
    	storage = json.load(json_file)
    	for k in storage.keys():
    		if str.lower(mood) in str.lower(k):
    			return storage[k]


    m = str.lower(mood)
    songs = []
    for i in range(0, len(urls)):
        if m in urls[i]:
            print("FOUND MOOD")
            songs = process_mood(i)
            
    if len(songs) ==0:
        print("GOING WITH PRESET")
        songs = process_mood(get_preset_from_sent(sentiment))
    storage[mood] = songs
    with open('data.txt', 'w') as outfile:
    	json.dump(storage, outfile)
    #song = songs[random.randint(0,len(songs)-1)]
    return songs
            
    

#TODO figure out a way to make selenium faster
def process_mood(ind):
    driver = webdriver.Firefox(executable_path='/Users/prasannsinghal/Desktop/geckodriver')
    driver.get(urls[ind])

    html = driver.page_source
    soup = BeautifulSoup(html)
    driver.quit()
    try:
        rows = soup.find_all("tbody")[0].find_all("tr")

        print(len(rows))
        data = []
        for row in rows:
            print(row)
            a = {}
            r = row.find_all("a")
            a['title'] = row.find_all("td")[0].find_all("a")[0].text
            a['artist'] = row.find_all("td")[1].find_all("a")[0].text
            print(a)
            data.append(a)
    except:
        data = process_mood(ind+1)
        
    response = {}
    response['response'] = data
    return response
                                     
@app.route("/api/", methods=["GET"])
def api_predict():
    # request.args contains all the arguments passed by our form
    # comes built in with flask. It is a dictionary of the form
    # "form name (as set in template)" (key): "string in the textbox" (value)
    print(request.args)

    client = language.LanguageServiceClient()

    # The text to analyze
    text = request.args['input']
    document = types.Document(
        content=text,
        type=enums.Document.Type.PLAIN_TEXT)

    # Detects the sentiment of the text
    sentiment = client.analyze_sentiment(document=document).document_sentiment

    a = {}
    a['score'] = sentiment.score
    a['magnitude'] = sentiment.magnitude
    return a


# Start the server, continuously listen to requests.

if __name__=="__main__":
    # For local development:
    #app.run(debug=True)
    # For public web serving:
    app.run(host='0.0.0.0', port=8080, debug=True)
