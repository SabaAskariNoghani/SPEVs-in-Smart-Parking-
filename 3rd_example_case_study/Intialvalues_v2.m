
N=10; %number of charging piles
Ns=5; %number of charging piles that can serve SPEVs
Days = 7; %numer of days in prediction horizon
H=24; %prediction horizon

eta_c=0.95; %charging in efficency
eta_d=1/eta_c; %discharging in efficency

eta_c=eta_c*0.25; %charging in efficency
eta_d=eta_d*0.25; %discharging in efficency

Emax=0.85*5; %maximum energy in battery
Emin=0.15*5; %minimum energy in battery

Pmax_inverter=1.5;

% alpha and beta are parameters in cost function to consider the effect of
% the degredation of the battery, and these values could have some specific
% amount, howver when we put them equal to zero, we might face numerical
% instabilities and wrong answers in linprog
alpha=0.000001;
beta=0.000001;

%% Forecasts
% note: we assume that each charging pile requires one time slot to get
% prepared to serve the next EV (It is logical for plugging and unpluging).

%load('prediction_and_plans.mat', 'times_and_SOC', 'c', 'P_solar_spv','P_solar');
load("price_vector.mat")



% times_and_SOC (cars_in_rows, 4, N) contains a big 3D matrix,
% rows shows the number of cars to be served at the whole 7*24 tims slots.
% solumns are 4 and are related to Arrival, Departure, and SOC_initial, SOC_final
% the 3rd dimention is related to the number of CPs.
% c is the cost of electricty at each time slot.
% P_solar is the Solar Power at each time slot
% P_solar_spv is the Solar Power of SPEV at each time slot


