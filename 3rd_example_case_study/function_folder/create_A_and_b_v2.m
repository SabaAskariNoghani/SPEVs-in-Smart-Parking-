function [A, b,A1] = create_A_and_b_v2(AD, SOCmax, SOCmin, eta_c, eta_d, E0_vector, ...
   E_goal_vector, P_pile_max, P_cspv_max, H, N)

%% SOC < SOC max

CH = zeros(N*H, N*H);
DIS = zeros(N*H, N*H);

for i = 1:N
    % Create a lower triangular matrix from AD matrix
    triangular = create_triangular_from_AD(AD(i,:));
    CH = insertMatrix(CH, eta_c * triangular, i);
    DIS = insertMatrix(DIS, -eta_d * triangular, i);
end

A1 = [zeros(N*H, H), CH, DIS, zeros(N*H, H), zeros(N*H, N*H)];

b1 = reshape(AD', 1, []) * SOCmax - E0_vector;

%% SOC > SOC min

CH = zeros(N*H, N*H);
DIS = zeros(N*H, N*H);

for i = 1:N
    % Create a lower triangular matrix from AD matrix
    triangular = create_triangular_from_AD(AD(i,:));
    CH = insertMatrix(CH, -eta_c * triangular, i);
    DIS = insertMatrix(DIS, eta_d * triangular, i);
end

A2 = [zeros(N*H, H), CH, DIS, zeros(N*H, H), zeros(N*H, N*H)];
b2 = E0_vector - reshape(AD', 1, []) * SOCmin;

%% SOC(D) > SOC_final
% b2 = b2_modifier(b2, AD, E0, SOC_final, H);
b2 = b2_modifier_v2(b2,AD, E0_vector, E_goal_vector, H);
%% d+Psv-Pcv<=Ppmax

A3 = [zeros(N*H, H), zeros(N*H, N*H), eye(N*H, N*H), zeros(N*H, H), -eye(N*H, N*H)];
b3 = P_pile_max - P_cspv_max;

A = [A1; A2; A3];
b = [b1'; b2'; b3'];
end
