/*
93. Restore IP Addresses
Medium

1178

487

Add to List

Share
Given a string containing only digits, restore it by returning all possible valid IP address combinations.

A valid IP address consists of exactly four integers (each integer is between 0 and 255) separated by single points.

Example:

Input: "25525511135"
Output: ["255.255.11.135", "255.255.111.35"]
Accepted
187.3K
Submissions
537.1K
Seen this question in a real interview before?

Yes

No
Contributor
LeetCode

*/

object Solution {
    def restoreIpAddresses(s: String): List[String] = {
        case class HeadOff(left: List[String], remain: String) {
            
            // Transplanting from def to val doesn't improve much: 560 ms vs. 556ms
            val isValid: Boolean = {
                if (left.length > 4) false
                else if (left.length == 4 && remain.length > 0) false
                else if (left.length < 4 && remain.length == 0) false
                else true
            } 
            
            lazy val validHeads: Set[String] = {
                if (! isValid) Set[String]()
                else if (remain.startsWith("0")) Set("0")
                else{
                   val res = Set(
                        remain.slice(0, 1), 
                        remain.slice(0, 2),
                        remain.slice(0, 3),
                     )
                    res.filter(_.toInt <= 255)    
                }
            }
            
            def behead(init: String): String = {
                remain.slice(init.length, remain.length)
            }
            
            lazy val splidMore: Set[HeadOff] = {
                for {
                    headNew <- validHeads;
                    remainNew = behead(headNew)
                    thisNew = HeadOff(headNew :: left, remainNew);
                    if thisNew.isValid
                } yield {
                    thisNew
                }
            }.toSet
            
            val isTerminal: Boolean = left.length == 4
            lazy val extract: String = {
                def xDotY(x: String, y: String): String = x + "." + y 
                val res = left.reverse.foldLeft("")(xDotY)
                res.slice(1, res.length)
            } 
        } 
       
        def worker(input: Set[HeadOff] = Set(HeadOff(Nil, s))): Set[HeadOff] = {
            if (! input.exists(! _.isTerminal) ) input
            else {
                worker(input.flatMap(_.splidMore))
            }
        };
        worker().map(_.extract).toList
        
    }
}
