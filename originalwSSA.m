%function [p, pArray, var, conf, tEnd] = originalwSSA(modelFile, N)
%input('Model Name? ')
%global delta %uncomment only for use with circuitBiasing.m
%eval(modelFile)

circuit0x8E_TI;
N = 50000;
q = 0;
pArray = zeros(1,N);
squareSum = 0;

tStart = tic;
for i = 1:N
    if mod(i,1000) == 0
        i
    end
    %i
    w = 1;
    t = 0;
    x = X0;
    
    a = calculatePropensity0x8E_TI(x); %only for Lukas' genetic circuit
    %a = calculatePropensity(x,k,S_in); %good for any other model
    a0 = sum(a);
    b = a.*alph;
    b0 = sum(b);
    
    while t < tmax
        if xp == F'*x
            q = q + w;
            squareSum = squareSum + w^2;
            break
        end
       r1 = rand;
       r2 = rand;
       
       tau = -(1.0/a0) * log(r1);
       
       temp_sum = 0;
       mu = 1;
       
       while temp_sum <= r2*b0
           temp_sum = temp_sum + b(mu);
           mu = mu + 1;
       end
       
       mu = mu - 1;
       
       w = w*(a(mu)/b(mu))*(b0/a0);
       t = t + tau;
       x = x + S(:,mu);
       
       a = calculatePropensity0x8E_TI(x);
       %a = calculatePropensity(x,k,S_in);
       a0 = sum(a);
       b = a.*alph;
       b0 = sum(b);
    end
    pArray(i) = q/i;
end
tEnd = toc(tStart);

p = pArray(end);
var = squareSum/N - p^2;
SE = (1/sqrt(N))*sqrt(var);
zstar = 1.96;
conf = [p-zstar*SE,p+zstar*SE]; %95% confidence interval
%end