// 81. Search in Rotated Sorted Array II
// Medium

// 1155

// 451

// Add to List

// Share
// Suppose an array sorted in ascending order is rotated at some pivot unknown to you beforehand.

// (i.e., [0,0,1,2,2,5,6] might become [2,5,6,0,0,1,2]).

// You are given a target value to search. If found in the array return true, otherwise return false.

// Example 1:

// Input: nums = [2,5,6,0,0,1,2], target = 0
// Output: true
// Example 2:

// Input: nums = [2,5,6,0,0,1,2], target = 3
// Output: false
// Follow up:

// This is a follow up problem to Search in Rotated Sorted Array, where nums may contain duplicates.
// Would this affect the run-time complexity? How and why?
// Accepted
// 228,000
// Submissions
// 691,868
// Seen this question in a real interview before?

// Yes

// No
// Contributor
// LeetCode

object Solution{
    def search(nums: Array[Int], target: Int): Boolean = {
        trait Status {
            def merge(y: Status): Status
        }
        case class Found(index: Int) extends Status {
            def merge(y: Status): Status = this
        }
        case class GetBreak(left: Int, right: Int) extends Status {
            def merge(y: Status): Status = y match {
                case Found(x) => Found(x)
                case GetBreak(l, r) => GetBreak(l, r)
                case _ => this
            }
        }
        case class Fruitless() extends Status {
            def merge(y: Status): Status = y
        }

        def linearSearch(i: Int, j: Int): Status = {
            if (i > j) Fruitless()
            else {
                val m = (i + j) / 2
                if (nums(m) == target) Found(m)
                else if (nums(m) < target) linearSearch(m + 1, j)
                else linearSearch(i, m - 1)
            }
        }
        
        def subSearch(i: Int = 0, j: Int = nums.length - 1): Status = {
            if (i > j) Fruitless()
            else {
                val dftStatus = if (nums(i) <= nums(j)) Fruitless() else GetBreak(i, j)
                val m = (i + j) / 2
                if (nums(m) == target) Found(m)
                else if (nums(i) < nums(j)) { 
                    if (nums(i) <= target && nums(j) >= target) //useful optimization
                        linearSearch(i, j)
                    else
                        Fruitless()
                }
                else if (nums(i) > target && nums(j) < target) GetBreak(i, j) //useful  optimization
                else subSearch(i, m - 1) match {
                    case x: Found => x
                    case x: GetBreak => x.merge( linearSearch(m + 1, j) )
                    case _ => dftStatus.merge(subSearch(m + 1, j))
                }
            }
        }
        
        subSearch() match {
            case x: Found => true
            case _ => false
        }
    }
}


