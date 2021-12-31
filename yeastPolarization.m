%% Model Details
%from swSSA paper
k = [0.0038;
     0.0004;
     0.042;
     0.0100
     0.011;
     0.1;
     1050;
     3.21]; %rate constants

S_in = [0, 0, 0, 0, 0, 0, 0;
        1, 0, 0, 0, 0, 0, 0;
        1, 1, 0, 0, 0, 0, 0;
        0, 0, 1, 0, 0, 0, 0;
        0, 0, 1, 1, 0, 0, 0;
        0, 0, 0, 0, 1, 0, 0;
        0, 0, 0, 0, 0, 1, 1;
        0, 0, 0, 0, 0, 0, 0]'; 

S_out = [1, 0, 0, 0, 0, 0, 0;
         0, 0, 0, 0, 0, 0, 0;
         0, 1, 1, 0, 0, 0, 0;
         1, 0, 0, 0, 0, 0, 0;
         0, 0, 0, 0, 1, 1, 0;
         0, 0, 0, 0, 0, 0, 1;
         0, 0, 0, 1, 0, 0, 0;
         0, 0, 1, 0, 0, 0, 0]';

S = S_out - S_in; %stoichiometric matrix

X0 = [50;
      2;
      0;
      50;
      0;
      0;
      0]; %Initial state

F = zeros(7,1);
F(6,1) = 1; %Target condition matrix (F^T*x_t=xp)

xp = [50]; %target state (F^T*x_t=xp)

tmax = 20; %total simulation time


%% Original wSSA Parameters

alph = [1/delta; delta; 1/delta; delta; 1/delta; delta; delta; 1/delta];

     
%% swSSA Parameters

%Mohammad help