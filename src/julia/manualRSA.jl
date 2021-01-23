# Manually encrypt a random number $bob0 with RSA and manually decrypt it;
# Do not use this script for encryption in your own backyard. Use the expert recommended programs instead.

function modpower(a::BigInt, x::BigInt, n::BigInt, res::BigInt )
    if (x == 0) res
    elseif (x % 2 == 0) modpower(a * a % n, div(x, 2), n, res) 
    else modpower(a, x - 1, n, res * a % n)
    end
end
modpower(a, x, n)  = modpower(BigInt(a), BigInt(x), BigInt(n), BigInt(1))

function isprime(x, seeds = [3, 7, 11, 19, 23, 29, 31, 443, 1723, 44391])
    if (isempty(seeds)) true
    elseif (seeds[1] >= x) true
    elseif modpower(seeds[1], x - 1, x ) == 1 isprime(x, seeds[2 : end])
    else false
    end
end
function findprime(x::BigInt)
    findprime2(a::BigInt) = isprime(a) ? a : findprime2(a + 2)
    if (x % 2 == 0) findprime2(x + 1)
    else findprime2(x + 2)
    end
end
findprime(x) = findprime(BigInt(x))


function depose(x::BigInt, y::BigInt; verbose = false)
    # returns (a, b, z) s.t. ax + by = z AND z = gcd(x, y)
    if y == 0 
        verbose && println("1 * $x + 0 * $y = $x")
        (1, 0, x)
    else 
        x1 = x % y
        k = div(x, y)
        (a1, b1, z) = depose(y, x1; verbose = verbose)
        b = a1 - k * b1
        verbose && println("$b1 * $x + $b * $y = $z")
        (b1, b, z)
    end
end
depose(x, y; verbose = false) = depose(BigInt(x), BigInt(y); verbose = verbose)
#depose(18 * 512340, 18 * 213205; verbose = true)

function getRSA(a::BigInt, b::BigInt) 
    nofactor(x::BigInt, y::BigInt) = gcd(x, y) == 1 ? x : nofactor(x + 1, y)
    pa = findprime(a)
    pb = findprime(b)
    en = pa * pb
    el = (pa - 1) * (pb - 1)
    x0 = rand((div(el, 2) + 1) : (el - 1))
    ex = nofactor(x0, el)
    (ey, k, z) = depose(ex, el)
    (ex, mod(ey, el), en)
end
getRSA(a, b) = getRSA(BigInt(a), BigInt(b))

(x, y, n) = getRSA(220001, 330000)
println("Public:$x-$n;\nPrivate: $y")
bob0 = rand(200000:2000000) 
alice = modpower(bob0, x, n)
bob1 = modpower(alice, y, n)
println("Before: $bob0; After: $alice")
println("For Be: $bob1")
