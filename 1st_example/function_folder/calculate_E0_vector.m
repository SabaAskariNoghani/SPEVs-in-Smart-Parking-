function E0_vector = calculate_E0_vector(AD, E_0, H)
    N = size(AD, 1);
    E0_vector = zeros(1, N * H);

    for i = 1:N
        sequences = find_1_to_0_sequences(AD(i, :)');
        positions = sequences(:, end);
        E0_vector0 = AD(i, :);
        E0_vector0 = E0_vector_creator(E0_vector0, sequences, E_0(i, 1:size(sequences, 1)));
        E0_vector(1, (i - 1) * H + 1:i * H) = E0_vector0;
    end
end
