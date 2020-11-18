function [a, v, pf, eb] = sim_res(P_pv, P_ld, P_b, P_stc, p_gfl)
% SIM_RES: Subfunction (simu_erg) of the pvprog function. 
% 
%   Source: 
%       Joseph Bergner, Johannes Weniger, and Tjarko Tjaden. PVprog-Algorithmus
%       - Algorithmus zur Umsetzung der prognosebasierten Batterieladung f ¨ur PVSpeichersysteme
%       mit messwertbasierten PV- und Lastprognosen. Version 1.1.
%       Berlin, 2016
%
% Determines the relevant power flows and annual energy balances.
% Additionally, the degree of self-sufficiency and curtailment losses are
% determined.
%
% Inputs arguments:
%
%   P_pv:     PV power in W
%   P_ld:     Load in W
%   P_b:      Battery power flows (positive = charge, negative = discharge)
%             in W
%   P_stc:    Nominal PV capacity in kWp
%   p_gfl:    Feed-in limit in kW/kWp
%
% Output arguments:
%
%   a:      Degree of self-sufficiency
%   v:      Curtailment losses
%   pf:     Power flows (struct)
%   eb:     Energy balances (struct)
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
% MIT License
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

% Power flows
pf.P_pv = P_pv;
pf.P_ld = P_ld;
pf.P_d = P_pv - P_ld;
pf.P_du = min(P_pv, P_ld);
pf.P_bc = max(0, P_b);
pf.P_bd = abs(min(0, P_b));
pf.P_gf = max(0, min(P_stc * 1000 * p_gfl, pf.P_d - pf.P_bc));
pf.P_gs = abs(min(0, pf.P_d + pf.P_bd));
pf.P_ct = P_pv - pf.P_du - pf.P_bc - pf.P_gf;

% Energy balance
eb.E_pv = mean(pf.P_pv) * 8.76;
eb.E_ld = mean(pf.P_ld) * 8.76;
eb.E_du = mean(pf.P_du) * 8.76;
eb.E_bc = mean(pf.P_bc) * 8.76;
eb.E_bd = mean(pf.P_bd) * 8.76;
eb.E_gf = mean(pf.P_gf) * 8.76;
eb.E_gs = mean(pf.P_gs) * 8.76;
eb.E_ct = mean(pf.P_ct) * 8.76;

% Degree of self-sufficiency
a = (eb.E_du + eb.E_bd) / eb.E_ld;
% Curtailment losses
v = eb.E_ct / eb.E_pv;

end