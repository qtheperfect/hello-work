q=str([str(0), str(0)])[1] # The single quote
l=[
    '    '
    ,'q=str([str(0), str(0)])[1] # The single quote'
    ,'l=['
    ,']'
    ,'for a in l[1:3]: # print to left bracket, then insert List items'
    ,'    print(a)'
    ,'print(l[0]+q+l[0]+q)'
    ,'for a in l[1:]:'
    ,'    print(l[0]+","+q+a+q)'
    ,'for a in l[3:]:'
    ,'    print(a)'
]
for a in l[1:3]: # print to left bracket, then insert List items
    print(a)
print(l[0]+q+l[0]+q)
for a in l[1:]:
    print(l[0]+","+q+a+q)
for a in l[3:]:
    print(a)
