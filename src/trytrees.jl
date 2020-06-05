module TryTrees

abstract type Tree{T}  end
struct EmptyTree{T} <: Tree{T}
    height:: Int
end
EmptyTree{T}() where T = EmptyTree{T}(0)

struct ValuableTree{T}  <: Tree{T}
    value::T
    left::Tree{T}
    right::Tree{T}
    height::Int
end

ValuableTree(v::T, l::Tree{T}, r::Tree{T}) where T = ValuableTree(v, l, r, max(l.height, r.height) + 1)
ValuableTree(v::T) where T = ValuableTree(v, EmptyTree{T}(), EmptyTree{T}(), 1)

isEmpty(t::EmptyTree{T}) where T = true 
isEmpty(t::ValuableTree{T}) where T = false

treeHeight(t::EmptyTree{T}) where T = 0
treeHeight(t::ValuableTree{T}) where T = t.height

treeIns(v::T, t::EmptyTree{T}) where T = ValuableTree(v, EmptyTree{T}(), EmptyTree{T}())
function treeIns(v::T, t::ValuableTree{T}) where T 
    # insert element to tree
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
    if hl > hr + 1
        betterTree(ValuableTree(t.left.value, t.left.left, ValuableTree(t.value, t.left.right, t.right)))
    elseif hl < hr-1
        betterTree(ValuableTree(t.right.value, ValuableTree(t.value, t.left, t.right.left), t.right.right))
    else
        t
    end
end

listTree( t::EmptyTree{T} ) where T = []
function listTree( t::ValuableTree{T} ) where T  
    vcat(listTree(t.left), [t.value], listTree(t.right))
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


testtree = treeFromList([1,2,3,5,6,7,8,9])
treePrint(testtree)

# cutTop: insert one value v while delate all value larger than v, return a new tree and a list of deleted value
cutTop(t::EmptyTree{T}, v::T) where T = (ValuableTree(v), Array{T, 1}[])
function cutTop(t::ValuableTree{T}, v::T) where T
    if t.value > v
        (insleft, cutleft) = cutTop(t.left, v)
        (betterTree(insleft), vcat([t.value], listTree(t.right), cutleft))
    elseif t.value < v
        (insright, cutright) = cutTop(t.right, v)
        (betterTree(ValuableTree(t.value, t.left, insright)), cutright)
    else
        (t, [])
    end
end

(t1, outer) = cutTop(testtree, 4)
treePrint(t1)
println(outer)

t1 = EmptyTree{Float64}()
l0 = []
for v in vcat(1.0:4, 5.0:-2:1, 2.0:0.5:4, [4.2, 3.2,1,5])
    global t1, l0
    (t1, l1) = cutTop(t1, v)
    #treePrint(t1)
    println("value=$(v)")
    println(l1)
    l0 = vcat(l0, l1)
end

end # module TryTrees

using Main.TryTrees
TT = Main.TryTrees
