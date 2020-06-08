trait smartFun[S, T] {
  var funMap: Map[S, T] = Map[S, T]()
  def f(in: S): T
  def doF(in: S): T = {
    if (funMap.contains(in)) {
      println(f"-- escaping ${in}")
      funMap(in)
    }
    else {
      println(f"Elaboratedly checking ${in}")
      val out = f(in)
      funMap = funMap.updated(in, out)
      out
    }
  }
}

trait Tree
case class EmptyNode() extends Tree
case class TreeNode(value: Int, left: Tree, right: Tree) extends Tree

object RangeTrees extends smartFun[(Int, Int),  List[Tree]]  {
  override def f(in: (Int, Int)): List[Tree] = {
    val (a: Int, b: Int) = in
    if (a > b) List(EmptyNode())
    else if (a == b) List(TreeNode(a, EmptyNode(), EmptyNode()))
    else a.to(b).toList.flatMap (m => {
      val tLeft = doF((a, m - 1))
      val tRight = doF((m + 1, b))
      for (t1 <- tLeft; t2 <- tRight) yield {
        TreeNode(m, t1, t2)
      }
    })
  }
}

def prtTree(t: Tree, head: Int = 0, pace: Int = 4): Unit = {
  val space = " ".repeat(head)
  t match {
    case EmptyNode() => println("Empty")
    case TreeNode(v, l, r) =>
      println(v)
      print(space)
      print("Left>")
      prtTree(l, head + pace, pace)
      print(space)
      print("right>")
      prtTree(r, head + pace, pace)
  }
}

val res = RangeTrees.f(1, 5)
res.foreach(t => prtTree(t))
  
