function [P_grid_min, P_grid_max, P_charg_min, P_charg_max,...
    P_discharg_min, P_discharg_max, P_c_min, P_c_max, P_cspv_min, P_cspv_max,P_pile_max]...
    = generate_constraints(AD, P_solar_spv, P_solar, H, N,Pmax_inverter)

    % Define P_grid_min and P_grid_max
    P_grid_min = zeros(1, H);
    P_grid_max = inf * ones(1, H);

    % Define P_charg_min and P_charg_max
    P_charg_min = zeros(1, N*H);
    P_charg_max = Pmax_inverter * ones(1, N*H);
    P_charg_max = P_charg_max .* reshape(AD', 1, []);

    % Define P_discharg_min and P_discharg_max
    P_discharg_min = zeros(1, N*H);
    P_discharg_max = Pmax_inverter * ones(1, N*H);
    P_discharg_max = P_discharg_max .* reshape(AD', 1, []);
    P_pile_max=P_discharg_max;

    % Define P_c_min and P_c_max
    P_c_min = zeros(1, H);
    P_c_max = P_solar; % Assuming P_solar is available solar power

    % Define P_cspv_min and P_cspv_max
    P_cspv_min = zeros(1, N*H);
    P_cspv_max = reshape(P_solar_spv', 1, []);

end
