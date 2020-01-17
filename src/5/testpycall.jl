using PyPlot
jk = 0:0.1:5;
asd = plt[:plot](jk,sin(jk),"r--");
for iter = 1:123
    asd[1][:set_ydata]( sin.(jk-0.2*iter));
    plt[:show]();
    sleep(0.1);
end
