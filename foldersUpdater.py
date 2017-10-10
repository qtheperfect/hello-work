# Search all files in two folders with md5 check and update one to the other

# (setq python-shell-interpreter "python3")
# ... because python3 maks you learn chinese good.

import os
import hashlib

def fetchall(d, a=""):
    
    flist = []
    rlist = os.listdir(d+a)
    
    for x in rlist:
        fx = d+a+x
        if os.path.isfile(fx):
            flist.append(a+x)
        else:
            flist.extend(fetchall(d, a+x+"/"))
    return flist


def getmd5(x):
    m = hashlib.md5()
    f = open(x,'rb')
    while(True):
        asd = f.read(1024)
        if not asd:
            break
        m.update(asd)
    return m.hexdigest()

    
    
def allmd5(d, flist):
    md5list = []
    md5path = {}
    md5time={}
    for x in flist:
        asd = getmd5(d+x)
        mtime = os.path.getmtime(d+x)
        
        md5list.append(asd)
        md5path[asd] = x
        md5time[asd] = os.path.getmtime(d+x)

        print(asd + ": " + x + " - "+ str(mtime))
        
    return (md5list, md5path, md5time)



        
    
