import sys

rsa260 = 22112825529529666435281085255026230927612089502470015394413748319128822941402001986512729726569746599085900330031400051170742204560859276357953757185954298838958709229238491006703034124620545784566413664540684214361293017694020846391065875914794251435144458199
rf1 = 4397328654844826923795068102505872571721883526553349659561256924505973939597593482272505698004801207988043088656411102133523080581
rf2 = rsa260 // rf1

def abs(n: int) -> int:
    return n if n >= 0 else -n

def gcd(x: int, y: int) -> int:
    while y != 0:
        x, y = y, x%y
    return x

def modpow(base: int, expn: int, modl: int) -> int:
    result = 1
    while expn != 0:
        if expn % 2 == 1:
            result = (result * base) % modl
        expn = expn // 2
        base = (base * base) % modl
    return result

def isprime(n: int) -> int:
    seed = [51, 52111, 8817]
    for s in seed:
        if modpow(s, n - 1, n) != 1:
            return False
    return True

def findPrime(init = 1000):
    init = init - init % 4 + 3
    while not isprime(init):
        init = init + 4
    return init

primeBase = 5122342134123
p1 = findPrime(primeBase)
p2 = findPrime(p1 + primeBase)
ntest = p1 * p2

attemptCount = 0
def rho(n: int, c: int, x0: int) -> int:
    " The Pollard-Rho factorization with map x -> x^2+c mod n with x_0 = x0"
    x = x0
    y = x0
    while True:
        global attemptCount
        
        x = (x * x + c) % n
        y = (y * y + c) % n
        y = (y * y + c) % n

        dxy = abs(x - y)
        if dxy == 0:
            return 1
        elif gcd(dxy, n) != 1:
            return gcd(dxy, n)
        else:
            attemptCount += 1
            if  attemptCount % 1000 == 0:
                print(f"failed attempts: {attemptCount}", end = "\r")

def test():
    nfactor = rho(n = ntest, c = 1531, x0 = 151)
    print(f"\n result:  {nfactor} | {ntest}")
    print(  f" test  :  {nfactor} * {ntest // nfactor} =  {nfactor * (ntest // nfactor)}")
    return nfactor

result = 1
def run():
    global result
    print(f"  Defactorizing the rsa260({rsa260}) via the rho algorithm\n")
    
    result = rho(rsa260, 512341, 5121)
    print(f"\n    Factor of {rsa260} is:\n {result}")
    return result

def verify():
    prd = rf1 * rf2
    print(f"  Verifying the rsa260({rsa260}) with the published result\n")
    print(f"""
    rsa260  = {rsa260}
    factor1 = {rf1}
    factor2 = {rf2}
    f1 * f2 = {prd}
    result:   {prd == rsa260}
    """)
    
    

def parseArgs():
    for c in sys.argv[1:]:
        c = c.strip().lower()
        print("\n\n", c)
        if c == "run":
            run()
            return True
        elif c == "test":
            test()
            return True
        elif c == "verify":
            verify()
            return True
        
    print("Please kindly run me with an additional argument:\n run (the exhausting factorization),\n test ( with a simple example), or\n verify (the published result)")
    return False
        

parseArgs()
        
        
        
    
