%% Co-simulation of IEC 61499 PVprog + curtailment controller
clc
% Load input data
load('PerModAC_input.mat')
P_stc = 5; % Nominal PV capacity in kWp
C_bn = 8.33; % Nominal battery capacity in kWh 
P_bwr = 2.5; % Battery inverter's nominal capacity in kW
p_gfl = 0.5; % Specific feed-in limit in kW/kWp
P_gsl = 0; % Grid supply limit in W
p_pv = applyPerModACpvdc(ppvdc, P_stc);
time = (datenummx([2017 1 1 0 0 0]):1/86400:datenummx([2017 12 31 23 59 59]))';
dsel = 203;

matname = 'PVprogDer_matlab_forte_cosim_.mat';

%Prepend 10 days from end of year for initialization
lastDays = uint64(numel(p_pv)-10*86400+1:numel(p_pv)); 
p_pv = [p_pv(lastDays); p_pv];
Pld = [Pld(lastDays); Pld];
time = [time(lastDays) - 365; time];

% Run co-simulation
% dbstop if error % Uncomment to debug
[a, v, pf, eb, soc] = pvprog4diacDer(time, p_pv, Pld, P_stc, C_bn, P_bwr, p_gfl, P_gsl, 'NoMsgBox', true);
save(matname, 'pf', 'eb', 'a', 'v', 'dsel', 'time')
% dbclear if error % Uncomment to debug

pvBatPowerFlowFig(time, pf, 16, dsel, 86400);

%% Table of results

Y = {'Degree of self-sufficiency in %', 'Curtailment losses in %', 'PV generation in kWh', ...
    'Electricity consumption in kWh', 'Direct use in kWh', 'Battery charge in kWh', ...
    'Battery discharge in kWh', 'Grid feed-in in kWh', 'Grid supply in kWh', 'Curtailment in kWh'};
X = {'PVprog'};
Z = [a * 100; v * 100; eb.E_pv; eb.E_ld; eb.E_du; eb.E_bc; eb.E_bd; eb.E_gf; ...
    eb.E_gs; eb.E_ct];
Results = array2table(round(Z * 10) / 10, 'RowNames', Y, 'VariableNames', X);
disp(Results)