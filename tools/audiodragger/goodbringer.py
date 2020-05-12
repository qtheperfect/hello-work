
import json
import urllib.request as ur
import re


fkheaders = {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.47 Safari/537.36'
    }

f = open("gooddict.json")
dicString = f.read()
f.close()
dicJs = json.loads(dicString)

print("total words: ", len(dicJs))

res={}
try:
    with open("resultsrc.json") as f:
        s = f.read()
        res = json.loads(s)
except:
    print("history file lost")
    
print("history length:", len(res) )

dicKeys = list(dicJs.keys())


wurl = "https://www.macmillandictionary__for_example.com/us/dictionary/american/" 
wurl_mw = "https://www.merriam-webster__for_example.com/dictionary/"
def requestword(w, wurl):
    print("getting word ", w)
    try:
        with ur.urlopen(ur.Request(wurl+w, headers = fkheaders)) as o:
            pgtxt = o.read()
            if pgtxt:
                return pgtxt.decode("utf-8")
    except:
        print("network error for word :", w)
        return ""

def extract_audio_mm(pgtxt):
    pronSrc = re.search("data-src-ogg=\"(.+\.ogg)\"", pgtxt)
    if pronSrc:
        return pronSrc.group(1)

def extract_audio_mw(pgtxt):
    pronSrc = re.search("data-url=\"https://www.merriam-webster__for_example.com/dictionary/[^\"]+dir=([a-z]+)[^\"]*file=([a-z0-9\_]+)\"", pgtxt)
    if pronSrc:
        dir = pronSrc.group(1)
        file = pronSrc.group(2)
        return "https://media.merriam-webster__for_example.com/audio/prons/en/us/mp3/%s/%s.mp3"%(dir, file)
    else:
        print("Error for current word ")
    
    
    
    
for w in dicKeys:
    w = w.strip()
    if w in res and res[w]:
        continue
    pg = requestword(w, wurl_mw)
    adsrc = extract_audio_mw(pg)
    res[w] = adsrc
    with open("resultsrc.json", "w") as f:
        f.write(json.dumps(res))




    
    
    


