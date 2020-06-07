/*
94. Binary Tree Inorder Traversal
Medium

2910

124

Add to List

Share
Given a binary tree, return the inorder traversal of its nodes' values.

Example:

Input: [1,null,2,3]
   1
    \
     2
    /
   3

Output: [1,3,2]
Follow up: Recursive solution is trivial, could you do it iteratively?

Accepted
707K
Submissions
1.1M
Seen this question in a real interview before?

Yes

No
Contributor
LeetCode
Validate Binary Se
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
    def inorderTraversal(root: TreeNode): List[Int] = {
        // tail-recursive function worker:
        def worker(r: TreeNode, remain: List[(Int, TreeNode)] = Nil, res: List[Int] = Nil): List[Int] = {
            if (r != null)  worker(r.right, (r.value, r.left) :: remain, res)
            else remain match {
                case Nil => res
                case (v, left) :: remainTail => worker(left, remainTail, v :: res)
            }
        }
        worker(root)
    }
        
}
