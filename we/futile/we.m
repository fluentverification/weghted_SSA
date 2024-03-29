t_start = tic;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation pararmeters
N = 200;
time_step = 1;
bin_pop = 30;
samples = (0);
samples(end) = [];
sim_samples = (0);
sim_samples(end) = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Model specific binning

% Success bin. Trajectories in success bin are not simulated further. 
% weight of those trajectories are used to calculate the mean and variance 
% of estimate
success_bin = 25; 

% ss bin. representing the rest of the state space not as precisely probed. 
ss_bin = 51; 

% Normal bin. Population for normal bins is set to be bin_pop. % Main part 
% of weighted ensemble. 

% For futile cycle S5>50 indicates ss bin. 26=<S5<=50 indicates normal
% bins. S5<=25 is the success bin.

for i = 1:51
    bin_obj(i) = bin(i);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


futileCycle;

sum_succ_weights = 0; 
sum_fail_weights = 0; 
num_succ = 0;
num_fail = 0;
total_traj_segments = 0;

for i = 1:N
    i

    for ii = 1:51
        bin_obj(ii) = bin(ii);
    end
    
    % Populate the bin containing initial state to bin_pop
    for ii = 1:bin_pop
        bin_obj(50).traj_list(ii) = trajectory(0, 50, (1.0/bin_pop), X0);
    end
    
    flag = false;

    while (~flag)
        
        % simulate all the trajectories in bins 26:51 for
        % 'time_step' units of time. If all the trajectories are simulated
        % beyond tmax, end the simulation.
        flag = true;
        for ii = 26:51
            sz = bin_size(bin_obj(ii));
            if sz > 0
                for iii=1:sz
                    curr_time = bin_obj(ii).traj_list(iii).time; 
                    curr_x = bin_obj(ii).traj_list(iii).x;
                    if curr_time < tmax
                        flag = false;
                        total_traj_segments = total_traj_segments + 1;
                        while (curr_time - bin_obj(ii).traj_list(iii).time) < time_step
                            a = calculatePropensity(curr_x,k,S_in);
                            a0 = sum(a);
                            r1 = rand;
                            r2 = rand;
                            tau = -(1.0/a0) * log(r1);
               
                            temp_sum = 0;
                            mu = 1;
                            while temp_sum <= r2*a0
                                temp_sum = temp_sum + a(mu);
                                mu = mu + 1;
                            end
                            mu = mu - 1;
               
                            curr_time = curr_time + tau;
                            curr_x = curr_x + S(:,mu);
                        end
                    end
                    bin_obj(ii).traj_list(iii).x = curr_x;
                    bin_obj(ii).traj_list(iii).time = curr_time;
                    if curr_x(5) <= 25
                        bin_obj(ii).traj_list(iii).bin = 25;
                    elseif curr_x(5) <=50
                        bin_obj(ii).traj_list(iii).bin = curr_x(5);
                    else
                        bin_obj(ii).traj_list(iii).bin = 51;
                    end
                end
            end
        end
        
        % If all the trajectories in all bins (except for the success bin)
        % are simulated beyond tmax, end the simulation
        if flag
            break
        end

        % check all the trajectories in all bins and add them
        % to appropriate bins
        
        for ii = 26:51
            sz = bin_size(bin_obj(ii));
            if sz>0
                for iii=1:sz
                    if bin_obj(ii).traj_list(iii).bin ~= ii
                        if bin_obj(ii).traj_list(iii).bin <= 25
                            bin_obj(25).traj_list(end+1) = bin_obj(ii).traj_list(iii);
                        elseif bin_obj(ii).traj_list(iii).bin <= 50
                            bin_obj(bin_obj(ii).traj_list(iii).bin).traj_list(end+1) = bin_obj(ii).traj_list(iii);
                        else
                            bin_obj(51).traj_list(end+1) = bin_obj(ii).traj_list(iii);
                        end
                    end
                end
            end
         end
        

        % check the trajectories in all bins and remove the ones that do
        % not belong
         for ii = 26:51
            flag_ = true;
            while (flag_)
                flag_ = false;
                sz = bin_size(bin_obj(ii));
                if sz > 0
                    for iii=1:sz
                        if bin_obj(ii).traj_list(iii).bin ~= ii
                            bin_obj(ii).traj_list(iii) = [];
                            flag_ = true;
                            break
                        end
                    end
                end
            end
         end


        
        for ii=26:51
            sz = bin_size(bin_obj(ii));
            if sz > 0
                if sz < bin_pop
                    bin_obj(ii) = populate(bin_obj(ii), bin_pop);
                elseif sz > bin_pop
                    bin_obj(ii) = merge(bin_obj(ii), bin_pop);
                end
            end
        end
              
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% After each iteration is done, save how many trajectories have
% succeed/failed and what is the sum of weight for those

    sz_25 = bin_size(bin_obj(25)); 
    if sz_25>0
        for ii=1:sz_25
            num_succ = num_succ + 1;
            sum_succ_weights = sum_succ_weights + bin_obj(25).traj_list(ii).weight;
            samples(end+1) = bin_obj(25).traj_list(ii).weight;
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
    sim_samples(end+1) = sum(samples);
    samples = (0);
    samples(end) = [];
end




t_end = toc(t_start);

p = sum_succ_weights/N;
p1 = mean(sim_samples);
v = var(sim_samples);

SE = (1/sqrt(N))*sqrt(v);
%zstar = 1.96;
%conf = [p-zstar*SE,p+zstar*SE]; %95% confidence interval
