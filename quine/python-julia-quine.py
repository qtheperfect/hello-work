q=chr(34) # The quote
l=[
    "    "
    ,"       <<< Python Code >>>"
    ,"q=chr(34) # The quote"
    ,"l=["
    ,"]"
    ,"for a in l[13:15]: # print to left bracket, then insert List items"
    ,"    print(a)"
    ,"print(l[0]+q+l[0]+q)"
    ,"for a in l[1:]:"
    ,"    print(l[0]+','+q+a+q)"
    ,"for a in l[15:]:"
    ,"    print(a)"
    ,"       <<< Julia Code >>>"
    ,"q=Char(34)"
    ,"l=["
    ,"]"
    ,"for a in l[3:4] # Print to left bracket"
    ,"    println(a)"
    ,"end"
    ,"println(l[1], q, l[1], q) # Print first of String Array"
    ,"for a in l[2:end] # Print Array items with comma"
    ,"    println(l[1], ',', q, a, q)"
    ,"end"
    ,"for a in l[5:12] # Print right braket to python end"
    ,"    println(a)"
    ,"end"
]
for a in l[13:15]: # print to left bracket, then insert List items
    print(a)
print(l[0]+q+l[0]+q)
for a in l[1:]:
    print(l[0]+','+q+a+q)
for a in l[15:]:
    print(a)
