case class Matcher[A](s: List[A], t: List[A]) {
  def submatch(i: Int = 1, mLast: Int = -1, m: Map[Int, Int] = Map(0 -> -1)): Map[Int, Int] = {
    // If the i th element of the list s has at least mLast predecesors mimic to the first mLast elements of s, could it make the mLast + 1 th element of such sequence identical to the first mLast + 1 elements of s? Or could a shorter sequence up to i (including i) be formed that is identical to a shorter initiate part of s? The lengths of the longest such sequences up to each element of s are stored in m: Map(Int, Int) and returned. 0 means the length is one (i is the 0th of such sequence), and -1 means no such sequences.
    if (i >= s.length ) m
    else if (s(i) == s(mLast + 1)) submatch( i + 1, mLast + 1, m.updated(i, mLast + 1) ) 
    else if (mLast >= 0) submatch(i, m(mLast), m)
    else submatch(i + 1, -1, m.updated(i, -1))
  }
  val smartMap = submatch()
  println(smartMap.toList.sortBy(_._1).map(_._2).zip(s))

  def matchFirst(i: Int = 0, j: Int = 0) : Int = {
    if (j >= t.length) -1
    else if (i >= s.length) j-i
    else (s(i), t(j)) match {
      case (x, y) if x == y => matchFirst(i + 1, j + 1)
      case _ if i > 0 => matchFirst(smartMap(i - 1) + 1, j)
      case _ => matchFirst(0, j + 1)
    }
  }

  def matchAll(i: Int = 0, j: Int = 0): List[Int] = {
    if (j >= t.length) Nil
    else if (i >= s.length) {
      val ii = smartMap(i - 1) + 1
      (j - i) :: matchAll(ii, j)
    }
    else (s(i), t(j)) match {
      case (x, y) if x == y => matchAll(i + 1, j + 1)
      case _ if i > 0 => matchAll(smartMap(i - 1) + 1, j)
      case _ => matchAll(0, j + 1)
    }
  }

  def matchDistinct(all: List[Int] = matchAll()): List[Int] =  {
    all match {
      case Nil => Nil
      case a0 :: a1 :: an if a0 + s.length > a1 => matchDistinct(a0 :: an)
      case a0 :: an => a0 :: matchDistinct(an)
    }
  }
}

object TestMatcher {
  def apply() {
    val s = "abaabaababaabcbdabaa"
    val t = "abaabababababaabaabaababaaaabaabaababaabcbdabaabaababaabcbdabaaabaabaababaabcbdabaaskasdbasaadfabaasdabaabababaabab"

    val res = Matcher(s.toList, t.toList)

    println(f"All matched positions: ${res.matchAll()}")
    println(f"Non-overlapped positions ${res.matchDistinct()}")
    println(f"From sequence: ${t}")
    println("Checked below:")
    println(s)
    res.matchAll().foreach {x => println(t.drop(x)); x}
  }
}

TestMatcher()
