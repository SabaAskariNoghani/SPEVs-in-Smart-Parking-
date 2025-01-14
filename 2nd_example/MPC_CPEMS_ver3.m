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

PG=zeros(19,1);
CompTime=zeros(19,1);

hh=0;
for H=6:24
    hh=hh+1;

    num=5; % indicate which charging pile to be plotted

    %% preprocessing
    % Here we define three matrixes to save the A, D and SOC(A), SOC(D)
    % Eq. 22 original draft is also related to this function
    [AD_matrix, E0_matrix, E_goal_matrix] =...
        SOC_and_AD(N,H,Days,times_and_SOC, Pmax_inverter,eta_c);
    E0_vector=E0_matrix(:,1:H)'; % first step
    E0_vector = E0_vector(:)';
    E_goal_vector=E_goal_matrix(:,1:H)';  % first step
    E_goal_vector = E_goal_vector(:)';
    % E_goal_vector should be modifed for each time interval, it should not be
    % constant SOC(D) > E_goal_modified =
    % Here we need to check E_goal_vector at each MPC step to be feasible.
    %% Initialize
    simulation_time= 24 * Days - 24; % max= 24 * Days - H
    P_grid_whole= zeros(1, simulation_time);
    P_c_whole = zeros(1, simulation_time);
    P_charg_whole= zeros(N, simulation_time);
    P_discharg_whole= zeros(N, simulation_time);
    P_cspv_whole= zeros(simulation_time, N);
    E_whole= zeros(N, simulation_time);
    %% MPC for 7 days

    for stp = 1: simulation_time
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
        tic
        options=optimoptions("linprog","Algorithm","interior-point-legacy","OptimalityTolerance",1e-8);
        [X,fval,output]=linprog(f,A,b,Aeq,beq,lb,ub,options);
        CompTime(hh)= toc;

        %% Post processing
        [P_grid, P_charg, P_discharg, P_c,P_cspv, E] = data_extraction(X, H, N, A1, E0_vector);
        E= E';
        P_charg= P_charg';
        P_discharg = P_discharg';

        % update E_0_stp and E_goal_stp
        if stp< simulation_time
            [E_goal_vector, E0_vector]=...
                Update_E_0_and_E_goal(stp, H, E0_matrix, AD_stp, N, E, E_goal_matrix);
        end

        P_grid_whole(1, stp)= P_grid(1,1);
        P_c_whole(1, stp) = P_c(1,1);
        P_cspv_whole(stp, :) = P_cspv(1,:);
        P_charg_whole(:, stp)=P_charg(:,1);
        P_discharg_whole(:, stp)= P_discharg(:,1);
        E_whole(:,stp+1)= E(:,1);

    end

    for j= 1: size(E_whole,1)

        time_SOC_pile= times_and_SOC(:,:,j);

        for k= 1: size(time_SOC_pile,1)

            if time_SOC_pile(k, 1) >0 && time_SOC_pile(k, 1)<size(E_whole,2)
                E_whole(j, time_SOC_pile(k, 1))= time_SOC_pile(k, 3);
            end

        end
    end


    %% plot the results
    plot_data_v2(P_charg_whole', P_discharg_whole', P_c_whole, P_grid_whole, P_solar,P_solar_spv,P_cspv_whole, E_whole', H,...
        num,Emin,Emax, simulation_time)

    % Generate a unique filename for each iteration
    filename = sprintf('MPC_H%d.mat', H);

    % Save the result variable to the .mat file
    save(filename);

    PG(hh)= sum(P_grid_whole);


end


% Save the result
save('PG_comtime.mat', "CompTime", "PG");
figure('Position', [20 20 820 220]); % Adjust the width and height as needed
scatter(6:24, PG,50, 'o', 'filled'); % 50 specifies marker size, 'o' is the circle
hold on;
plot(6:24, PG, 'LineWidth', 1.5, 'LineStyle', '-', 'Color', 'b');
% Set the font size for the axes
set(gca, 'FontName', 'Times New Roman', 'FontSize', 12);

% Add labels and title
xlabel('H', 'FontName', 'Times New Roman', 'FontSize', 14);
ylabel('P_g (kW)', 'FontName', 'Times New Roman', 'FontSize', 14);


figure;
plot(6:24, CompTime);


