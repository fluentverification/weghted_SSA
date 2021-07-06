k = [1;
    1;
    0.1;
    1;1;
    0.1]; %rate constants

S = [-1,-1,1,0,0,0;
    1,1,-1,0,0,0;
    1,0,-1,0,1,0;
    0,0,0,-1,-1,1;
    0,0,0,1,1,-1;
    0,1,0,1,0,-1]'; %Stoichiometric matrix

X0 = [1;
    50;
    0;
    1;
    50;
    0]; %Initial state

F = zeros(6,1);
F(5,1) = 1; %Target condition matrix (F^T*x_t=xp)

xp = [40]; %target state (F^T*x_t=xp)

tmax = 100; %total simulation time


N = 1

mn = 0
for i = 1:N
   t = 0 
   delta_t = tmax - t
   x = X0
   w = 1
   
   h = calculatePropensity(x, k)
   while t<tmax
       if xp == F'*x
          mn = mn + w
          break
       end
       d = presimulationCheck(x,F,S,k,delta_t,xp,X0)
       flag = 0
       for j = 1:length(d)
           if d(j)<=0
               flag = 1
           end
       end
       if flag == 0
       
            h_tilde = calculatePropensity(x, k)
      
       elseif flag == 1
       
            h_tilde = calculatePredilection(x,k,S,F,delta_t,xp)
       end
       
       r1 = rand
       r2 = rand
       
       tau = -(1.0/sum(h_tilde)) * log (r1)
       
       temp_sum = 0 
       it = 1
       
       while temp_sum <= r2*sum(h_tilde)
           temp_sum = temp_sum + h_tilde(it)
           it = it + 1
       end
       
       it = it - 1
       w = w * (h(it)/h_tilde(it)) * exp((sum(h_tilde) - sum(h))*tau)
       t = t + tau
       delta_t = tmax - t
       x = x + S(:,it)
       h = calculatePropensity(x,k)
       
       
               
   end
end
p = mn/N
disp(p)