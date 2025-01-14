% Here, we modeled a charging pile energy managment system

% Solar Powered Electric Vehecles (SPEVs)

% Charging Pile Energy Managment System (CPEMS)

clc
clearvars
close all

% Define the path to the "function_folder" subfolder
addpath('function_folder');

%% here we run the initialvalues mfile.
H=12; %prediction horizon
eta_c=0.95; %charging in efficency
eta_d=1/eta_c; %discharging in efficency
Emax=0.85*5; %maximum energy in battery
Emin=0.15*5; %minimum energy in battery
Pmax_inverter=1.5;

% alpha and beta are parameters in cost function to consider the effect of
% the degredation of the battery, and these values could have some specific
% amount, however when we put them equal to zero, we might face numerical
% instabilities and wrong answers in linprog
alpha=0.000001;
beta=0.000001;

num=5; % indicate which charging pile to be plotted

%% preprocessing
% AD should be a matrix showing where each car is in the parking

load('AD_matrix_s1.mat','AD_matrix');
load('prediction_and_plans.mat', 'c', 'P_solar_spv','P_solar');

load('Arrival_Departure_m.mat','AD_matrix');
% Apply some modification on AD
% We note that there are 168 sensors installed in the street.
% We used the sensors data, and assumed only 74 piles are installed in that
% street. Hence, the data of those sensors are used for AD of those piles.
AD_matrix_m=zeros(size(AD_matrix, 1)/4, size(AD_matrix, 2));
pile_m=0;

for pile= 1:4:size(AD_matrix, 1)

    pile_m=pile_m+1;
    sequences1= find_1_to_0_sequences(AD_matrix(pile, :));
    sequences2= find_1_to_0_sequences(AD_matrix(pile+1, :));
    sequences3= find_1_to_0_sequences(AD_matrix(pile+2, :));
    sequences4= find_1_to_0_sequences(AD_matrix(pile+3, :));

    AD_matrix_m(pile_m, sequences1)=1;
    AD_matrix_m(pile_m, sequences2)=1;
    AD_matrix_m(pile_m, sequences3)=1;
    AD_matrix_m(pile_m, sequences4)=1;

    sequences= find_1_to_0_sequences(AD_matrix_m(pile_m, :));
    length_stay= sequences(:,2)- sequences(:,1);

    for car= 1: size(sequences,1)
        if length_stay(car,1)<3
            AD_matrix_m(pile_m, sequences(car,1):sequences(car,1)+2) = 1;
        end
    end
end

AD_matrix= AD_matrix_m;

N= size(AD_matrix,1);
load('fifteen_minute_data.mat');
c= table2array( fifteen_minute_data(1:size(AD_matrix,2),2));
minValue = min(c);% Shift all components
c= c - minValue;

P_solar= table2array(fifteen_minute_data(1:size(AD_matrix,2),3)).* 100; %100 m^2
P_solar= P_solar';
P_solar_spv= table2array( fifteen_minute_data(1:size(AD_matrix,2),3)); % 1m^2
P_solar_spv= P_solar_spv';
% P_solar_spv= repmat(P_solar_spv, N);
c=c';

E_goal_matrix= AD_matrix;

for pile= 1: size(AD_matrix, 1)
    sequences= find_1_to_0_sequences(AD_matrix(pile, :));
    for car= 1: length(sequences)
        E_goal_matrix(pile, sequences(car, 1): sequences(car, 2))=...
            min(Emax, Pmax_inverter* (sequences(car, 2)- sequences(car, 1)));
        for t= sequences(car, 1): sequences(car, 2)
            E_goal_matrix(pile, t)=...
                max(0, E_goal_matrix(pile, t)- (sequences(car, 2)- t)* Pmax_inverter);
        end
    end
end


% We assume that the cars Enter the market asif their SOC is min
E0_matrix= Emin* AD_matrix;

E0_vector=E0_matrix(:,1:H)'; % first step
E0_vector = E0_vector(:)';
E_goal_vector=E_goal_matrix(:,1:H)';  % first step
E_goal_vector = E_goal_vector(:)';
% E_goal_vector should be modifed for each time interval, it should not be
% constant SOC(D) > E_goal_modified =
% Here we need to check E_goal_vector at each MPC step to be feasible.
%% Initialize
time_length= length(AD_matrix) - H; % whole length of availbele data - H
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

    P_solar_spv_stp =repmat(P_solar_spv (:, current), N,1);

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
    if stp==24
        disp('here')
    end

    [P_grid, P_charg, P_discharg, P_c,P_cspv, E] = data_extraction(X, H, N, A1, E0_vector);
    E= E';
    P_charg= P_charg';
    P_discharg = P_discharg';
    
    % update E_0_stp and E_goal_stp
    if stp< time_length
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