class PrintHeap
  @@testList = (0..18).to_a
  def initialize(list = @@testList)
    @@testList = list
  end
  def call()
    doPrint()
  end
  def doPrint(list = @@testList, k = 0, position = 0, indent = 0)
    if position < indent
      print "    \t"
      doPrint(list, k, position + 1, indent)
    elsif k >= list.size
      print (")")
    else
      print list[k] ; print "  \t";
      doPrint(list, 2 * k + 1, position + 1, indent + 1)
      if 2*k + 2 < list.size()
        puts ","
        doPrint(list, 2 * k + 2, 0, indent + 1)
      end
    end
  end
end


class DoSort
  @@list = [4, 2, -3, 7, 100, 10, 1, 9, 8, 6, 11, 3, 7, 4, 9]
  def getList
    return @@list
  end
  def printHeap
    PrintHeap.new(@@list).call()
    puts("")
  end
  def setList(list)
    @@list = list
    return self
  end
  def largerSon(k, l = @@list.size())
    if (k >= l)
      return []
    else
      sons = [2*k + 1, 2*k + 2].filter do |x|
        x < l && @@list[x] > @@list[k]
      end
      if sons.size() == 0
        return []
      else
        return [sons.max_by {|x| @@list[x]}]
      end
    end
  end
  def makehead(k, l = @@list.size())
    ss = largerSon(k, l)
    if ss.size() == 0
      return self
    else
      k1 = ss[0]
      temp = @@list[k]
      @@list[k] = @@list[k1]
      @@list[k1] = temp
      return makehead(k1, l)
    end
  end
  def makeHeap(k = 0, l = @@list.size())
    if k >= l
      return self
    else
      return makeHeap(2*k + 1, l)
               .makeHeap(2*k + 2, l)
               .makehead(k)
    end
  end
  def sortHeap(l = @@list.size)
    if l <= 0
      return self
    else
      temp = @@list[l - 1]
      @@list[l - 1] = @@list[0]
      @@list[0] = temp
      return makehead(0, l - 1).sortHeap(l - 1)
    end
  end

  def sort()
    return makeHeap()
             .sortHeap()
  end
end

obj = DoSort.new
obj.printHeap
obj.makeHeap().printHeap()

puts obj.sort.getList().join(",\t")
  
