/*
91. Decode Ways
Medium

2461

2670

Add to List

Share
A message containing letters from A-Z is being encoded to numbers using the following mapping:

'A' -> 1
'B' -> 2
...
'Z' -> 26
Given a non-empty string containing only digits, determine the total number of ways to decode it.

Example 1:

Input: "12"
Output: 2
Explanation: It could be decoded as "AB" (1 2) or "L" (12).
Example 2:

Input: "226"
Output: 3
Explanation: It could be decoded as "BZ" (2 26), "VF" (22 6), or "BBF" (2 2 6).
Accepted
380,990
Submissions
1,575,019
Seen this question in a real interview before?

Yes

No
Contributor
LeetCode

*/


object Solution {
    def numDecodings(s: String): Int = {
    
        def inSingle(c: Char): Boolean = {
            val n = c - '0' 
            1 <= n && n <= 9
        }
        def inDouble(c1: Char, c2: Char): Boolean = {
            val n = (c1 - '0') * 10 + c2 - '0'
            10 <= n && n <= 26
        }
        
       
        def worker(i: Int , x: Int, y: Int): Int = {
            if (i >= s.length - 1) y
            else {
                val ab = inDouble(s(i), s(i + 1))
                val b = inSingle(s(i + 1))
                if (ab && b) worker(i + 1, y, x + y)
                else if (ab) worker(i + 1, y, x)
                else if (b) worker(i + 1, y, y)
                else worker(i + 1, y, 0)
            }
        }
        
        if (s.length == 0) 1
        else {
            val y = if (inSingle(s.head)) 1 else 0 
            worker(0, 1, y)
        }
    }
}
