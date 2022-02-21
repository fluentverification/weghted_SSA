clear;clc;
bin_pop_values = 10:20:190;

%for i = 1:length(bin_pop_values)
%    disp(bin_pop_values(i))
%    %waitbar(i/length(bin_pop_values));
%    bin_pop_ = bin_pop_values(i);
%    [p(i), t(i), v(i)] = we_function(bin_pop_);
%end
d = load('../../../we_figures/motility/N=50/estimate.mat');
p = d.p;

circuitTrue = 6.29e-4*ones(size(p));
yeastTrue = 1.202e-6*ones(size(p));
motilTrue = 2.16117e-7*ones(size(p));
futileTrue = 1.71e-7*ones(size(p));

%%
figure(1)
hold on
plot(bin_pop_values, p, bin_pop_values, motilTrue, 'lineWidth', 2)
legend("WE Estimate", "True Probability")
set (gcf, 'color', 'w')
legend boxoff 
xlabel("Bin Size", 'fontsize', 20)
ylabel("Probability", 'fontsize', 20)
set (gca, 'linewidth', 4)
set(gca, 'YScale', 'log')
ylim([10^-09 10^-05])


%{
figure(2)
hold on
plot(bin_pop_values, t, 'lineWidth', 2)
legend("Time")
set (gcf, 'color', 'w')
legend boxoff 
xlabel("Bin Size", 'fontsize', 20)
ylabel("Time", 'fontsize', 20)
set (gca, 'linewidth', 4)

figure(3)
hold on
plot(bin_pop_values, v, 'lineWidth', 2)
legend("Variance")
set (gcf, 'color', 'w')
legend boxoff 
xlabel("Bin Size", 'fontsize', 20)
ylabel("Variance", 'fontsize', 20)
set (gca, 'linewidth', 4)
%}