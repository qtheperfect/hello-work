/*
934. Shortest Bridge
Medium

646

50

Add to List

Share
In a given 2D binary array A, there are two islands.  (An island is a 4-directionally connected group of 1s not connected to any other 1s.)

Now, we may change 0s to 1s so as to connect the two islands together to form 1 island.

Return the smallest number of 0s that must be flipped.  (It is guaranteed that the answer is at least 1.)

 

Example 1:

Input: A = [[0,1],[1,0]]
Output: 1
Example 2:

Input: A = [[0,1,0],[0,0,0],[0,0,1]]
Output: 2
Example 3:

Input: A = [[1,1,1,1,1],[1,0,0,0,1],[1,0,1,0,1],[1,0,0,0,1],[1,1,1,1,1]]
Output: 1
 

Constraints:

2 <= A.length == A[0].length <= 100
A[i][j] == 0 or A[i][j] == 1
Accepted
23,362
Submissions
49,765
Seen this question in a real interview before?

Yes

No
Contributor
ab889977

Problems

Pick One

Prev
934/1473

Next
*/

object Solution {
    def shortestBridge(A: Array[Array[Int]]): Int = {
        type Pos = (Int, Int)
        def neightbors(ij: Pos): List[Pos] = {
            val (i, j) = ij
            for (
                (a, b) <- List((1, 0), (-1, 0), (0, 1), (0, -1));
                ia = i + a;
                ib = j + b;
                if 0 <= ia && 0 <= ib && ia < A.length && ib < A.head.length
            ) yield (ia, ib)
        }
        def get01(ij: Pos): Int = {
            val (i, j)  = ij
            A(i)(j)
        }
        
        trait Status {
            def step: Status
        }
        case class InScout(inland: List[Pos], border: List[Pos], newLand: List[Pos]) extends Status {
            def isNew(ij: Pos): Boolean = ! (inland ++ border ++ newLand).contains(ij)
            def step: Status = {
                val allNeigs = newLand.flatMap(neightbors(_)).distinct.filter(isNew(_))
                val classNeigs = allNeigs.groupBy(get01(_))
                // println(f"  neighbor classify ${newLand} => ${classNeigs}")
                val borderNew = border ++ classNeigs.getOrElse(0, Nil).toList
                val newLandNew: List[Pos] = classNeigs.getOrElse(1, Nil).toList
                val inlandNew = inland ++ newLand
                if (! newLandNew.isEmpty) {
                    InScout(inlandNew, borderNew, newLandNew)
                } 
                else{
                    InExplore(1, inlandNew, Nil, borderNew)
                } 
            }
                
        }
        
        case class InExplore(layer: Int, inland: List[Pos], bridgeLand:List[Pos], border: List[Pos]) extends Status {
            def isValid(ij: Pos): Boolean = ! (inland ++ bridgeLand ++ border).contains(ij)
            def step: Status = {
                val allNeigs = border.flatMap(neightbors(_)).distinct.filter(isValid(_))
                if (allNeigs.exists(get01(_) == 1)) Found(layer)
                else if (allNeigs.isEmpty) Found(-1)
                else {
                    val bridgeNew = bridgeLand ++ border
                    val borderNew = allNeigs
                    InExplore(layer + 1, inland, bridgeNew, borderNew)
                }
            }
        }
        
        case class Found(ans: Int) extends Status {
            def step: Status = this
        }
        
        val firstLand: Pos = ( 
            for (
                (a, i) <- A.zipWithIndex;
                (b, j) <- a.zipWithIndex;
                if b == 1
            ) yield (i, j)
        ).head
        
        val initScout = InScout(Nil, Nil, List(firstLand))
        
        def worker( previous: Status = initScout ) : Int = {
            // println(previous)
            previous match {
                case Found(n) => n
                case _ => worker(previous.step) 
            } 
        }
        worker()
    }
}
