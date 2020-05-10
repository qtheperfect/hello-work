module TryTrees

abstract type Tree{T} end
struct EmptyTree{T} <: Tree{T} end
struct ValuableTree{T}  <: Tree{T}
    value::T
    left::Tree{T}
    right::Tree{T}
end

isEmpty(t::EmptyTree{T}) where T = true 
isEmpty(t::ValuableTree{T}) where T = false

treeHeight(t::EmptyTree{T}) where T = 0
treeHeight(t::ValuableTree{T}) where T = 1 + max( treeHeight(t.left), treeHeight(t.right) )

treeIns(v::T, t::EmptyTree{T}) where T = ValuableTree(v, EmptyTree{T}(), EmptyTree{T}())
function treeIns(v::T, t::ValuableTree{T}) where T 
    tl = t.left
    tr = t.right
    if v> t.value
        betterTree(ValuableTree(t.value, tl, treeIns(v, tr)))
    elseif v < t.value
        betterTree(ValuableTree(t.value, treeIns(v, tl), tr))
    else
        t
    end
end

treeFill( t::EmptyTree{T} ) where T = t
function treeFill(t::ValuableTree{T}) where T
    hl = treeHeight(t.left)
    hr = treeHeight(t.right)
    if hl == 0
        t.right
    elseif hr == 0
        t.left
    elseif hl >= hr
        ValuableTree(t.left.value, treeFill(t.left), t.right)
    else
        ValuableTree(t.right.value, t.left, treeFill(t.right))
    end
end

betterTree( t::EmptyTree{T} ) where T = t
function betterTree( t:: ValuableTree{T} ) where T
    hl = treeHeight(t.left)
    hr = treeHeight(t.right)
    if hl > hr+1
        ValuableTree(t.left.value, t.left.left, ValuableTree(t.value, t.left.right, t.right))
    elseif hl < hr-1
        ValuableTree(t.right.value, ValuableTree(t.value, t.left, t.right.left), t.right.right)
    else
        t
    end
end

treePrint(t::EmptyTree{T}, pf::Int64) where T = println("Empty")
function treePrint(t::ValuableTree{T}, pf::Int64=0) where T 
    pfBlanks = repeat(" ", pf) 
    print( "-> ", t.value, "\n")
    print( pfBlanks, "left: ")
    treePrint(t.left, pf+4)
#    println( pfBlanks, "endLeft" )
    print( pfBlanks, "right: ")
    treePrint( t.right, pf+4 )
#    println( pfBlanks, "endRight")
end


function treeFromList(li::Array{T}) where T
    res = EmptyTree{T}()
    for l in li
        res = treeIns(l, res)
    end
    res
end

testtree = treeFromList([1,2,3,4,5,6,7,8,9])
while (! isEmpty(testtree))
    global testtree
    println()
    treePrint(testtree)
    testtree = treeFill(testtree)
end

end # module TryTrees

using Main.TryTrees
TT = Main.TryTrees
