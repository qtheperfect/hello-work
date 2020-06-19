/*
 230. Kth Smallest Element in a BST
Medium

2438

61

Add to List

Share
Given a binary search tree, write a function kthSmallest to find the kth smallest element in it.

 

Example 1:

Input: root = [3,1,4,null,2], k = 1
   3
  / \
 1   4
  \
   2
Output: 1
Example 2:

Input: root = [5,3,6,2,4,null,null,1], k = 3
       5
      / \
     3   6
    / \
   2   4
  /
 1
Output: 3
Follow up:
What if the BST is modified (insert/delete operations) often and you need to find the kth smallest frequently? How would you optimize the kthSmallest routine?

 

Constraints:

The number of elements of the BST is between 1 to 10^4.
You may assume k is always valid, 1 ≤ k ≤ BST's total elements.
Accepted
390.6K
Submissions
657.5K
Seen this question in a real interview before?

Yes

No
Contributor
shtian



230/1485

*/

/**
 * Definition for a binary tree node.
 * class TreeNode(_value: Int = 0, _left: TreeNode = null, _right: TreeNode = null) {
 *   var value: Int = _value
 *   var left: TreeNode = _left
 *   var right: TreeNode = _right
 * }
 */
object Solution {
    def kthSmallest(root: TreeNode, k: Int): Int = {
        trait Result
        case class GotInferior(n: Int) extends Result
        case class GotTarget(e: Int) extends Result
        def leftSearch(r: TreeNode, i: Int): Result = {
            r match {
                case null => GotInferior(i)
                case r => leftSearch(r.left, i) match {
                    case GotInferior(n) => rightSearch(r, n + 1)
                    case o => o
                }
            }
        }
        def rightSearch(r: TreeNode, i: Int): Result = {
            if (i >= k) GotTarget(r.value)
            else leftSearch(r.right, i) 
        }
        
        leftSearch(root, 0) match {
            case GotTarget(e) => e
            case _ => -1    // Or throw a exception alerting the wrong input
        }
    }
}
