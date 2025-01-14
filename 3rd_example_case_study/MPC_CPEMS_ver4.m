% Here, we modeled a charging pile energy managment system

% Solar Powered Electric Vehecles (SPEVs)

% Charging Pile Energy Managment System (CPEMS)

clc
clearvars
close all

% Define the path to the "function_folder" subfolder
addpath('function_folder');

%% here we run the initialvalues mfile.

Intialvalues_v2; % there are 10 SPEV-compatible CPs

num=5; % indicate which charging pile to be plotted


[AD_matrix, E0_matrix, E_goal_matrix] =...
    SOC_and_AD(N,H,Days,times_and_SOC, Pmax_inverter,eta_c);
%% Initialize
% Consider that the data are given in a form that AD is availble from input
% and other parameters should be obtaind accordingly.
% this matrix is build based on the assumption that the
%  SOC(D) <= min ((D-A)Pmax, Emax) This means max possible charge at D
E_goal_matrix=AD_matrix;
for pile= 1: size(AD_matrix, 1)
    sequences= find_1_to_0_sequences(AD_matrix(pile, :));
    for car= 1: length(sequences)
        E_goal_matrix(pile, sequences(car, 1): sequences(car, 2))=...
            min(Emax, Pmax_inverter* (sequences(car, 2)- sequences(car, 1)));
    end
end
% We assume that the cars Enter the market asif their chrgine is min
E0_matrix= Emin* 2* AD_matrix;
% We extract the following from the matrixe for the first step then
% at the end of the loop they are updated.
E0_vector=E0_matrix(:,1:24)'; % first step
E0_vector = E0_vector(:)';
E_goal_vector=E_goal_matrix(:,1:24)';  % first step
E_goal_vector = E_goal_vector(:)';
time_length= length(AD_matrix)- H; % whole length of availbele data - H

%%


P_grid_whole= zeros(1, time_length);
P_c_whole = zeros(1, time_length);
P_charg_whole= zeros(N, time_length);
P_discharg_whole= zeros(N, time_length);
P_cspv_whole= zeros(time_length, N);
E_whole= zeros(N, time_length);
%% MPC
for stp = 1: time_length
disp(stp);
    current= stp: H + (stp-1);
    AD_stp = AD_matrix (:, current);
    P_solar_spv_stp = P_solar_spv (:, current);
    P_solar_stp = P_solar (:, current);
    c_stp=c(:, current);

    [P_grid_min, P_grid_max, P_charg_min, P_charg_max,...
        P_discharg_min, P_discharg_max, P_c_min, P_c_max,...
        P_cspv_min, P_cspv_max,P_pile_max] =...
        generate_constraints (AD_stp, P_solar_spv_stp, P_solar_stp , H, N, Pmax_inverter);

    lb=[P_grid_min P_charg_min P_discharg_min P_c_min P_cspv_min];
    ub=[P_grid_max P_charg_max P_discharg_max P_c_max P_cspv_max];

    %% Here we define the constraint on the max and min value of state of charge
    % which leads to the A*x<b inequality

    [A, b, A1] = create_A_and_b_v2 (AD_stp, Emax, Emin, eta_c, eta_d, E0_vector...
        , E_goal_vector, P_pile_max, P_cspv_max, H, N);

    %% Then we will go for the equality constraints which are related balance as A_eq*x=b_eq
    Aeq=[eye(H) repmat(-eye(H),1,N)  repmat(eye(H),1,N)  -eye(H) repmat(-eye(H),1,N)];
    beq=-P_solar_stp-sum(P_solar_spv_stp);

    %% Here we define the cost function
    f=[c_stp alpha*ones(1,N*H) beta*ones(1,N*H) zeros(1,H) zeros(1,N*H)];

    %% optimization
    options=optimoptions("linprog","Algorithm","interior-point-legacy","OptimalityTolerance",1e-8);
    [X,fval,output]=linprog(f,A,b,Aeq,beq,lb,ub,options);

    %% Post processing
    [P_grid, P_charg, P_discharg, P_c,P_cspv, E] = data_extraction(X, H, N, A1, E0_vector);
    E= E';
    P_charg= P_charg';
    P_discharg = P_discharg';
    
    % update E_0_stp and E_goal_stp
    if stp< H * Days - H
        [E_goal_vector, E0_vector]=...
            Update_E_0_and_E_goal(stp, H, E0_matrix, AD_stp, N, E, E_goal_matrix);
    end

    P_grid_whole(1, stp)= P_grid(1,1);
    P_c_whole(1, stp) = P_c(1,1);
    P_cspv_whole(stp, :) = P_cspv(1,:);
    P_charg_whole(:, stp)=P_charg(:,1);
    P_discharg_whole(:, stp)= P_discharg(:,1);
    E_whole(:,stp)= E(:,1);

end

save('important_results.mat', 'P_charg_whole', 'P_discharg_whole', 'P_c_whole', 'P_grid_whole', 'P_solar', 'P_solar_spv', 'P_cspv_whole', 'E_whole', 'num', 'Emin', 'Emax', 'time_length');


load important_results.mat
%% plot the results
plot_data_v2(P_charg_whole', P_discharg_whole', P_c_whole, P_grid_whole, P_solar,P_solar_spv,P_cspv_whole, E_whole',...
    num,Emin,Emax, time_length)
% here needs to be updated