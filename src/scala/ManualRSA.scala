// Low-efficiency low-security manual RSA algorithm for test only
// based on BigInt calculation in Scala.

type BI = math.BigInt
implicit class BigPower(n: math.BigInt) { 
  def modPower(power: BI, m: BI): BI = {
    def worker(a: BI, p: BI, res: BI = 1): BI = {
      // Returns a^p * res. Recurrences until p = 0 and returns res
      if (p == 0) res
      else if (p % 2 == 0) worker(a * a % m, p / 2, res)
      else worker(a, p - 1, res * a % m)
    }
    worker(this.n, power)
  }
  def checkPrime(a: BI): Boolean = {
    // a ^ (p-1) % p = 1 if p is prime
    a.modPower(this.n - 1, this.n) == 1
  }
  
  val checkSeed: List[BI] = List(27, 711, 43, 68)
  def ifPrime: Boolean = {
    ! checkSeed.exists( ! checkPrime(_) )
  }
  
  def findPrime(epoches: BI = 1000): BI = {
    if (this.n % 2 == 0) (this.n + 1).findPrime(epoches)
    else if (ifPrime) this.n
    else if (epoches <= 0) 2
    else (this.n + 2).findPrime(epoches - 1)
  }
  
  def commonFactor(m: BI): (BI, BI, BI) = {
    def worker(m: BI = this.n, n: BI = m): (BI, BI, BI) = {
      if (n > m) {
        val (x, y, t) = worker(n, m)
        (y, x, t)
      }
      else {
        val k: BI = m / n
        val m1: BI = m - k * n
        if (m1 == 0) (0, 1, n)
        else {
          val (y, x, t) = worker(n, m1)
          (x, y - k * x, t)
        }
      }
    }
    worker()
  }
  
  def coprime(m: BI = n - 5): BI = {
    val (x, y, t) = n.commonFactor(m)
    if (t == 1) m
    else coprime( m - 1 )
  }
  
}

implicit class Str2BI(s: String) {
  def toBigInt: BI = math.BigInt(s)
}

val rdm = new scala.util.Random()
rdm.setSeed(1234567)
rdm.nextInt()
val a = math.BigInt(104, rdm).findPrime(10000)
val b = math.BigInt(104,rdm).findPrime(10000)
// val a: BI = "3242123490218091284120539248102348203497317".toBigInt.findPrime()
// val b: BI = "231798579123741902347190437291474234".toBigInt.findPrime()

def getXY(a0: BI, b0: BI): (BI, BI, BI) = {
  val a = a0.findPrime()
  val b = b0.findPrime()
  val l = (a - 1) * (b - 1)
  val l1 = l.coprime()
  val (x, y, t) = l1.commonFactor(l)
  
  val times: BI  = if (x > 0) 0 else -x / l + 1
  val x1 = x + times * l
  val y1 = y - times  * l1
  // println(f"$x1 * $l1 + $y1 * $l = ${x1 * l1 + y1 * l}")
  (x1, l1, a * b)
}
val (x, y, n) = getXY(a, b)
val c0: BI = math.BigInt(204, rdm)
val c1 = c0.modPower(y, n)
val cc = c1.modPower(x, n)
