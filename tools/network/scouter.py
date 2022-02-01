#!/usr/bin/python3

# This file scouts the recent game list from the online chess profile and fetchs the records.
# Required Template files containing curl scripts: ./curlGameTemp.sh, ./curlProfileTemp.sh

import re
import os
from time import sleep

class Game:
    # The game is given by game id (gmid) whose record is fetched by curl script and restored in ./axv/<gmid> as a json text, of which among the keys the "moveList" provides a string where each pair of letters denotes one step of move on the board.
    def __init__(self, gmid):
        self.gmid = gmid
        with open("curlGameTemp.sh") as f:
            allCurl= f.read();
        #end
        tempId = self.getTempId(allCurl)
        if gmid != "":
            self.allCurl= allCurl.replace(tempId, gmid)
        else:
            self.gmid = tempId
            self.allCurl = allCurl
        #endif
        self.all = ""
    #end

    def getTempId(self, allTmpl):
        idre = "/game/live/(\d+)"
        idmatch = re.search(idre, allTmpl)
        if idmatch:
            return idmatch.group(1)
        else:
            return -1
        #end
    #end

    def checkNovelty(self):
        if os.path.isfile("axv/" + self.gmid):
            return False
        else:
            return True
        #endif
    #end

    def curllyGet(self):
        res = ""
        with os.popen(self.allCurl) as po:
            res = po.read()
            po.close()
        #end
        self.all = res
        return res
    #end

    def optionalGet(self):
        if self.checkNovelty():
            sleep(2.732)
            self.curllyGet()
            if not self.checkSuccess():
                print("Error for game response")
            else:
                with open("axv/%s" % (self.gmid), "w") as f:
                    f.write(self.all)
                    # From left white Castle: abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789?! are all the 64 positions.
                    # Decode the record following your own convinience!
            #end
    #end
    def checkSuccess(self):
        return len(self.all) > 200
    #end

    def main(self):
        self.optionalGet()
    #end
#end class game

class GameProfile :
    # Fetches the list of gmids from the game record profile and downloads them using Game(gmid)
    def __init__(self):
        self.pCurl = "echo no temp files"
        with open("curlProfileTemp.sh") as f:
            self.pCurl = f.read()
        #end
        self.allGames = {}
    #end

    def getProfile(self):
        rawProf = ""
        with os.popen(self.pCurl) as op:
            rawProf = op.read()
        #end
        allGames = set(re.findall(r"/game/live/([0-9]+)", rawProf))
        self.allGames = allGames
        return allGames

    def games2files(self):
        allGames = self.allGames
        for g in allGames:
            print("getting game  %s  " % (g))
            gm = Game(g)
            gm.main()
        #end
    #end

    def main(self):
        self.getProfile()
        self.games2files()
    #end

#end

gp = GameProfile()
gp.main()
