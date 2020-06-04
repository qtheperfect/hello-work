// The maximum area of the rectangles constrained within a list of pillars:

case class Pillar(index: Int, height: Int)

def applyPillar(hs: List[Int]): List[Pillar] = {
  hs.zipWithIndex.map { case (h: Int, i: Int) => new Pillar(i, h) }
}

case class Shadow(unclosed: Set[Pillar], closed: Map[Int, Int] ) {
  def putIn(p: Pillar): Shadow =  {
    val pOut = unclosed.filter( q => q.height > p.height )
    val pNew = unclosed -- pOut
    val mapNew: Map[Int, Int] = pOut.map({case q => (q.index, q.height * (p.index - q.index))}).toMap
    Shadow(pNew + p, closed ++ mapNew)
  }
  def closeAll(len: Int): Shadow = {
    val mapNew: Map[Int, Int] = (for { q <- unclosed } yield {(q.index, q.height * (len- q.index))} ). toMap
    Shadow(Set[Pillar](), closed ++ mapNew )
  }
}

def initShadow: Shadow  = Shadow(Set[Pillar](), Map[Int, Int]())

def applyShadow(hs: List[Int]): Shadow = {
  val ps = applyPillar(hs)
  ps.foldLeft(initShadow)( (x, y) => x.putIn(y) ).closeAll(hs.length)
}



def maxRect(hs: List[Int]): List[Int] = {
  val recRight = applyShadow(hs).closed.toList.sorted.map(_._2)
  val recLeft= applyShadow(hs.reverse).closed.toList.sorted.reverse.map(_._2)
  for ( ((h, l), r) <- hs.zip(recLeft).zip(recRight) ) yield (l + r - h) 
}
maxRect(List(1,2,4,4,3,3,2,3,1,1))
