#build a neural network
using PyPlot

zg(x) = hcat(x,ones(size(x,1),1));
dedx(dedy,dy,W) = (dedy.*dy) * W[1:end-1,:]';
dedw(x,dedy,dy) = zg(x)' * (dedy.*dy);

sfun(x) = 1./(1+exp.(-x));

netout(x,W1,W2) = zg(sfun(zg(x)*W1))*W2;

function train1c(xs,ys,W1,W2)
    M = size(xs,1);
    y1 = sfun(zg(xs)*W1);
    yT = zg(y1)*W2;
    e2 = yT-ys;
    e1 = dedx(e2, yT*0+1,W2);
    dW2 = -dedw(y1, e2, e2*0+1);
    dW1 = -dedw(xs, e1, y1.*(1-y1));
    return(dW1/M, dW2/M);
end

    
xs = 0:0.1:5;
xs = reshape(xs,:,1)

yT = xs.*sin.(xs);
N = length(xs);

W1 = -2*rand(2,46);
W2 = rand(47,1);

asd = plt[:plot](xs,yT,"r-");
ass = plt[:plot](xs,netout(xs,W1,W2),"b--");
ms = plt[:plot](-W1[2,:],0*W1[2,:], "k+");
alpha = 1
ddW1 = W1*0;
ddW2 = W2*0;
for iter = 1:10000
    (dW1, dW2) = train1c(xs,yT,W1,W2);
    ddW1 = ddW1+dW1;
    ddW2 = ddW2+dW2;
    # PD controller:
    W1 = W1+alpha*(0.3*ddW1+0.7*dW1);
    W2 = W2+alpha*(0.3*ddW2+0.7*dW2);
    # /alpha_n = /frac{1}{n}:
    alpha = alpha/(1+alpha); 
    ass[1][:set_ydata](netout(xs,W1,W2));
    ms[1][:set_xdata](-W1[2,:]);
    plt[:show]();
    title("Iteration at $iter")
    println(mean(abs.(yT-netout(xs,W1,W2))));
    sleep(0.001);
end

    

