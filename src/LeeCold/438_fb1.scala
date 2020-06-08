/*
438. Find All Anagrams in a String
Medium

2928

168

Add to List

Share
Given a string s and a non-empty string p, find all the start indices of p's anagrams in s.

Strings consists of lowercase English letters only and the length of both strings s and p will not be larger than 20,100.

The order of output does not matter.

Example 1:

Input:
s: "cbaebabacd" p: "abc"

Output:
[0, 6]

Explanation:
The substring with start index = 0 is "cba", which is an anagram of "abc".
The substring with start index = 6 is "bac", which is an anagram of "abc".
Example 2:

Input:
s: "abab" p: "ab"

Output:
[0, 1, 2]

Explanation:
The substring with start index = 0 is "ab", which is an anagram of "ab".
The substring with start index = 1 is "ba", which is an anagram of "ab".
The substring with start index = 2 is "ab", which is an anagram of "ab".
Accepted
255,733
Submissions
599,508
Seen this question in a real interview before?

Yes

No
Contributor
Stomach_ache
Valid Anagram
Easy
Permutation in String
Medium

*/
object Solution {
    def findAnagrams(s: String, p: String): List[Int] = {
        val pMap: Map[Char, Int] = p.toList.groupBy(identity).map{ case ((c: Char, l: List[Char]))  => (c, l.length) }
        val pSet: Set[Char] = p.toSet 
        def addOrCreate(m: Map[Char, Int], c: Char): Map[Char, Int] = {
            if (m.contains(c)) m.updated(c, m(c) + 1)
            else m.updated(c, 1)
        }
        def deductOrDel(m: Map[Char, Int], c: Char ): Map[Char, Int] = {
            val k = m(c)
            m.updated(c, k - 1)
        }
    
         def worker(i: Int, lastMap: Map[Char, Int]): List[Int] = {
             if (i > s.length - p.length) Nil
             else {
                 val cc = s(i + p.length - 1)
                 val thisMap = addOrCreate(lastMap,  cc)
                 val nextMap = deductOrDel(thisMap, s(i))
                 if (pSet.exists( x => pMap(x) != thisMap.getOrElse(x, 0))) worker(i + 1, nextMap)
                 else  i :: worker(i + 1, nextMap)
             }
         }
        val initMap: Map[Char, Int] = s.slice(0, p.length - 1).toList.groupBy(identity).map{case ((c, l)) => (c, l.length)}
        worker(0, initMap ) 
        
    }
}
