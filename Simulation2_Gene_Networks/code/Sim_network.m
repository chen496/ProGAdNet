
% This is a demo script of simulation with df package

% Step 1: parameters setting: specific meaning for each parameter can be found in the "simulation.m" and readme file
simu_round=50;
CHANGE_RATE=0.1;
var1=0.1;
all_var2=[0.05 0.5]';
SS_CYCLE=100;
DF_STEP1=10;
DF_STEP2=10;
TILL_STEP=10;
Ng=50;
Sample=[50 100 200 300];
varar=[0.05 0.5];

% Step 2: simulate data
for i=1:4
    simulation(Sample(i), simu_round, CHANGE_RATE, var1, all_var2, SS_CYCLE , DF_STEP1, DF_STEP2, TILL_STEP);
end

% Step 3: draw graphs & tables
simu_table(Ng,Sample);
simu_plot(Ng,Sample,varar);
