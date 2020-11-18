function [a, v, pf, eb, soc] = pvprog4diacDer(time, p_pv, P_ld, P_stc, C_bn, P_bwr, p_gfl, P_gsl, varargin)
%PVPROG4DIACDER Co-simulation of the PVprog algorithm between Matlab and 4diac-RTE (FORTE).
%The FORTE application also performs PV curtailment (deration).
%This function establishes a TCP/IP connection between Matlab and FORTE.
%Run this function first and then deploy the IEC 61499 application to
%FORTE when prompted in the command window.
%
%   Source of PVprog algorithm:
%       Joseph Bergner, Johannes Weniger, and Tjarko Tjaden. PVprog-Algorithmus
%       - Algorithmus zur Umsetzung der prognosebasierten Batterieladung f ¨ur PVSpeichersysteme
%       mit messwertbasierten PV- und Lastprognosen. Version 1.1.
%       Berlin, 2016
%
% Syntax:
%
%   [a, v, pf, eb, soc] = pvprog4diacDer(time, p_pv, P_ld, P_stc, C_bn, P_bwr, p_gfl, P_gsl);
%
% Inputs arguments:
%
%   time:     time stamp (as datenum)
%   p_pv:     PV power in kW/kWp
%   P_ld:     Load in W
%   P_stc:    Nominal PV capacity in kWp
%   C_bn:     Battery's nominal capacity (energy in kWh)
%             NOTE: Must be the same as the value set in the 4diac battery
%                   model.
%   P_bwr:    Battery inverter nominal power
%   p_gfl:    Feed-in limit in kW/kWp (0 for no limit)
%   P_gsl:    Grid supply limit in W (0 for no limit)
%
% Output arguments:
%
%   a:      Degree of self-sufficiency
%   v:      Curtailment losses
%   pf:     Power flows (struct)
%   eb:     Energy balances (struct)
%   soc:    Vector containing the battery's state of charge over the
%           simulation time.
%
% Struct field name abbreviations:
%
%   P:  Power
%   E:  Energy
%   pv: Photovoltaics
%   ld: Load
%   d:  Difference power/energy (pv - ld)
%   du: direct use
%   bc: battery charge
%   bd: battery discharge
%   gf: grid feed-in
%   gs: grid supply
%   ct: curtailment
%
%
% Required functions:
%
%   - bat_sim.m
%   - sim_res.m
%
% Author: Marc Jakobi, 08 June 2017
%         HTW Berlin
%
%
% MIT License (PVprog algorithm)
%
% Copyright (c) 2016 Joseph Bergner, Johannes Weniger, Tjarko Tjaden
%
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.

%% Parse optional inputs
p = inputParser;
addOptional(p, 'NoMsgBox', false, @islogical);
parse(p, varargin{:});
noMsgBox = p.Results.NoMsgBox;

%% Establish communication links
% tcpip4diac objects
t_pv = tcpip4diac('client', 'localhost', 61500, ...
    'DataInputs', {'LREAL'; 'LREAL'}); % PV power client
t_ld = tcpip4diac('client', 'localhost', 61501, ...
    'DataInputs', {'LREAL'; 'LREAL'}, 'DataOutputs', {}); % Load client
t_clck = tcpip4diac('client', 'localhost', 61502, 'DataOutputs', {}); % Clock client for time stamp
% Battery server
t_bat = tcpip4diac('server', '0.0.0.0', 61503, 'DataInputs', {'LREAL', 'LREAL'});
% initialize client connections
disp(' ')
disp('Initializing connection...')
disp('Please deploy the 4diac application to FORTE.')
disp(['Before deploying, make sure the BATTERY function block''s ID is set to: ', ...
    tcpip4diac.getLocalHostIP,':61503'])
try
    init(t_bat, 1)
catch
    waitfor(msgbox(['Make sure the BATTERY function block''s ID is set to: ', ...
    tcpip4diac.getLocalHostIP,':61503']))
    init(t_bat, 1)
end
disp('Application has been deployed.')
disp('Battery connection established...')
init(t_pv, 1)
disp('PV generator connection established...')
init(t_ld, 1)
disp('Load meter connection established...')
init(t_clck, 1)
disp('All devices connected!')
disp(' ')

%% Initialization
t_vec = datevec(time);
sz = size(p_pv);
P_pv = p_pv * P_stc * 1000;
% Initialize limits. Vectors are used in case varying limits would like to
% be simulated.
P_gfl = p_gfl * P_stc * 1000;
if numel(P_gfl) == 1
    P_gfl = P_gfl * ones(sz);
end
if numel(P_gsl) == 1
    P_gsl = P_gsl * ones(sz);
end
soc_max = 0.8;
soc_min = 0.2;
% P_pvd: Derated PV power
[soc, P_pvd] = deal(zeros(sz)); % normalized to useable capacity
P_b = soc;
C_bu = C_bn * (soc_max - soc_min);
% Elapsed time between time steps in seconds
dt = 86400 * (datenummx(t_vec(2:end,1:3)) - datenummx(t_vec(1:end-1,1:3))) + ...
    (t_vec(2:end,4:6) - t_vec(1:end-1,4:6)) * [3600; 60; 1];
dt = [dt; mean(dt)]; % Estimate size of last time step
eta_batt = 0.95; % Battery efficiency (assumed for charging only, discharging efficiency assumed as 1)
eta_binv = 0.94; % Battery inverter efficiency (assumed as equal for both charging and discharging)

%% Simulation
if ~noMsgBox
    waitfor(msgbox(['Ready to begin FORTE-Matlab co-simulation. ', ...
        'Optional: Enable monitoring in 4diac and press OK to continue.']))
end
disp('Running MATLAB-FORTE co-simulation...')
disp(' ')
df = 1; % Initialize derating factor
n = numel(time);
% Waitbar initialization
ntpd = 1440 * 60 / mean(dt); % number of time steps per day
exTimes = zeros(ceil(n / ntpd), 1); % loop execution times
timerCT = 0;
progr = waitbar(0, 'Running simulation...');
timerVal = tic;
for t = 2:n
    % Send data to FORTE
    P_pvd(t) = df * P_pv(t); % PV power deration
    reqNorsp(t_pv, {P_pvd(t); P_gfl(t)}) % Send derated PV power
    req(t_ld, {P_ld(t); P_gsl(t)})
    req(t_clck, t_vec(t,:))
    % Wait for response from FORTE
    P_bf = waitForData(t_bat); % Battery charge set power
    % Simulate battery
    [P_b(t), soc(t)] = bat_sim(dt(t), P_bf, C_bu, P_bwr, eta_batt, eta_binv, soc(t-1));
    % Determine SoC normalized to nominal capacity and send to FORTE
    rsp(t_bat, {soc_min + (soc_max - soc_min) * soc(t), P_b(t)})
    % Await PV power response from FORTE
    df = waitForData(t_pv); % Get derating factor
    if ceil(t / ntpd) == t / ntpd % Waitbar update
        timerCT = timerCT + 1;
        exTimes(timerCT) = toc(timerVal);
        rem = mean(exTimes(1:timerCT)) * (n - t) / ntpd / 60;
        if rem > 1
            unit = ' min ';
        else
            rem = round(rem * 60);
            unit = ' s ';
        end
        timerVal = tic;
        waitbar(t / n, progr, ['Simulating day ', num2str(ceil(t / ntpd)), ' of ', ...
            num2str(ceil(n / ntpd)), '... Approx. ', num2str(rem), unit, 'remaining...'])
    end
end
delete(progr)
%% Deinitialize
init(t_bat, 0)
init(t_pv, 0)
init(t_ld, 0)
init(t_clck, 0)
disp('Co-simulation completed. FORTE can be closed.')
toc
disp(' ')

%% Return outputs
% Pass derated PV power to sim_res without feed-in limit
if n > 31536000 % Remove pre-simulation data
    strt = n - 31536000 + 1; % beginning of main simulation
    P_pv = P_pv(strt:end);
    P_ld = P_ld(strt:end);
    P_b = P_b(strt:end);
    P_pvd = P_pvd(strt:end);
end 
[a, ~, pf, eb] = sim_res(P_pvd, P_ld, P_b, P_stc, inf);
% Adjust results
% Power flows
pf.P_pv = P_pv; % PV power
pf.P_ct = P_pv - P_pvd; % PV curtailment
% Energy amounts (1 s time stamp)
eb.E_pv = mean(pf.P_pv) * 8.76;
eb.E_ct = mean(pf.P_ct) * 8.76;
v = eb.E_ct / eb.E_pv;

end
