function [E_goal_vector, E0_vector]=...
    Update_E_0_and_E_goal(stp, H, E0_matrix, AD_stp, N, E, E_goal_matrix)

next= stp+1: H + (stp);
E0_matrix_next=E0_matrix(:,next)';

% here we check it the car was present in the current state, the E0 for the
% next state should be updated, otherwise it is not needed.
for ii= 1:N
    if AD_stp(ii,1)>0 % was it present?
        sequences = find_1_to_0_sequences(AD_stp(ii, :)');
        sequence= sequences(1,1):sequences(1,2);
        sequence= sequence-1;
        sequence=sequence(sequence ~= 0);
        E0_matrix_next(sequence,ii)=E(ii,1); % update the E0 of prenent vehecles.
    end
end

E0_vector = E0_matrix_next(:)'; % E0_vector is updated
E_goal_vector=E_goal_matrix(:,next)';
E_goal_vector = E_goal_vector(:)'; % E_goal_vector is updated