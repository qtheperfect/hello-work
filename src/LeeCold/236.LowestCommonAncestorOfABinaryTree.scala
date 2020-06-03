/*
236. Lowest Common Ancestor of a Binary Tree
Medium

3395

168

Add to List

Share
Given a binary tree, find the lowest common ancestor (LCA) of two given nodes in the tree.

According to the definition of LCA on Wikipedia: “The lowest common ancestor is defined between two nodes p and q as the lowest node in T that has both p and q as descendants (where we allow a node to be a descendant of itself).”

Given the following binary tree:  root = [3,5,1,6,2,0,8,null,null,7,4]


 

Example 1:

Input: root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 1
Output: 3
Explanation: The LCA of nodes 5 and 1 is 3.
Example 2:

Input: root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 4
Output: 5
Explanation: The LCA of nodes 5 and 4 is 5, since a node can be a descendant of itself according to the LCA definition.
 

Note:

All of the nodes' values will be unique.
p and q are different and both values will exist in the binary tree.
Accepted
443.6K
Submissions
1M
Seen this question in a real interview before?

Yes

No
Contributor
LeetCode



236/1467


*/


/**
 * Definition for a binary tree node.
 * class TreeNode(var _value: Int) {
 *   var value: Int = _value
 *   var left: TreeNode = null
 *   var right: TreeNode = null
 * }
 */

object Solution {
    def lowestCommonAncestor(root: TreeNode, p: TreeNode, q: TreeNode): TreeNode = {
        trait Result ; // Contains information of search result
        case class Found(ancestor: TreeNode) extends Result
        case class AtLarge(missing: Set[TreeNode]) extends Result
        def getState(o: TreeNode, target: Set[TreeNode]): Result = {
            if (o == null) AtLarge(target)
            else {
                val tNew = target - o
                if (tNew.size == 0) {
                    Found(o)
                }
                else getState(o.left, tNew) match {
                    case Found(x) if target.contains(o) => Found(o) // all targets but one are found under node 'x'
                    case Found(x)  => Found(x)
                    case AtLarge(t1) => {
                        getState(o.right, t1) match {
                            case Found(x) if  target == t1 => Found(x) // all targets are found under node 'x'
                            case Found(x) => Found(o)
                            case AtLarge(t2) => AtLarge(t2)
                        }
                    }
                    
                }
            }
        }
        getState(root, Set(p, q)) match {
            case Found(o) => o
            case _ => root // Unlikely to happen
        }
    }
       
}
