%% Simulation
clear
clc
% Load input data
load_inputs
dsel = 203;
matname = 'PVprog_matlab_cosim.mat';
C_bn = 8.33;

% Append last 10 days for pre-simulation
lastDays = uint64(numel(p_pv)-10*1440+1:numel(p_pv)); 
p_pv = [p_pv(lastDays); p_pv];
P_ld = [P_ld(lastDays); P_ld];
time = [time(lastDays) - 365; time];

% Run co-simulation
% dbstop if error % Uncomment to enable debug mode
[a, v, pf, eb, soc] = pvprog4diac0(time, p_pv, P_ld, P_stc, C_bn, P_bwr, p_gfl, P_gsl);
save(matname)
% dbclear if error % Uncomment to disable debug mode

%% Table of results

Y = {'Degree of self-sufficiency in %', 'Curtailment losses in %', 'PV generation in kWh', ...
    'Electricity consumption in kWh', 'Direct use in kWh', 'Battery charge in kWh', ...
    'Battery discharge in kWh', 'Grid feed-in in kWh', 'Grid supply in kWh', 'Curtailment in kWh'};
X = {'PVprog'};
Z = [a * 100; v * 100; eb.E_pv; eb.E_ld; eb.E_du; eb.E_bc; eb.E_bd; eb.E_gf; ...
    eb.E_gs; eb.E_ct];
Results = array2table(round(Z * 10) / 10, 'RowNames', Y, 'VariableNames', X);
disp(Results)