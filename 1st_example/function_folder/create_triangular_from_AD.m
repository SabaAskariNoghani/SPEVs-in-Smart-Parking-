function triangular = create_triangular_from_AD(AD)
    sequences = find_1_to_0_sequences(AD);
    triangular = zeros(length(AD), length(AD));

    for i = 1:size(sequences, 1)
        start_idx = sequences(i, 1);
        end_idx = sequences(i, 2);
        
        % Create a lower triangular matrix with ones for this sequence
        submatrix = tril(ones(end_idx - start_idx + 1));
        
        % Place the submatrix in the corresponding part of A
        triangular(start_idx:end_idx, start_idx:end_idx) = submatrix;
    end
end
