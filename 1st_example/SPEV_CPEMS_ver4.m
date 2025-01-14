% Here, we modeled a charging pile energy managment system

% Solar Powered Electric Vehecles (SPEVs)

% Charging Pile Energy Managment System (CPEMS)

clc
clearvars
close all

% Define the path to the "function_folder" subfolder
addpath('function_folder');

%% here we run the initialvalues mfile.

PL= 1 ; % Example 1 ---> PL = 1 or PL = 3

switch PL
    case 1
        ex1_Intialvalues_EVs; % there are 10 CPs that are covered.
        Pgname= 'Pg_pl1.mat';
    case 2
        ex1_Intialvalues_SPEVs;% there are 10 SPEV-uncompatible CPs 
    case 3
        ex1_Intialvalues_SPEVs;% there are 10 SPEV-compatible CPs 
        Pgname= 'Pg_pl3.mat';
end


num=5; %which charging pile to plot

%%
[P_grid_min, P_grid_max, P_charg_min, P_charg_max,...
    P_discharg_min, P_discharg_max, P_c_min, P_c_max,...
    P_cspv_min, P_cspv_max,P_pile_max] = generate_constraints...
    (AD, P_solar_spv, P_solar, H, N, Pmax_inverter);

lb=[P_grid_min P_charg_min P_discharg_min P_c_min P_cspv_min];
ub=[P_grid_max P_charg_max P_discharg_max P_c_max P_cspv_max];

%% Here we define the constraint on the max and min value of state of charge
% which leads to the A*x<b inequality

% if the parking is not compatible with the SPEVs but serves them.
if PL==2; P_pile_max=1000.*P_pile_max;end

% [A, b, A1] = create_A_and_b(AD, Emax, Emin, eta_c, eta_d, E0_vector,...
    % E_0, E_goal, P_pile_max, P_cspv_max, H, N);
[A, b, A1] = create_A_and_b_v2 (AD, Emax, Emin, eta_c, eta_d, E0_vector...
    , E_goal_vector, P_pile_max, P_cspv_max, H, N);
%% Then we will go for the equality constraints which are related balance as A_eq*x=b_eq
Aeq=[eye(H) repmat(-eye(H),1,N)  repmat(eye(H),1,N)  -eye(H) repmat(-eye(H),1,N)];
beq=-P_solar-sum(P_solar_spv);

%% Here we define the cost function
f=[c alpha*ones(1,N*H) beta*ones(1,N*H) zeros(1,H) zeros(1,N*H)];

%% optimization
options=optimoptions("linprog","Algorithm","interior-point-legacy","OptimalityTolerance",1e-8);
[X,fval,output]=linprog(f,A,b,Aeq,beq,lb,ub,options);

%% Post processing
[P_grid, P_charg, P_discharg, P_c,P_cspv, E] = data_extraction(X, H, N, A1, E0_vector);
save (Pgname,"P_grid")
%% plot the results
plot_data(P_charg, P_discharg, P_c, P_grid, P_solar,P_solar_spv,P_cspv, E, N, H,...
    num,Emin,Emax,Pmax_inverter)
