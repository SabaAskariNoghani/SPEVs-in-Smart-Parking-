function b2 = b2_modifier_v2 (b2,AD, E0_vector, E_goal_vector, H)

    N = size(AD, 1);

    % E0_vector = calculate_E0_vector (AD, E_0, H);
    % E_goal_vector =calculate_E0_vector (AD, SOC_final, H);
    E0_minus_E_goal = E0_vector - E_goal_vector;

    for i = 1:N

        sequences = find_1_to_0_sequences(AD(i, :)');
        if ~isempty(sequences)
        finalpositions = sequences(:, end);
        % Ensure Emin at the last time slot equals E_goal
        % b2((i - 1) * H + positions) = E_0(i, 1:size(sequences, 1)) - E_goal(i, 1:size(sequences, 1));
        b2((i - 1) * H + finalpositions) =E0_minus_E_goal((i - 1) * H + finalpositions);
        end
    end

end
