// 79. Word Search
// Medium

// 3313

// 163

// Add to List

// Share
// Given a 2D board and a word, find if the word exists in the grid.

// The word can be constructed from letters of sequentially adjacent cell, where "adjacent" cells are those horizontally or vertically neighboring. The same letter cell may not be used more than once.

// Example:

// board =
// [
//   ['A','B','C','E'],
//   ['S','F','C','S'],
//   ['A','D','E','E']
// ]

// Given word = "ABCCED", return true.
// Given word = "SEE", return true.
// Given word = "ABCB", return false.
 

// Constraints:

// board and word consists only of lowercase and uppercase English letters.
// 1 <= board.length <= 200
// 1 <= board[i].length <= 200
// 1 <= word.length <= 10^3
// Accepted
// 438.6K
// Submissions
// 1.3M
// Seen this question in a real interview before?

// Yes

// No
// Contributor
// LeetCode


object Solution {
    def exist(board: Array[Array[Char]], word: String): Boolean = {
        trait Stream[A] {
            def isEmpty: Boolean
            def flatMap[B](f:A=>Stream[B]): Stream[B]
            
            // The other input Stream must allow un-evaled function, since building a Stream requires the value of its  head, and in some recursive situations this causes the complete lost of lazyness. 
            def concatF(that: ()=>Stream[A]): Stream[A] 
            
        }
        case class Empty[A]() extends Stream[A] {
            def isEmpty = true
            def flatMap[B](f:A=>Stream[B]) = Empty[B]()
            
            // Only when this is Empty may `that` be allowed to get evaled.
            def concatF(that: ()=>Stream[A]) = that() 
        }
        case class Streaming[A](head: A, tail:()=>Stream[A]) extends Stream[A] {
            def isEmpty = false
            
            // Knowing the head suffices to build a Stream, so the un-evaled function is simply enclosed into the tail() function
            def concatF(that: ()=>Stream[A]) = Streaming(head, ()=>tail().concatF(that)) 
            
            // if f(head) is non-empty, either its tail or the flatmap of this.tail remain un-evaled
            def flatMap[B](f:A=>Stream[B]): Stream[B] = f(head).concatF(()=>tail().flatMap(f))
        }
        
        object Stream{
            def fromList[A](l:List[A]): Stream[A] = l match {
                case Nil => Empty[A]()
                case l0 :: ln => Streaming(l0, ()=>fromList(ln))
            }
        }

        object PositionIJ {
            def getAll: Stream[List[(Int, Int)]] = {
                val inis = for {
                    a <- 0 until board.length
                    b <- 0 until board.head.length
                    if board(a)(b) == word.head
                } yield {
                    PositionIJ(word.tail.toList, a, b, List())
                }
                Stream.fromList(inis.toList).flatMap( _.getAllSub )
            }
        }
        
        case class PositionIJ (wd: List[Char], i: Int, j: Int, history: List[(Int, Int)]) {
            def allNeib: List[(Int, Int)] = {
                val allSearch = List((-1, 0), (1, 0), (0, -1), (0, 1))
                for {
                    (a, b) <- allSearch
                    val ii = i + a
                    val jj = j + b
                    if 0 <= ii && ii < board.length
                    if 0 <= jj && jj < board.head.length
                    if (!history.contains((ii, jj)))
                    // without propetuous check for the Char value, further optimization is allowed.
                } yield {
                    (ii, jj)
                } 
            } 
            def stepNew: Stream[PositionIJ] = {
                println(f"Seeking from ${(i, j)} for ${wd} with history ${history}")
                val rst = for {
                    (ii, jj) <- allNeib
                    if board(ii)(jj) == wd.head
                } yield {
                    PositionIJ(wd.tail, ii, jj, (i, j)::history)
                }
                Stream.fromList(rst.toList)
            }
            def getAllSub: Stream[List[(Int, Int)]] = {
                if (wd.isEmpty) Stream.fromList(List(history))
                else stepNew.flatMap(_.getAllSub)
            }
            
        }
        
        if (word.isEmpty) true
        else ! PositionIJ.getAll.isEmpty
    }
}

import Solution._
val bd = Array(
  Array('A', 'B', 'B', 'B', 'B'),
  Array('B', 'B', 'B', 'B', 'B'),
  Array('B', 'B', 'C', 'B', 'B'),
  Array('B', 'B', 'B', 'B', 'B'),
  Array('B', 'B', 'B', 'B', 'B'),
  Array('B', 'B', 'B', 'B', 'B'))
val word = "ABBBBBBBC"
exist(bd, word)
