function [AD_matrix, E0_matrix, E_goal_matrix] =...
    SOC_and_AD(N,H,Days,times_and_SOC, Pmax_inverter,eta_c)
% Here we define three matrixes to have the A, D and SOC(A), SOC(D)
% AD is the presence matrix that indicates the presence of car at the charging pile
AD_matrix=zeros(N,H*Days);
E0_matrix=AD_matrix;
E_goal_matrix= AD_matrix;
% AD_matrix is a matrix that has N rows and H*Days columns,
% It shows 1 when each CP is occupied and 0 when it is free.
% E0_matrix is a matrix that has N rows and H*Days columns,
% It shows SOC_initial when each CP is occupied and 0 when it is free.
% E_goal_matrix is a matrix that has N rows and H*Days columns,
% It shows SOC_final when each CP is occupied and 0 when it is free.
for i=1:N
    for j=1:length(times_and_SOC)
        sequence= times_and_SOC(j,1,i) : times_and_SOC(j,2,i);
        sequence(sequence == 0) = [];
        AD_matrix (i,sequence)= 1;
        E0_matrix (i,sequence)= times_and_SOC(j,3,i);
        E_goal= sequence;
        remained_stp=length(sequence)-1;
        for k= 1:length(E_goal)
            E_goal(k)= max(0, times_and_SOC(j,4,i)- remained_stp*eta_c*Pmax_inverter);
            remained_stp=remained_stp-1;
        end

%% Note: this part is a very important constraint needs to be checked.
% to prevent infeasibility of optimization due to a high SOC(D) with
% regards to Pmax_inverter.
        if ~isempty(E_goal) && E_goal(1)> eta_c*Pmax_inverter
            dif=E_goal(1)-eta_c*Pmax_inverter;
            E_goal=E_goal-dif;
        end

        E_goal_matrix (i,sequence)= E_goal;
    end
end

