## Generate a random bipartite network to test five ...

#Generate a ramdom bipartite network and play five game
using PyPlot



function blc(A)
    ## A is binary m*n binary matrix and sum(A) is dividable by m
    ## Balance row sum of A by  exchange within colomns
    (m,n) = size(A);
    k = sum(A)/m;
    notdone = true;
    while(notdone)
        cop = [sum(A[i,:]) for i in 1:m];
        bg = cop.>k;
        sl = cop.<k;
        if length(cop[bg])==0
            notdone = false;
        else
            nrp = randperm(n)
            for j in nrp
                a= bg .& (A[:,j].>0);
                b = sl .& (A[:,j].<=0);
                Ted = swithrnd(A[:,j],a,b);
                if length(Ted)>0
                    A[:,j] = Ted;
                end
                break;
            end
        end
    end
    return A;
end

randfrom(T,p=1) = find(T.>0)[randperm(end)[1:min(end,p)]];

function swithrnd(L,lin,lou)
    a = randfrom(lin.>0);
    b = randfrom(lou.>0);
    if (length(a)==0) | (length(b)==0)
        return [];
    else
        a = a[1];
        b=b[1];
        t = L[a];
        L[a]=L[b];
        L[b] = t;
        return L;
    end
end




function buildCM(m=40, k1=5, k2=20)
    ## Build a big Connection Metrix.
    Cm = randperm(m*m*k1*k2);
    Cm = map( x->(x%m==1)?1:0, Cm );
    Cm = reshape(Cm, k1*m, k2*m);
    Cm = blc(blc(Cm')');
    return Cm;
end



function getGs(P,Cm)
    (k1,k2) = size(Cm);
    prodbut1(val,mar,i) =(mar[i]==0)?0: prod([( mar[j]==0 || i==j)?1:val[j] for j=1:length(val)]); 
    G1 = sum([prodbut1(P,Cm[:,j],i) for i=1:k1, j=1:k2],2);
    G2 = sum([prodbut1(1-P,Cm[:,j],i) for i=1:k1, j=1:k2],2);
    return (G1,G2);
end


function getHs(P,Cm,S)
    (G1,G2) = getGs(P,Cm);
    H1 = [(S[i]==1?G1[i]:G2[i]) for i in 1:length(G1)];
    H2 = [(S[i]==1?G2[i]:G1[i]) for i in 1:length(G2)];
    return (H1,H2);
end

function switchnot(p,g1,g2,alpha,rnd)
    b = g1-g2;
    if b>0
        return 1-(1-b)*exp(-1-b)
    else
        return b*exp(b-1)
    end
    


    ##############
    if p==1 && exp(alpha*b)<rnd
        return 0;
    elseif  p==0 && exp(-alpha*b)<rnd
        return 1;
    else
        return p
    end
    
end

function trainPs(Cm,S)
    # State Vector...
    P = rand( size(Cm,1));
    
    
    #Learn Rate beta...
    beta =0.8;
    
    max_iter = 300;
    GHistory = zeros(2,max_iter);
    PHistory = zeros(length(P), max_iter);
    
    
    for iter = 1:max_iter
        (H1,H2) = getHs(P,Cm,S);
        Pnew = [switchnot( P[i], H1[i], H2[i], beta, rand()) for i=1:length(P)];
        iRand = rand(1:length(Pnew))
        P[iRand] = Pnew[iRand]
        Grn = H1.*P + H2.*(1-P);
        GHistory[:,iter] = [mean(Grn[S.==1]), mean(Grn[S.==0])];
        PHistory[:,iter] = P;
    end
    figure(3)
    plt[:gcf]()[:clear]()
    imshow(PHistory, cmap="Greys")
    plt[:ylabel]("Agents")
    plt[:xlabel]("Time")
    pause(1)
    plt[:savefig]("PHistory.eps", frameon=true)
    return (P, GHistory,PHistory)
end


# Main script goes here:
function testall()
    Cm = buildCM(10, 5, 20);

    figure(1)
    imshow(Cm)
    plt[:xlabel]("Clusters")
    plt[:ylabel]("Agents")
    plt[:savefig]("Network.eps", frameon=true)
    
    # S is the strategy matrix...

    bRate = 0.0;
    S = rand(size(Cm,1))
    S[S.<bRate] = 0;
    S[S.>=bRate] = 1;
    
    (P,GHistory, PHistory) = trainPs(Cm,S);

    figure(2)
    plt[:gcf]()[:clear]()    
    plot(GHistory');
    plt[:xlabel]("Time")
    plt[:ylabel]("Total Reward")
    plt[:savefig]("randcurve.eps")
    writedlm("Cm", Cm);
    return GHistory
end

for iter = 1:1
    println("Slowly to $iter")
    GHistory = testall();
    asd = GHistory[1, (end-20) : end];
    if maximum(asd) - minimum(asd) >0.2
        break;
    end
end

        
