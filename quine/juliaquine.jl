q=Char(34) # The quote 
l=[
    "    "
    ,"q=Char(34) # The quote"
    ,"l=["
    ,"]"
    ,"for a in l[2:3] # Print to left braket"
    ,"    println(a)"
    ,"end"
    ,"println(l[1], q, l[1], q) # Print first of String Array"
    ,"for a in l[2:end] # Print Array items with comma"
    ,"    println(l[1], ',', q, a, q)"
    ,"end"
    ,"for a in l[4:end] # Print right braket to end"
    ,"    println(a)"
    ,"end"
]
for a in l[2:3] # Print to left braket
    println(a)
end
println(l[1], q, l[1], q) # Print first of String Array
for a in l[2:end] # Print Array items with comma
    println(l[1], ',', q, a, q)
end
for a in l[4:end] # Print right braket to end
    println(a)
end
