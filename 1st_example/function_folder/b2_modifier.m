function b2 = b2_modifier(b2,AD, E_0, E_goal, H)
    N = size(AD, 1);

    for i = 1:N
        sequences = find_1_to_0_sequences(AD(i, :)');
        positions = sequences(:, end);
        % Ensure Emin at the last time slot equals E_goal
        b2((i - 1) * H + positions) = E_0(i, 1:size(sequences, 1)) - E_goal(i, 1:size(sequences, 1));

    end
end
