import os
import urllib
import urllib.request as ur
import json

sentenced = {}

justheaders={'User-Agent': 'Mozilla/5.1 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.47 Safari/537.37'}

with  open("resultsrc.json") as f:
    sentenced = json.loads(f.read())
for w in sentenced:
    if os.path.isfile("audio/"+w+".mp3"):
        continue
    print(w, sentenced[w])
    if not sentenced[w]:
        print("this item is flawed ... ")
        continue
    try:
        with ur.urlopen(ur.Request(sentenced[w], headers=justheaders)) as o:
            with open("audio/"+w+".mp3", "wb") as f:
                f.write( o.read() )
    except:
        print("the audio of %s still unfetchable ... " %(w))
        
    


