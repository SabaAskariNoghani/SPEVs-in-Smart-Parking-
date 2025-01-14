function [P_grid, P_charg, P_discharg, P_c, P_cspv, E] = data_extraction(X, H, N, A1, E0_vector)
P_grid = X(1:H);
P_charg = X(H+1:N*H+H);
P_charg = reshape(P_charg, H, N);
P_discharg = X(N*H+H+1:N*H+H+N*H);
P_discharg = reshape(P_discharg, H, N);
P_c = X(N*H+H+N*H+1:end-N*H);
P_cspv = X(N*H+H+N*H+H+1:end);
P_cspv = reshape(P_cspv, H, N);
E = A1 * X + E0_vector';
E = reshape(E, H, N);
end
