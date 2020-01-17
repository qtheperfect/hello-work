function [ output_args ] = five( input_args )
%FIVE Summary of this function goes here
%   Detailed explanation goes here

N1 =  50;
N2 = 50;
delta = 0.00000001;
alpha = 0.5;

beta = 50;
sigma = 20000;


P = delta * rand(N1,N2);
C = zeros(size(P));
% C(ceil(N1/2), ceil(N2/2)) = 1;
% C(ceil(N1/2)+1, ceil(N2/2)+1) = -1;

P = rand(N1,N2);
 

max_iter = 200;

pulse = zeros(2,max_iter);

for iter = 1:max_iter
    
    G1 = zeros(N1, N2);
    G2 = zeros(N1, N2);
    
    P(C==1) = 1;
    P(C==-1) = 0;
    
    for i = 1:N1
        for j = 1:N2
            ii = gt(i+(1:5),N1);
            jj = gt(j+(1:5),N2);
            jjr = gt(j-(1:5),N2);
            DiagIJ = ij(ii,jj,N1,N2);
            DiagIJr = ij(ii,jjr,N1,N2);
            ns_i = [-1, -1, 0,1,1,1,0,-1];
            ns_j = [0,   1, 1,1,0,-1,-1,-1];
            neisIJ = ij(gt(ns_i, N1), gt(ns_j, N2), N1, N2);
            
            G1(i,jj) = G1(i,jj) + prod( P(i,jj));
            G1(ii,j) = G1(ii,j) + prod( P(ii,j));
           
            G1(DiagIJ) = G1(DiagIJ) + prod(P( DiagIJ));
            G1(DiagIJr) = G1(DiagIJr) + prod(P( DiagIJr));
            
            G2(i,jj) = G2(i,jj) + prod(1 - P(i,jj));
            G2(ii,j) = G2(ii,j) + prod(1 - P(ii,j));
           
            G2(DiagIJ) = G2(DiagIJ) + prod( 1 - P(DiagIJ));
            G2(DiagIJr) = G2(DiagIJr) + prod( 1 - P(DiagIJr));
            
        end
    end
    
    G1 = (G1+G2)/2;
    G2 = (G1+G2)/2;;
   
    K1 =  ( beta * G1) ;
    
    K2 = ( beta * G2)  ;
    
    K1 = K1/sum(sum(K1));
    K2 = K2/sum(sum(K2));
    
    Pnew = 1./(1+ exp(-sigma * (K1-K2)));
    
%     randP = rand(size(P));
%     randP(randP<0.95) = 0;
%     randP(randP >= 0.6) = 1;
%     randP = abs(randP - Pnew);
%     
%     Pnew = (1-delta) * Pnew + delta * randP;
    P = (1-alpha) * P + alpha * Pnew;
    alpha = alpha / (1+alpha) ;
    
    P(C==1) = 1;
    P(C==-1) = 0;
    
    imshow(P,[]);
    title(strcat('Iteration at ', num2str(iter)));
    mean(mean(P))
    pulse(:,iter) = [mean(mean(G1));mean(mean(G2))];
    pause(0.1);
   
    
    
end

end

function y = gt(x,N)
y = mod(x-1, N)+1;
end

function Y = ij(ii,jj,N1, N2)
Y = zeros(N1, N2);
for k = 1:length(ii)
    Y(ii(k), jj(k)) = 1;
end
Y = logical (Y);
end


function pcols = zhifangtu(G)
pcols = zeros(1,255);
aaa = max(max(G));
bbb = min(min(G));
k = (aaa-bbb)/255;
for i = 1:255
    dd = double( aaa+(i-1)*k <= G & G < aaa+i*k);
    pcols(i) = sum(sum(dd));
end
end
